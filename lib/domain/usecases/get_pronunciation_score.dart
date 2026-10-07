import '../../data/repositories/ai_repository.dart';

class GetPronunciationScoreUseCase {
  final AIRepository _repository;

  GetPronunciationScoreUseCase({AIRepository? repository})
      : _repository = repository ?? AIRepository();

  Future<Map<String, dynamic>> execute({
    required String expectedPhrase,
    required String userSpokenText,
  }) async {
    return _repository.checkPronunciation(
      expected: expectedPhrase,
      spoken: userSpokenText,
    );
  }
}
