import 'package:flutter_test/flutter_test.dart';
import 'package:Undercover/models/player.dart';

void main() {
  group('Win logic tests', () {
    test('Civilians win when all undercovers are eliminated', () {
      List<Player> players = [
        Player(name: 'A', role: PlayerRole.Civilian, word: 'Apple'),
        Player(name: 'B', role: PlayerRole.Civilian, word: 'Apple'),
        Player(name: 'C', role: PlayerRole.Undercover, word: 'Orange')..isAlive = false,
      ];

      final alive = players.where((p) => p.isAlive);
      final undercovers = alive.where((p) => p.role == PlayerRole.Undercover);

      expect(undercovers.isEmpty, true);
    });

    test('Undercover wins when they equal civilians', () {
      List<Player> players = [
        Player(name: 'A', role: PlayerRole.Civilian, word: 'Apple'),
        Player(name: 'B', role: PlayerRole.Undercover, word: 'Orange'),
      ];

      final alive = players.where((p) => p.isAlive);
      final undercovers = alive.where((p) => p.role == PlayerRole.Undercover);
      final civilians = alive.where((p) => p.role == PlayerRole.Civilian);

      expect(undercovers.length >= civilians.length, true);
    });
  });
}
