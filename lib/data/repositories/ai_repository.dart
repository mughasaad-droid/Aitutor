import '../models/conversation_model.dart';
import '../../services/ai_service.dart';

class AIRepository {
  final AIService _aiService;

  AIRepository({AIService? aiService}) : _aiService = aiService ?? AIService();

  Future<String> getAIResponse({
    required String userMessage,
    required List<MessageModel> history,
  }) async {
    final conversationHistory = history
        .where((m) => !m.isLoading)
        .map((m) => {
              'role': m.isUser ? 'user' : 'assistant',
              'content': m.text,
            })
        .toList();

    return _aiService.sendMessage(
      userMessage: userMessage,
      conversationHistory: conversationHistory,
    );
  }

  Future<Map<String, dynamic>> checkPronunciation({
    required String expected,
    required String spoken,
  }) async {
    return _aiService.getPronunciationFeedback(
      expectedPhrase: expected,
      userSpokenText: spoken,
    );
  }
}
