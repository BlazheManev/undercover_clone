enum PlayerRole { Civilian, Undercover } 
// for future imporvments as i saw in the game it has more roles

class Player {
  final String name;
  final PlayerRole role;
  final String word;
  bool isAlive;

  Player({
    required this.name,
    required this.role,
    required this.word,
    this.isAlive = true,
  });
}
