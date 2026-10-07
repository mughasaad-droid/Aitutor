import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/flashcard_model.dart';
import '../models/lesson_model.dart';
import '../../services/ai_service.dart';

class LessonRepository {
  final FirebaseFirestore _firestore;
  final AIService _aiService;

  LessonRepository({
    FirebaseFirestore? firestore,
    AIService? aiService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _aiService = aiService ?? AIService();

  /// Load lessons from local JSON file (assets/data/lessons.json)
  Future<List<LessonModel>> loadLocalLessons() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/lessons.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      
      return jsonList.map((json) => LessonModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        flashcards: (json['flashcards'] as List).map((f) => FlashcardModel(
          id: f['id'],
          word: f['word'],
          meaning: f['meaning'],
          exampleSentence: f['example'],
          difficulty: f['difficulty'],
          category: json['title'],
        )).toList(),
      )).toList();
    } catch (e) {
      // Fallback: return hardcoded lessons if JSON not found
      return _getFallbackLessons();
    }
  }

  /// Load lessons from Firebase Firestore
  Future<List<LessonModel>> loadRemoteLessons() async {
    try {
      final snapshot = await _firestore.collection('lessons').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return LessonModel(
          id: doc.id,
          title: data['title'],
          description: data['description'],
          flashcards: (data['flashcards'] as List).map((f) => FlashcardModel(
            id: f['id'],
            word: f['word'],
            meaning: f['meaning'],
            exampleSentence: f['example'],
            difficulty: f['difficulty'],
            category: data['title'],
          )).toList(),
        );
      }).toList();
    } catch (e) {
      return loadLocalLessons();
    }
  }

  /// Generate dynamic flashcards using AI
  Future<List<FlashcardModel>> generateAiFlashcards(String topic) async {
    final data = await _aiService.generateFlashcards(topic);
    return data.asMap().entries.map((entry) => FlashcardModel(
      id: 'ai_${entry.key}',
      word: entry.value['word']!,
      meaning: entry.value['meaning']!,
      exampleSentence: entry.value['example']!,
      difficulty: entry.value['difficulty']!,
      category: topic,
    )).toList();
  }

  List<LessonModel> _getFallbackLessons() {
    return [
      LessonModel(
        id: 'daily_conversation',
        title: 'Daily Conversation',
        description: 'Common phrases for everyday talk',
        flashcards: [
          FlashcardModel(
            id: '1', word: 'How are you?', meaning: 'A greeting to ask about well-being',
            exampleSentence: 'How are you doing today?', difficulty: 'easy', category: 'Daily Conversation',
          ),
          FlashcardModel(
            id: '2', word: 'Thank you', meaning: 'Expression of gratitude',
            exampleSentence: 'Thank you for your help.', difficulty: 'easy', category: 'Daily Conversation',
          ),
          FlashcardModel(
            id: '3', word: 'Nice to meet you', meaning: 'Said when meeting someone for the first time',
            exampleSentence: 'Nice to meet you, I am Ali.', difficulty: 'easy', category: 'Daily Conversation',
          ),
        ],
      ),
      LessonModel(
        id: 'travel',
        title: 'Travel Vocabulary',
        description: 'Words for traveling abroad',
        flashcards: [
          FlashcardModel(
            id: '4', word: 'Airport', meaning: 'Place where airplanes take off and land',
            exampleSentence: 'We arrived at the airport early.', difficulty: 'easy', category: 'Travel',
          ),
          FlashcardModel(
            id: '5', word: 'Reservation', meaning: 'Booking a seat or room in advance',
            exampleSentence: 'I made a reservation at the hotel.', difficulty: 'medium', category: 'Travel',
          ),
        ],
      ),
    ];
  }
}
