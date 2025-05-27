import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:Undercover/screens/setup/role_screen.dart';

void main() {
  testWidgets('Role screen shows name and reveals word', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: RoleScreen(
        playerNames: ['Alice', 'Bob'],
        undercoverCount: 1,
      ),
    ));

    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('Tap to Reveal Your Word'), findsOneWidget);

    await tester.tap(find.text('Tap to Reveal Your Word'));
    await tester.pump();

    expect(find.textContaining('(Keep it secret!)'), findsOneWidget);
  });
}
