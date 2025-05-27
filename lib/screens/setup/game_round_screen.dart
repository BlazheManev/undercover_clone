import 'package:flutter/material.dart';
import 'package:undercover_clone/screens/setup/game_result_screen.dart';
import '../../../models/player.dart';

class GameRoundScreen extends StatefulWidget {
  final List<Player> players;

  const GameRoundScreen({required this.players});

  @override
  State<GameRoundScreen> createState() => _GameRoundScreenState();
}

class _GameRoundScreenState extends State<GameRoundScreen> {
  String? _selectedName;
  String message = '';
  int round = 1;

  List<Player> get alivePlayers =>
      widget.players.where((p) => p.isAlive).toList();

  void _eliminatePlayer() {
    if (_selectedName == null) return;

    final player = widget.players.firstWhere(
      (p) => p.name == _selectedName && p.isAlive,
    );

    setState(() {
      player.isAlive = false;
      message = '${player.name} was eliminated.';
      _selectedName = null;
      round++;
    });

    _checkWinCondition();
  }

  void _checkWinCondition() {
    final alive = alivePlayers;
    final undercovers = alive
        .where((p) => p.role == PlayerRole.Undercover)
        .toList();
    final civilians = alive
        .where((p) => p.role == PlayerRole.Civilian)
        .toList();

    if (undercovers.isEmpty) {
      _endGame(false); // Civilians win
    } else if (civilians.isEmpty || alive.length <= 2) {
      _endGame(true); // Undercover wins
    }
  }

  void _endGame(bool undercoverWins) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            GameResultScreen(undercoverWins: undercoverWins),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Round $round'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/background_without_person.png',
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withAlpha((0.4 * 255).toInt())),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  if (message.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        message,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.orangeAccent,
                        ),
                      ),
                    ),
                  Text(
                    'Vote to Eliminate',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  ...alivePlayers.map(
                    (p) => RadioListTile<String>(
                      title: Text(
                        p.name,
                        style: TextStyle(color: Colors.white),
                      ),
                      value: p.name,
                      groupValue: _selectedName,
                      onChanged: (value) {
                        setState(() {
                          _selectedName = value;
                        });
                      },
                      activeColor: Colors.deepOrange,
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: _eliminatePlayer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    child: Text('Eliminate'),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
