import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healingbee/views/create_note.dart';

void main() async {

  await Firebase.initializeApp();
  testWidgets('Widget should build without any error', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CreateNoteView(note: null, key: UniqueKey()),
      ),
    );

    expect(find.byType(CreateNoteView), findsOneWidget);
  });

  testWidgets('TextFields should accept input', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CreateNoteView(note: null, key: UniqueKey()),
      ),
    );

    final titleField = find.widgetWithText(TextFormField, 'Title');
    final noteField = find.widgetWithText(TextField, 'Note');

    await tester.enterText(titleField, 'Test Title');
    await tester.enterText(noteField, 'Test Note');

    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Test Note'), findsOneWidget);
  });

  testWidgets('Buttons should trigger actions', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CreateNoteView(note: null, key: UniqueKey()),
      ),
    );

    final pinButton = find.byIcon(Icons.push_pin);
    await tester.tap(pinButton);
    await tester.pump();
    expect(find.byIcon(Icons.push_pin_outlined), findsOneWidget);

    final notificationButton = find.byIcon(Icons.notification_add_rounded);
    await tester.tap(notificationButton);
    await tester.pump();
    expect(find.text('Notification Options'), findsOneWidget);
  });

  testWidgets('Speech recognition should update description', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CreateNoteView(note: null, key: UniqueKey()),
      ),
    );

    final microphoneButton = find.byIcon(Icons.mic);
    await tester.tap(microphoneButton);
    await tester.pump();

    // Simulate speech recognition, e.g., "Hello, this is a test note."
    // Ensure that the recognized text is updated in the description field.
    expect(find.text('Hello, this is a test note.'), findsOneWidget);
  });
}
