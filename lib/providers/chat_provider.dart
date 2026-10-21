import 'package:flutter/foundation.dart';

import '../models/chat_messages.dart';
import '../service/ai_service.dart';


import 'package:flutter_riverpod/flutter_riverpod.dart';


final chatProvider =
NotifierProvider<ChatNotifier, ChatState>(ChatNotifier.new);

class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class ChatNotifier extends Notifier<ChatState> {
  late final ChatService _chatService;

  @override
  ChatState build() {
    _chatService = ChatService();
    return const ChatState();
  }

  Future<void> sendMessage(String text) async {
    final prompt = text.trim();

    if (prompt.isEmpty || state.isLoading) return;

    state = state.copyWith(
      messages: [
        ...state.messages,
        ChatMessage(text: prompt, role: MessageRole.user),
      ],
      isLoading: true,
      clearError: true,
    );

    try {
      final answer = await _chatService.sendMessage(prompt);

      state = state.copyWith(
        messages: [
          ...state.messages,
          ChatMessage(text: answer, role: MessageRole.assistant),
        ],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearChat() {
    if (state.isLoading) return;
    state = const ChatState();
  }
}
