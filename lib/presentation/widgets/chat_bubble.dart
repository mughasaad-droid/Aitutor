import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../data/models/conversation_model.dart';

class ChatBubble extends StatelessWidget {
  final MessageModel message;
  final Function(String word)? onTapWord;

  const ChatBubble({
    super.key,
    required this.message,
    this.onTapWord,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final theme = Theme.of(context);
    
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 4,
              bottom: 4,
              left: isUser ? 50 : 0,
              right: isUser ? 0 : 50,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              gradient: isUser 
                ? LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.9),
                      Colors.white.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
              color: isUser ? null : Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(isUser ? 20 : 4),
                bottomRight: Radius.circular(isUser ? 4 : 20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (message.detectedLanguage != null && message.detectedLanguage != 'en')
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      'Translation: ${message.detectedLanguage!.toUpperCase()}',
                      style: TextStyle(
                        fontSize: 10, 
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary.withOpacity(0.7),
                      ),
                    ),
                  ),
                _buildTappableText(message.text, const Color(0xFF1E293B)), // Prominent Light Black
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 8, left: isUser ? 0 : 8, right: isUser ? 8 : 0),
            child: Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                fontSize: 10,
                color: theme.colorScheme.outline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTappableText(String text, Color textColor) {
    final words = text.split(' ');
    
    return Text.rich(
      TextSpan(
        children: words.map((word) {
          final cleanWord = word.replaceAll(RegExp(r'[^\w\s]'), '');
          return TextSpan(
            text: '$word ',
            style: TextStyle(
              fontSize: 16,
              color: textColor,
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => onTapWord?.call(cleanWord),
          );
        }).toList(),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
