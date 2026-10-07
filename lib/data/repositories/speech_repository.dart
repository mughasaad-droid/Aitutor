import '../../services/speech_service.dart';

class SpeechRepository {
  final SpeechService _speechService;

  SpeechRepository({SpeechService? speechService})
      : _speechService = speechService ?? SpeechService();

  Future<bool> initialize() => _speechService.initialize();

  Future<bool> startListening({
    required Function(String text) onResult,
    String localeId = 'en_US',
  }) {
    return _speechService.startListening(
      onResult: onResult,
      localeId: localeId,
    );
  }

  Future<void> stopListening() => _speechService.stopListening();

  bool get isListening => _speechService.isListening;

  void dispose() => _speechService.dispose();
}
