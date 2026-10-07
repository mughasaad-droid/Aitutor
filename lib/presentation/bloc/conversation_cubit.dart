import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/conversation_model.dart';
import '../../services/ai_service.dart';
import '../../data/local/hive_service.dart';

part 'conversation_state.dart';

class ConversationCubit extends Cubit<ConversationState> {
  final AIService _aiService;
  final List<MessageModel> _messages = [];

  ConversationCubit({AIService? aiService}) 
    : _aiService = aiService ?? AIService(),
      super(ConversationInitial()) {
    _loadMessages();
  }

  void _loadMessages() {
    final savedMessages = HiveService.getMessages();
    if (savedMessages.isNotEmpty) {
      _messages.addAll(savedMessages);
      _messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      emit(ConversationLoaded(messages: List.from(_messages)));
    }
  }

  Future<void> sendMessage(String userText) async {
    if (userText.trim().isEmpty) return;

    // Detect language (simple check)
    final detectedLang = _detectLanguage(userText);
    
    // Add user message
    final userMessage = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: userText,
      isUser: true,
      timestamp: DateTime.now(),
      detectedLanguage: detectedLang,
    );
    
    _messages.add(userMessage);
    await HiveService.saveMessage(userMessage);
    
    emit(ConversationLoaded(
      messages: List.from(_messages),
      isLoading: true,
    ));

    try {
      // Convert messages to AI format
      final history = _messages
        .where((m) => !m.isLoading)
        .map((m) => {
          'role': m.isUser ? 'user' : 'assistant',
          'content': m.text,
        })
        .toList();

      // Get AI response
      final aiResponse = await _aiService.sendMessage(
        userMessage: userText,
        conversationHistory: history,
      );

      // Add AI message
      final aiMessage = MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: aiResponse,
        isUser: false,
        timestamp: DateTime.now(),
      );
      
      _messages.add(aiMessage);
      await HiveService.saveMessage(aiMessage);
      
      emit(ConversationLoaded(
        messages: List.from(_messages),
        isLoading: false,
      ));
    } catch (e) {
      emit(ConversationError('Failed to get response: $e'));
    }
  }

  String _detectLanguage(String text) {
    // Simple detection logic
    if (RegExp(r'[\u0600-\u06FF]').hasMatch(text)) {
      return 'ur'; // Urdu script
    } else if (RegExp(r'^[a-zA-Z\\s]+$').hasMatch(text)) {
      return 'en'; // English
    } else {
      return 'ro-ur'; // Roman Urdu or mixed
    }
  }

  void clearConversation() async {
    _messages.clear();
    await HiveService.clearMessages();
    emit(ConversationInitial());
  }
}
