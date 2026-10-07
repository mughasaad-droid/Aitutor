class ApiConstants {
  ApiConstants._();

  // Gemini (Google AI)
  static const String geminiModel = 'gemini-3.1-flash-lite-preview'; // Latest frontier lite model for 2026
  static const String geminiApiKey = 'YOUR_GEMINI_API_KEY_HERE';

  // OpenAI (Backup)
  static const String openAiBaseUrl = 'https://api.openai.com/v1';
  static const String openAiModel = 'gpt-4o';
  static const String openAiApiKey = 'YOUR_OPENAI_API_KEY_HERE';

  // ElevenLabs (Optional - for premium AI voice)
  static const String elevenLabsBaseUrl = 'https://api.elevenlabs.io/v1';
  static const String elevenLabsApiKey = 'YOUR_ELEVENLABS_API_KEY_HERE';
  static const String elevenLabsVoiceId = '21m00Tcm4TlvDq8ikWAM'; // Rachel

  // Google Cloud Speech-to-Text (Optional)
  static const String googleSpeechApiKey = 'YOUR_GOOGLE_CLOUD_API_KEY_HERE';
}
