import 'package:hive/hive.dart';

part 'flashcard_model.g.dart';

@HiveType(typeId: 1)
class FlashcardModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String word;

  @HiveField(2)
  final String meaning;

  @HiveField(3)
  final String exampleSentence;

  @HiveField(4)
  final String difficulty;

  @HiveField(5)
  final String category;

  @HiveField(6)
  bool isLearned;

  @HiveField(7)
  int reviewCount;

  FlashcardModel({
    required this.id,
    required this.word,
    required this.meaning,
    required this.exampleSentence,
    required this.difficulty,
    required this.category,
    this.isLearned = false,
    this.reviewCount = 0,
  });
}
