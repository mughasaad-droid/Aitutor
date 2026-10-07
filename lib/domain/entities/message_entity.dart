import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? detectedLanguage;
  final double? pronunciationScore;
  final String? feedback;

  const MessageEntity({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.detectedLanguage,
    this.pronunciationScore,
    this.feedback,
  });

  @override
  List<Object?> get props => [
        id,
        text,
        isUser,
        timestamp,
        detectedLanguage,
        pronunciationScore,
        feedback,
      ];
}
