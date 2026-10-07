import 'package:hive/hive.dart';

part 'conversation_model.g.dart';

@HiveType(typeId: 0)
class MessageModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String text;

  @HiveField(2)
  final bool isUser;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  final String? detectedLanguage;

  @HiveField(5)
  final double? pronunciationScore;

  @HiveField(6)
  final String? feedback;

  @HiveField(7)
  final bool isLoading;

  MessageModel({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.detectedLanguage,
    this.pronunciationScore,
    this.feedback,
    this.isLoading = false,
  });

  MessageModel copyWith({
    String? id,
    String? text,
    bool? isUser,
    DateTime? timestamp,
    String? detectedLanguage,
    double? pronunciationScore,
    String? feedback,
    bool? isLoading,
  }) {
    return MessageModel(
      id: id ?? this.id,
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      detectedLanguage: detectedLanguage ?? this.detectedLanguage,
      pronunciationScore: pronunciationScore ?? this.pronunciationScore,
      feedback: feedback ?? this.feedback,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
