import 'package:speech_to_text/speech_to_text.dart';
import 'package:logger/logger.dart';

class SpeechService {
  final SpeechToText _speech = SpeechToText();
  final Logger _logger = Logger();
  bool _isInitialized = false;

  Future<bool> initialize() async {
    if (_isInitialized) return true;
    _isInitialized = await _speech.initialize(
      onError: (error) => _logger.e('Speech Error: $error'),
      onStatus: (status) => _logger.i('Speech Status: $status'),
    );
    return _isInitialized;
  }

  Future<bool> startListening({
    required Function(String text) onResult,
    String localeId = 'en_US', // Can also use 'ur_PK' for Urdu
  }) async {
    if (!_isInitialized) await initialize();
    
    if (!_speech.isAvailable) {
      _logger.w('Speech recognition not available');
      return false;
    }

    await _speech.listen(
      onResult: (result) {
        if (result.finalResult || result.recognizedWords.isNotEmpty) {
          onResult(result.recognizedWords);
        }
      },
      localeId: localeId,
      listenMode: ListenMode.dictation, // Better for sentences
      partialResults: true, // Show results while speaking
    );
    return true;
  }

  Future<void> stopListening() async {
    await _speech.stop();
  }

  bool get isListening => _speech.isListening;

  void dispose() {
    _speech.cancel();
  }
}
