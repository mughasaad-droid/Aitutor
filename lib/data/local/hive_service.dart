import 'package:hive_flutter/hive_flutter.dart';
import '../models/conversation_model.dart';
import '../models/lesson_model.dart';
import '../models/user_progress_model.dart';
import '../models/flashcard_model.dart';

class HiveService {
  static const String _messagesBox = 'messages';
  static const String _progressBox = 'progress';
  static const String _flashcardsBox = 'flashcards';

  static Future<void> init() async {
    await Hive.initFlutter();
    
    Hive.registerAdapter(MessageModelAdapter());
    Hive.registerAdapter(FlashcardModelAdapter());
    Hive.registerAdapter(LessonModelAdapter());
    Hive.registerAdapter(UserProgressModelAdapter());
    
    await Hive.openBox<MessageModel>(_messagesBox);
    await Hive.openBox<UserProgressModel>(_progressBox);
    await Hive.openBox<FlashcardModel>(_flashcardsBox);
  }

  static Box<MessageModel> get messagesBox => Hive.box<MessageModel>(_messagesBox);
  static Box<UserProgressModel> get progressBox => Hive.box<UserProgressModel>(_progressBox);
  static Box<FlashcardModel> get flashcardsBox => Hive.box<FlashcardModel>(_flashcardsBox);

  static Future<void> saveMessage(MessageModel message) async {
    await messagesBox.put(message.id, message);
  }

  static List<MessageModel> getMessages() {
    return messagesBox.values.toList();
  }

  static Future<void> clearMessages() async {
    await messagesBox.clear();
  }

  static Future<void> saveProgress(UserProgressModel progress) async {
    await progressBox.put(progress.userId, progress);
  }

  static UserProgressModel? getProgress(String userId) {
    return progressBox.get(userId);
  }
}
