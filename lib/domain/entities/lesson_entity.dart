import 'package:equatable/equatable.dart';

class LessonEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final int totalFlashcards;
  final int completedFlashcards;
  final bool isCompleted;
  final double progress;

  const LessonEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.totalFlashcards,
    required this.completedFlashcards,
    this.isCompleted = false,
    this.progress = 0.0,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        totalFlashcards,
        completedFlashcards,
        isCompleted,
        progress,
      ];
}
