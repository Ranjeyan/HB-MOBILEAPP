import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healingbee/Assesment/results_screen.dart';

void main() {
  testWidgets('ResultsScreen widget test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ResultsScreen(15, 10),
    ));

    // Verify that the PHQ-9 Score is displayed
    expect(find.text('PHQ-9 Score: 10'), findsOneWidget);

    // Verify that the GAD-7 Score is displayed
    expect(find.text('GAD-7 Score: 15'), findsOneWidget);

  });
}
