import 'package:hive/hive.dart';

part 'user_progress_model.g.dart';

@HiveType(typeId: 3)
class UserProgressModel {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  int totalMessagesSent;

  @HiveField(2)
  int totalWordsLearned;

  @HiveField(3)
  int currentStreak;

  @HiveField(4)
  int longestStreak;

  @HiveField(5)
  double speakingScore;

  @HiveField(6)
  double listeningScore;

  @HiveField(7)
  double readingScore;

  @HiveField(8)
  double writingScore;

  @HiveField(9)
  List<DateTime> practiceDates;

  @HiveField(10)
  DateTime? lastPracticeDate;

  UserProgressModel({
    required this.userId,
    this.totalMessagesSent = 0,
    this.totalWordsLearned = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.speakingScore = 0.0,
    this.listeningScore = 0.0,
    this.readingScore = 0.0,
    this.writingScore = 0.0,
    List<DateTime>? practiceDates,
    this.lastPracticeDate,
  }) : practiceDates = practiceDates ?? [];
}
