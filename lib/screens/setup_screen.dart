import 'package:flutter/material.dart';
import '../components/custom_button.dart';

class SetupScreen extends StatefulWidget {
  @override
  _SetupScreenState createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  double _playerCount = 6;
  int _undercoverCount = 1;

  @override
  Widget build(BuildContext context) {
    int totalPlayers = _playerCount.toInt();
    int maxUndercover = (totalPlayers / 2).floor() - 1;
    if (maxUndercover < 1) maxUndercover = 1;
    if (_undercoverCount > maxUndercover) {
      _undercoverCount = maxUndercover;
    }

    int civilians = totalPlayers - _undercoverCount;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Setup Game'),
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
                  Text(
                    'Select Number of Players',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Slider(
                    value: _playerCount,
                    min: 3,
                    max: 12,
                    divisions: 9,
                    label: _playerCount.toInt().toString(),
                    activeColor: Colors.deepPurpleAccent,
                    onChanged: (value) {
                      setState(() {
                        _playerCount = value;
                        int newMax = (value.toInt() / 2).floor() - 1;
                        if (newMax < 1) newMax = 1;
                        if (_undercoverCount > newMax) {
                          _undercoverCount = newMax;
                        }
                      });
                    },
                  ),
                  Text(
                    '${_playerCount.toInt()} Players',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Undercover Players',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (_undercoverCount > 1) {
                            setState(() {
                              _undercoverCount--;
                            });
                          }
                        },
                        icon: Icon(Icons.remove_circle_outline),
                        color: Colors.redAccent,
                        iconSize: 32,
                      ),
                      Text(
                        '$_undercoverCount',
                        style: TextStyle(fontSize: 28, color: Colors.white),
                      ),
                      IconButton(
                        onPressed: () {
                          if (_undercoverCount < maxUndercover) {
                            setState(() {
                              _undercoverCount++;
                            });
                          }
                        },
                        icon: Icon(Icons.add_circle_outline),
                        color: Colors.greenAccent,
                        iconSize: 32,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Civilians: $civilians',
                    style: TextStyle(fontSize: 18, color: Colors.greenAccent),
                  ),
                  Text(
                    'Undercover: $_undercoverCount',
                    style: TextStyle(fontSize: 18, color: Colors.redAccent),
                  ),
                  Spacer(),
                  CustomButton(
                    text: 'Continue',
                    onPressed: () {
                      // Next screen logic here
                    },
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
