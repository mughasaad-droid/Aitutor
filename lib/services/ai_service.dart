import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:logger/logger.dart';
import '../core/constants/api_constants.dart';

class AIService {
  late final GenerativeModel _model;
  final Logger _logger = Logger();

  static const String _systemPrompt = '''
You are "Ella" - a friendly and professional English teacher. 
Your goal is to help the student learn English efficiently with clear, concise, and direct feedback.

PERSONALITY TRAITS:
- Concise & Direct: Provide point-to-point answers. Avoid long, unnecessary stories or chatting too much.
- Encouraging: Keep it positive but brief (use words like "Good!", "Sahi hai!", "Well done!").
- Professional: Maintain a helpful teacher vibe without being overly talkative.

DYNAMIC LANGUAGE RULES:
1. If the student speaks in Urdu or Roman Urdu, reply in ROMAN URDU with clear and simple instructions.
2. If the student speaks in English, reply in ENGLISH.
3. Switch languages instantly based on the student's input.

TEACHING RULES:
1. CORRECTIONS: Provide English corrections clearly in ENGLISH. 
   Example: "Aapne 'I goes' kaha, sahi version 'I go' hai. Keep it up!"
2. MOTIVATION: End your message with a very short motivational sentence (e.g., "Keep practicing!", "Aap acha seekh rahe hain!").
3. DO NOT ask too many follow-up questions unless necessary for the lesson.
''';

  AIService() {
    _model = GenerativeModel(
      model: ApiConstants.geminiModel,
      apiKey: ApiConstants.geminiApiKey,
      systemInstruction: Content.system(_systemPrompt),
    );
  }

  Future<String> sendMessage({
    required String userMessage,
    required List<Map<String, String>> conversationHistory,
  }) async {
    try {
      final history = conversationHistory.map((m) {
        return m['role'] == 'user' 
            ? Content.text(m['content']!)
            : Content.model([TextPart(m['content']!)]);
      }).toList();

      final chat = _model.startChat(history: history);
      final response = await chat.sendMessage(Content.text(userMessage));
      return response.text ?? "I'm sorry, I didn't catch that. Could you please repeat?";
    } catch (e) {
      _logger.e('Gemini Chat Error: $e');
      return "I'm having a little trouble connecting. Please try again in a moment.";
    }
  }

  Future<Map<String, dynamic>> getPronunciationFeedback({
    required String expectedPhrase,
    required String userSpokenText,
  }) async {
    try {
      final prompt = '''
Compare these two phrases and give pronunciation/grammar feedback:
Expected: "$expectedPhrase"
Student said: "$userSpokenText"

Return ONLY a JSON object:
{
  "score": <number 0-10>,
  "feedback": "<brief friendly feedback>",
  "mistakes": ["<mistake 1>", "<mistake 2>"],
  "correction": "<correct version>"
}
''';

      final response = await _model.generateContent(
        [Content.text(prompt)],
        generationConfig: GenerationConfig(responseMimeType: 'application/json'),
      );

      final content = response.text ?? '{}';
      return jsonDecode(content) as Map<String, dynamic>;
    } catch (e) {
      _logger.e('Gemini Pronunciation Error: $e');
      return {
        'score': 5.0,
        'feedback': 'Good try! Keep practicing.',
        'mistakes': [],
        'correction': expectedPhrase,
      };
    }
  }

  Future<List<Map<String, String>>> generateFlashcards(String topic) async {
    try {
      final prompt = 'Generate 5 English vocabulary flashcards for: "$topic". Return as JSON array of objects with keys: word, meaning, example, difficulty.';

      final response = await _model.generateContent(
        [Content.text(prompt)],
        generationConfig: GenerationConfig(responseMimeType: 'application/json'),
      );

      final List<dynamic> data = jsonDecode(response.text ?? '[]');
      return data.map((item) => (item as Map<String, dynamic>).cast<String, String>()).toList();
    } catch (e) {
      _logger.e('Gemini Flashcard Error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> checkGrammar(String text) async {
    try {
      final prompt = '''
Analyze the following English text for grammar, spelling, and punctuation errors.
Text: "$text"

Return ONLY a JSON object in this format:
{
  "original_text": "$text",
  "corrections": [
    {
      "original": "error phrase",
      "corrected": "correct phrase",
      "reason": "explanation in simple Roman Urdu"
    }
  ],
  "full_corrected_text": "the entire text corrected",
  "overall_feedback": "encouraging feedback from Ella in Roman Urdu"
}
''';

      final response = await _model.generateContent(
        [Content.text(prompt)],
        generationConfig: GenerationConfig(responseMimeType: 'application/json'),
      );

      return jsonDecode(response.text ?? '{}') as Map<String, dynamic>;
    } catch (e) {
      _logger.e('Gemini Grammar Error: $e');
      return {
        'original_text': text,
        'corrections': [],
        'full_corrected_text': text,
        'overall_feedback': 'Oho, kuch masla hua connect karne mein. Phir se try karein!',
      };
    }
  }

  Future<List<Map<String, dynamic>>> generateQuiz() async {
    try {
      final prompt = '''
Generate 5 random English language multiple-choice questions for a Pakistani student learning English.
Each question should have 4 options and 1 correct answer.
Include a brief explanation for the correct answer in Roman Urdu.

Return ONLY a JSON array of objects in this format:
[
  {
    "question": "The question text",
    "options": ["Option A", "Option B", "Option C", "Option D"],
    "answer": 0, // index of the correct option
    "explanation": "Explanation in Roman Urdu"
  }
]
''';

      final response = await _model.generateContent(
        [Content.text(prompt)],
        generationConfig: GenerationConfig(responseMimeType: 'application/json'),
      );

      final List<dynamic> data = jsonDecode(response.text ?? '[]');
      return data.map((item) => (item as Map<String, dynamic>)).toList();
    } catch (e) {
      _logger.e('Gemini Quiz Generation Error: $e');
      return [];
    }
  }
}
