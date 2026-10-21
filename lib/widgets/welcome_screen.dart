import 'package:flutter/material.dart';

import 'chat_colors.dart';

/// Empty state shown before the first message, with suggestion cards.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key, required this.onSuggestionTap});

  /// Called with the suggested prompt when a card is tapped.
  final ValueChanged<String> onSuggestionTap;

  static const _suggestions = [
    (
      icon: Icons.code_rounded,
      title: 'Explain code',
      subtitle: 'Understand any code snippet',
      prompt: 'Explain a Java interface with an example',
    ),
    (
      icon: Icons.bug_report_outlined,
      title: 'Debug code',
      subtitle: 'Find bugs and fix errors',
      prompt: 'Help me debug my code',
    ),
    (
      icon: Icons.account_tree_outlined,
      title: 'Learn Spring Boot',
      subtitle: 'Build real backend APIs',
      prompt: 'Teach me Spring Boot step by step',
    ),
    (
      icon: Icons.api_rounded,
      title: 'REST APIs',
      subtitle: 'Learn API design and HTTP',
      prompt: 'Explain REST APIs with a Spring Boot example',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 54),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: ChatColors.purple.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: ChatColors.purple.withValues(alpha: 0.22),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: ChatColors.purple,
                        size: 14,
                      ),
                      SizedBox(width: 7),
                      Text(
                        'YOUR AI DEVELOPER TOOLKIT',
                        style: TextStyle(
                          color: Color(0xFFC8B7FF),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                const Text(
                  'Hey, developer.',
                  style: TextStyle(
                    color: ChatColors.muted,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "What are we\nbuilding today?",
                  style: TextStyle(
                    color: ChatColors.text,
                    fontSize: 36,
                    height: 1.12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.5,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'From your first API to complex architecture, '
                  'let’s solve it together.',
                  style: TextStyle(
                    color: ChatColors.muted,
                    fontSize: 14,
                    height: 1.7,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'WHAT CAN I HELP WITH?',
                  style: TextStyle(
                    color: Color(0xFF77758C),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.4,
                  ),
                ),
                const SizedBox(height: 14),
                LayoutBuilder(
                  builder: (context, gridConstraints) {
                    final columns = gridConstraints.maxWidth >= 560 ? 2 : 1;
                    final cardWidth =
                        (gridConstraints.maxWidth - (columns - 1) * 12) /
                        columns;

                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _suggestions.map((item) {
                        return SizedBox(
                          width: cardWidth,
                          child: Material(
                            color: ChatColors.surface,
                            borderRadius: BorderRadius.circular(18),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(18),
                              onTap: () => onSuggestionTap(item.prompt),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.07),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 43,
                                      height: 43,
                                      decoration: BoxDecoration(
                                        color: ChatColors.purple.withValues(
                                          alpha: 0.12,
                                        ),
                                        borderRadius: BorderRadius.circular(13),
                                      ),
                                      child: Icon(
                                        item.icon,
                                        color: ChatColors.purple,
                                        size: 21,
                                      ),
                                    ),
                                    const SizedBox(width: 13),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.title,
                                            style: const TextStyle(
                                              color: ChatColors.text,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            item.subtitle,
                                            style: const TextStyle(
                                              color: ChatColors.muted,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_outward_rounded,
                                      size: 16,
                                      color: Color(0xFF77758C),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: 25),
                Center(
                  child: Text(
                    'Powered by AI  ·  Built for developers',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.30),
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
