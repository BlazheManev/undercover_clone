import 'package:flutter/material.dart';
import 'package:undercover_clone/screens/setup/game_result_screen.dart';
import '../../../models/player.dart';
import '../../../components/custom_button.dart';

class GameRoundScreen extends StatefulWidget {
  final List<Player> players;

  const GameRoundScreen({required this.players});

  @override
  State<GameRoundScreen> createState() => _GameRoundScreenState();
}

class _GameRoundScreenState extends State<GameRoundScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedName;
  String message = '';
  int round = 1;
  bool showVoting = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _pulseAnimation = Tween(begin: 1.0, end: 1.07).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  List<Player> get alivePlayers =>
      widget.players.where((p) => p.isAlive).toList();

  int get remainingUndercovers =>
      alivePlayers.where((p) => p.role == PlayerRole.Undercover).length;

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
      showVoting = false;
    });

    Future.microtask(() => _checkWinCondition());
  }

  void _checkWinCondition() {
    final alive = alivePlayers;
    final undercovers = alive.where((p) => p.role == PlayerRole.Undercover);
    final civilians = alive.where((p) => p.role == PlayerRole.Civilian);

    if (undercovers.isEmpty) {
      _endGame(false);
    } else if (civilians.isEmpty || alive.length <= 2) {
      _endGame(true);
    }
  }

  void _endGame(bool undercoverWins) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GameResultScreen(undercoverWins: undercoverWins),
      ),
    );
  }

  Future<bool> _confirmExit() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Exit Game?'),
        content: Text('If you go back now, the current game will be canceled.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Exit'),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _confirmExit,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text('Round $round'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              if (await _confirmExit()) {
                Navigator.of(context).pop();
              }
            },
          ),
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
                    if (showVoting || message.isNotEmpty)
                      Column(
                        children: [
                          if (message.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                message,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.orangeAccent,
                                ),
                              ),
                            ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12),
                            margin: EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: Text(
                              '💬 Discuss and then vote somebody out by pointing simultaneously!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white30),
                      ),
                      child: Column(
                        children: [
                          Text(
                            showVoting
                                ? 'Vote to Eliminate'
                                : 'Describe your word',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '🕵️ Remaining Undercover(s): $remainingUndercovers',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (!showVoting) ...[
                            SizedBox(height: 8),
                            Text(
                              'Each player describes their secret word in the given order.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: alivePlayers.map((p) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.deepPurple,
                              child: Text(
                                p.name.substring(0, 1).toUpperCase(),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              p.name,
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: showVoting
                                ? Radio<String>(
                                    value: p.name,
                                    groupValue: _selectedName,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedName = value;
                                      });
                                    },
                                    activeColor: Colors.deepOrange,
                                  )
                                : null,
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 20),
                    showVoting
                        ? CustomButton(
                            text: 'Eliminate',
                            onPressed: _eliminatePlayer,
                          )
                        : ScaleTransition(
                            scale: _pulseAnimation,
                            child: CustomButton(
                              text: 'Start Voting',
                              onPressed: () {
                                setState(() {
                                  showVoting = true;
                                });
                                _pulseController.stop();
                              },
                            ),
                          ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
