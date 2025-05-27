import 'package:flutter_test/flutter_test.dart';
import 'package:Undercover/screens/setup/setup_screen.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Setup screen renders slider and buttons', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SetupScreen(),
      ),
    );

    expect(find.text('Select Number of Players'), findsOneWidget);
    expect(find.byType(Slider), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });
}
