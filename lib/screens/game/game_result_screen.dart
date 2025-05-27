import 'package:flutter/material.dart';

class GameResultScreen extends StatelessWidget {
  final bool undercoverWins;

  const GameResultScreen({required this.undercoverWins});

  @override
  Widget build(BuildContext context) {
    final bgImage = undercoverWins
        ? 'assets/images/celebration_undercover.png'
        : 'assets/images/celebration_civilians.png';

    final title = undercoverWins
        ? '🕵️ Undercover Wins!'
        : '🟢 Civilians Win!';

    final message = undercoverWins
        ? 'They stayed hidden until the end. Well played.'
        : 'All undercovers were caught. Sharp eyes!';

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(bgImage),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      textStyle: TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Return to Home'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
