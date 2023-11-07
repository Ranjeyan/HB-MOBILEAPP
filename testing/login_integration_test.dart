import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:healingbee/screens/App_home_page.dart';
import 'package:healingbee/main.dart';
import 'package:healingbee/screens/sign_in_page.dart'; // Replace with the actual path to your main.dart

void main() {
  testWidgets('Test login functionality', (WidgetTester tester) async {
    // Initialize Firebase
    await Firebase.initializeApp();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: HomePage(),
    ));

    // Verify that the login page is displayed.
    expect(find.text('LOGIN YOUR ACCOUNT'), findsOneWidget);

    // Enter an email address and password into the text fields.
    await tester.enterText(
        find.byType(TextFormField).at(0), 'rookr0308@gmail.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'rookr03');

    // Tap the "Log in" button.
    await tester.tap(find.text('Log in'));
    await tester
        .pumpAndSettle(); // Wait for animations and navigation to complete

    // Verify that the login process was successful and the user is redirected to the next page.
    expect(find.byType(AppEntryPage), findsOneWidget);
  });
}
