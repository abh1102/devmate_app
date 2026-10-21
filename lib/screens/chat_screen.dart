
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/chat_messages.dart';
import '../providers/chat_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Future<void> _sendMessage([String? suggestedPrompt]) async {
    final text = (suggestedPrompt ?? _controller.text).trim();

    if (text.isEmpty) return;

    if (ref.read(chatProvider).isLoading) return;

    _controller.clear();

    await ref.read(chatProvider.notifier).sendMessage(text);

    if (mounted && _scrollController.hasClients) {
      await _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            CircleAvatar(
              radius: 17,
              backgroundColor: Color(0xFF6750A4),
              child: Icon(
                Icons.auto_awesome,
                size: 19,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DevMate AI',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Your AI coding companion',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'New chat',
            onPressed: () {
              ref.read(chatProvider.notifier).clearChat();
            },
            icon: const Icon(Icons.add_comment_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: chatState.messages.isEmpty &&
                  !chatState.isLoading
                  ? _buildWelcomeScreen()
                  : ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                itemCount: chatState.messages.length +
                    (chatState.isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == chatState.messages.length) {
                    return const _TypingIndicator();
                  }

                  return _MessageBubble(
                    message: chatState.messages[index],
                  );
                },
              ),
            ),

            if (chatState.error != null)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Could not get a response: ${chatState.error}',
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),

            _buildComposer(chatState.isLoading),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    const suggestions = [
      'Explain a Java interface',
      'Help me debug my code',
      'Teach me Spring Boot',
      'Explain REST APIs',
    ];

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 35,
              backgroundColor: Color(0xFF27213A),
              child: Icon(
                Icons.auto_awesome,
                size: 35,
                color: Color(0xFFB9A5FF),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'What are we building today?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ask questions, understand code, and solve problems with DevMate.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white60),
            ),
            const SizedBox(height: 26),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: suggestions.map((prompt) {
                return ActionChip(
                  label: Text(prompt),
                  onPressed: () => _sendMessage(prompt),
                  backgroundColor: const Color(0xFF22232B),
                  side: const BorderSide(
                    color: Color(0xFF41414C),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComposer(bool isLoading) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFF292A32)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              minLines: 1,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              onSubmitted: (_) => _sendMessage(),
              decoration: InputDecoration(
                hintText: 'Ask DevMate anything...',
                filled: true,
                fillColor: const Color(0xFF22232B),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            tooltip: 'Send message',
            onPressed: isLoading ? null : () => _sendMessage(),
            icon: const Icon(Icons.arrow_upward),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFF8064D8),
              foregroundColor: Colors.white,
              minimumSize: const Size(48, 48),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Align(
      alignment:
      isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.82,
        ),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? const Color(0xFF6750A4)
              : const Color(0xFF22232B),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 18 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 18),
          ),
        ),
        child: SelectableText(
          message.text,
          style: const TextStyle(
            fontSize: 15,
            height: 1.5,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 10),
            Text(
              'DevMate is thinking...',
              style: TextStyle(color: Colors.white60),
            ),
          ],
        ),
      ),
    );
  }
}
