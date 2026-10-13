
import 'package:devmate/service/ai_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/chat_messages.dart';

final aiServiceProvider=Provider<AiService>((ref){
  return AiService();
});

class ChatState{
  const ChatState({
    this.message=const[],
    this.isLoading=false,
    this.error, required this.messages,
});
  final List<ChatState> messages;
  final bool isLoading;
  final String? error;
  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
    bool clearError = false,
}){

    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }
}


final chatProvider = NotifierProvider<ChatNotifier, ChatState>(ChatNotifier.new);


class ChatNotifier extends NotifierProvider{

}