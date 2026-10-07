import '../entities/message_entity.dart';
import '../../data/repositories/ai_repository.dart';

class SendMessageUseCase {
  final AIRepository _repository;

  SendMessageUseCase({AIRepository? repository})
      : _repository = repository ?? AIRepository();

  Future<String> execute({
    required String userMessage,
    required List<MessageEntity> history,
  }) async {
    // In a real implementation, you might convert entities to models here
    // For now, following the user's provided structure
    return _repository.getAIResponse(
      userMessage: userMessage,
      history: [], // Repository handles conversation context internally or via global state
    );
  }
}
