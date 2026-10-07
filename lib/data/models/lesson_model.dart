import 'package:hive/hive.dart';
import 'flashcard_model.dart';

part 'lesson_model.g.dart';

@HiveType(typeId: 2)
class LessonModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final List<FlashcardModel> flashcards;

  @HiveField(4)
  final bool isCompleted;

  @HiveField(5)
  final double progress;

  LessonModel({
    required this.id,
    required this.title,
    required this.description,
    required this.flashcards,
    this.isCompleted = false,
    this.progress = 0.0,
  });
}
