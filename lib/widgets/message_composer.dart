import 'package:flutter/material.dart';

import 'chat_colors.dart';

/// Input bar pinned to the bottom of the chat screen.
class MessageComposer extends StatelessWidget {
  const MessageComposer({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isLoading,
    required this.onSend,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isLoading;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 10),
      decoration: BoxDecoration(
        color: ChatColors.bg,
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: ChatColors.surface,
              borderRadius: BorderRadius.circular(23),
              border: Border.all(
                color: ChatColors.purple.withValues(alpha: 0.20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    minLines: 1,
                    maxLines: 5,
                    enabled: !isLoading,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    style: const TextStyle(
                      color: ChatColors.text,
                      fontSize: 14,
                      height: 1.5,
                    ),
                    onSubmitted: (_) {
                      if (!controller.text.contains('\n')) {
                        onSend();
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: 'Ask anything about code...',
                      hintStyle: TextStyle(
                        color: Color(0xFF77758C),
                        fontSize: 13,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.fromLTRB(18, 16, 8, 16),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(7),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: isLoading
                          ? null
                          : const LinearGradient(
                              colors: [Color(0xFFB59AFF), Color(0xFF8056EB)],
                            ),
                      color: isLoading ? ChatColors.surface2 : null,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: IconButton(
                      tooltip: 'Send message',
                      onPressed: isLoading ? null : onSend,
                      icon: Icon(
                        isLoading
                            ? Icons.hourglass_top_rounded
                            : Icons.arrow_upward_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 46,
                        minHeight: 46,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'DevMate can make mistakes. Verify important code before using it.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF666478), fontSize: 10),
          ),
        ],
      ),
    );
  }
}
