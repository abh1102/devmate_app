import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/chat_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: DevMateApp(),
    ),
  );
}

class DevMateApp extends StatelessWidget {
  const DevMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatScreen(),
    );
  }
}