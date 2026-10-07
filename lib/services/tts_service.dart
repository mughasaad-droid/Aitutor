import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_constants.dart';

class TTSService {
  final FlutterTts _flutterTts = FlutterTts();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Dio _dio = Dio();
  final Logger _logger = Logger();

  Future<void> initialize() async {
    // Initialize system TTS as fallback
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.45);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setVolume(1.0);
  }

  Future<void> speak(String text) async {
    if (text.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final voiceId = prefs.getString('voice_id') ?? ApiConstants.elevenLabsVoiceId;
    final stability = prefs.getDouble('voice_tone') ?? 0.5;

    // Detect if text is Urdu/Roman Urdu
    bool isUrdu = _isUrduOrRomanUrdu(text);

    // Try ElevenLabs first with Multilingual model
    if (ApiConstants.elevenLabsApiKey.isNotEmpty && 
        !ApiConstants.elevenLabsApiKey.contains('YOUR_')) {
      try {
        await _speakWithElevenLabs(text, voiceId, stability);
        return;
      } catch (e) {
        _logger.e('ElevenLabs Error: $e');
      }
    }

    // Fallback to system TTS with correct locale
    await _flutterTts.stop();
    if (isUrdu) {
      await _flutterTts.setLanguage('ur-PK');
    } else {
      await _flutterTts.setLanguage('en-US');
    }
    await _flutterTts.speak(text);
  }

  bool _isUrduOrRomanUrdu(String text) {
    // Check for Urdu script
    if (RegExp(r'[\u0600-\u06FF]').hasMatch(text)) return true;
    
    // Simple Roman Urdu detection (checking common words)
    List<String> romanUrduKeywords = ['hain', 'hai', 'mein', 'kya', 'kyun', 'nahi', 'samajh', 'aap', 'kaise'];
    String lowerText = text.toLowerCase();
    for (var word in romanUrduKeywords) {
      if (lowerText.contains(word)) return true;
    }
    return false;
  }

  Future<void> _speakWithElevenLabs(String text, String voiceId, double stability) async {
    final url = '${ApiConstants.elevenLabsBaseUrl}/text-to-speech/$voiceId';
    
    final response = await _dio.post(
      url,
      options: Options(
        headers: {
          'xi-api-key': ApiConstants.elevenLabsApiKey,
          'Content-Type': 'application/json',
          'accept': 'audio/mpeg',
        },
        responseType: ResponseType.bytes,
      ),
      data: {
        'text': text,
        'model_id': 'eleven_multilingual_v2', // Better for Urdu
        'voice_settings': {
          'stability': stability,
          'similarity_boost': 0.75,
        }
      },
    );

    if (response.statusCode == 200) {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/tts_audio.mp3');
      await file.writeAsBytes(response.data);

      await _audioPlayer.setFilePath(file.path);
      await _audioPlayer.play();
    } else {
      throw Exception('Failed to generate speech from ElevenLabs');
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
    await _audioPlayer.stop();
  }

  void dispose() {
    _flutterTts.stop();
    _audioPlayer.dispose();
  }
}
