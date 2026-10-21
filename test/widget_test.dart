// Smoke test for the chat UI: verifies the refactored widgets render
// the welcome state, message list scaffold, and composer correctly.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:devmate/main.dart';
import 'package:devmate/widgets/message_composer.dart';
import 'package:devmate/widgets/welcome_screen.dart';

void main() {
  testWidgets('Chat screen renders welcome state and composer', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: DevMateApp()));
    await tester.pump();

    // App bar.
    expect(find.text('DevMate'), findsOneWidget);

    // Welcome screen (empty chat).
    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(find.text('Hey, developer.'), findsOneWidget);
    expect(find.text('Explain code'), findsOneWidget);

    // Composer.
    expect(find.byType(MessageComposer), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });
}
