import 'package:flutter/material.dart';
import 'dart:math';
import '../game/game_round_screen.dart';
import '../../../models/player.dart';

class RoleScreen extends StatefulWidget {
  final List<String> playerNames;
  final int undercoverCount;

  const RoleScreen({
    required this.playerNames,
    required this.undercoverCount,
  });

  @override
  State<RoleScreen> createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
  late List<Map<String, String>> assignedRoles;
  int currentPlayerIndex = 0;
  bool wordRevealed = false;

  final List<List<String>> wordPairs = [
    ['Cat', 'Tiger'],
    ['Coffee', 'Tea'],
    ['Ship', 'Boat'],
    ['Moon', 'Sun'],
    ['Apple', 'Orange'],
  ];

  @override
  void initState() {
    super.initState();
    assignedRoles = _generateRoles();
  }

  List<Map<String, String>> _generateRoles() {
    List<Map<String, String>> result = [];
    final totalPlayers = widget.playerNames.length;
    final civiliansCount = totalPlayers - widget.undercoverCount;

    final pair = wordPairs[Random().nextInt(wordPairs.length)];
    final civilianWord = pair[0];
    final undercoverWord = pair[1];

    List<String> roles = List.generate(civiliansCount, (_) => 'Civilian') +
        List.generate(widget.undercoverCount, (_) => 'Undercover');
    roles.shuffle();

    for (int i = 0; i < totalPlayers; i++) {
      final role = roles[i];
      result.add({
        'name': widget.playerNames[i],
        'role': role,
        'word': role == 'Undercover' ? undercoverWord : civilianWord,
      });
    }

    return result;
  }

  void _revealWord() {
    setState(() {
      wordRevealed = true;
    });
  }

  void _nextPlayer() {
    if (currentPlayerIndex < widget.playerNames.length - 1) {
      setState(() {
        currentPlayerIndex++;
        wordRevealed = false;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => GameRoundScreen(
            players: assignedRoles.map((data) {
              return Player(
                name: data['name']!,
                role: data['role'] == 'Undercover'
                    ? PlayerRole.Undercover
                    : PlayerRole.Civilian,
                word: data['word']!,
              );
            }).toList(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = assignedRoles[currentPlayerIndex];

    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: Text('Player ${currentPlayerIndex + 1}'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                current['name'] ?? '',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              if (!wordRevealed)
                ElevatedButton(
                  onPressed: _revealWord,
                  child: Text('Tap to Reveal Your Word'),
                )
              else
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Text(
                          current['word'] ?? '',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          '(Keep it secret!)',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 40),
              if (wordRevealed)
                ElevatedButton(
                  onPressed: _nextPlayer,
                  child: Text(
                    currentPlayerIndex == widget.playerNames.length - 1
                        ? 'Start Game'
                        : 'Next',
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
