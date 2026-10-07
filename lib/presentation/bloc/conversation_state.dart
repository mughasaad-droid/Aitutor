part of 'conversation_cubit.dart';

abstract class ConversationState extends Equatable {
  const ConversationState();

  @override
  List<Object?> get props => [];
}

class ConversationInitial extends ConversationState {}

class ConversationLoading extends ConversationState {}

class ConversationLoaded extends ConversationState {
  final List<MessageModel> messages;
  final bool isLoading;
  final double? lastPronunciationScore;
  final String? lastFeedback;

  const ConversationLoaded({
    required this.messages,
    this.isLoading = false,
    this.lastPronunciationScore,
    this.lastFeedback,
  });

  @override
  List<Object?> get props => [messages, isLoading, lastPronunciationScore, lastFeedback];
}

class ConversationError extends ConversationState {
  final String message;
  const ConversationError(this.message);

  @override
  List<Object?> get props => [message];
}
