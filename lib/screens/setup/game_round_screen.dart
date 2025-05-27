import 'package:flutter/material.dart';
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

    Future.delayed(Duration(seconds: 2), () {
      _checkWinCondition();
    });
  }

  void _checkWinCondition() {
    final alive = alivePlayers;
    final undercovers =
        alive.where((p) => p.role == PlayerRole.Undercover);
    alive.where((p) => p.role == PlayerRole.Civilian);

    if (undercovers.isEmpty) {
      _endGame('Civilians win! All Undercover players eliminated.');
    } else if (alive.length <= 2) {
      _endGame('Undercover wins! Only 2 players remain.');
    }
  }

  void _endGame(String result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text('Game Over'),
        content: Text(result),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: Text('Return to Home'),
          )
        ],
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
                        style: TextStyle(fontSize: 16, color: Colors.orangeAccent),
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
                      title: Text(p.name, style: TextStyle(color: Colors.white)),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
