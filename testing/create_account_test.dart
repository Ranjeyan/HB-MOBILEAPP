import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:healingbee/screens/create_account.dart';
import 'package:healingbee/main.dart'; // Import your app's main file

void main() {
  setUpAll(() async {
    // Initialize Firebase for testing
    await Firebase.initializeApp();
  });

  testWidgets('Test Create Account Page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: CreateAccountPage(),
    ));

    // Verify that 'Create an Account' text is present.
    expect(find.text('Create an\nAccount'), findsOneWidget);

    // Fill in the name, email, and password fields.
    await tester.enterText(find.byType(TextFormField).at(0), 'John Doe'); // Full name
    await tester.enterText(find.byType(TextFormField).at(1), 'johndoe@example.com'); // Email
    await tester.enterText(find.byType(TextFormField).at(2), 'password123'); // Password

    // Tap the 'Sign Up' button.
    await tester.tap(find.text('Sign Up'));
    await tester.pump();

    // You can add more test cases to validate other behaviors as well.
  });
}
