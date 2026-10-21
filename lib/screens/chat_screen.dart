import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/chat_provider.dart';
import '../widgets/chat_colors.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_composer.dart';
import '../widgets/typing_indicator.dart';
import '../widgets/welcome_screen.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();

  Future<void> _sendMessage([String? prompt]) async {
    final text = (prompt ?? _controller.text).trim();

    if (text.isEmpty || ref.read(chatProvider).isLoading) return;

    _controller.clear();
    _focusNode.unfocus();

    await ref.read(chatProvider.notifier).sendMessage(text);

    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatProvider);

    return Scaffold(
      backgroundColor: ChatColors.bg,
      appBar: AppBar(
        backgroundColor: ChatColors.bg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 18,
        title: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  colors: [Color(0xFFB69AFF), Color(0xFF7650E8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: ChatColors.purple.withValues(alpha: 0.25),
                    blurRadius: 18,
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 23,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DevMate',
                    style: TextStyle(
                      color: ChatColors.text,
                      fontWeight: FontWeight.w800,
                      fontSize: 19,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.circle, size: 7, color: Color(0xFF69DBA2)),
                      SizedBox(width: 6),
                      Text(
                        'AI coding companion',
                        style: TextStyle(
                          color: ChatColors.muted,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'New chat',
            onPressed: state.isLoading
                ? null
                : () => ref.read(chatProvider.notifier).clearChat(),
            icon: const Icon(
              Icons.add_rounded,
              color: ChatColors.text,
              size: 25,
            ),
            style: IconButton.styleFrom(
              backgroundColor: ChatColors.surface2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.06),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: state.messages.isEmpty && !state.isLoading
                  ? WelcomeScreen(onSuggestionTap: _sendMessage)
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
                      itemCount:
                          state.messages.length + (state.isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == state.messages.length) {
                          return const TypingIndicator();
                        }

                        return MessageBubble(message: state.messages[index]);
                      },
                    ),
            ),
            if (state.error != null)
              Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF351D29),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFFF647C).withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: Color(0xFFFF8195),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Something went wrong: ${state.error}',
                        style: const TextStyle(
                          color: Color(0xFFFFB8C3),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            MessageComposer(
              controller: _controller,
              focusNode: _focusNode,
              isLoading: state.isLoading,
              onSend: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
