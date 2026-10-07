import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../bloc/conversation_cubit.dart';
import '../../services/speech_service.dart';

class MicButton extends StatefulWidget {
  const MicButton({super.key});

  @override
  State<MicButton> createState() => _MicButtonState();
}

class _MicButtonState extends State<MicButton> with SingleTickerProviderStateMixin {
  final SpeechService _speechService = SpeechService();
  bool _isListening = false;
  String _recognizedText = '';
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _speechService.initialize();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _speechService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isListening)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Text(
              _recognizedText.isEmpty ? 'Ella is listening...' : _recognizedText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ).animate(onPlay: (c) => c.repeat()).fadeIn(),
          ),
        GestureDetector(
          onLongPressStart: (_) => _handleStart(),
          onLongPressEnd: (_) => _handleStop(),
          onLongPressCancel: () => _handleStop(),
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isListening 
                    ? theme.colorScheme.primary.withOpacity(0.1)
                    : theme.colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: (_isListening ? theme.colorScheme.primary : Colors.grey).withOpacity(0.2),
                      blurRadius: _isListening ? 20 * _animationController.value : 10,
                      spreadRadius: _isListening ? 10 * _animationController.value : 0,
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: _isListening 
                          ? [theme.colorScheme.primary, theme.colorScheme.secondary]
                          : [Colors.blue.shade400, Colors.blue.shade600],
                      ),
                    ),
                    child: Icon(
                      _isListening ? Icons.mic : Icons.mic_none,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _isListening ? 'Release to Send' : 'Hold to Speak',
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.outline,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Future<void> _handleStart() async {
    setState(() {
      _isListening = true;
      _recognizedText = '';
    });
    
    final success = await _speechService.startListening(
      onResult: (text) {
        setState(() {
          _recognizedText = text;
        });
      },
    );
    
    if (!success) {
      setState(() => _isListening = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not start microphone')),
        );
      }
    }
  }

  Future<void> _handleStop() async {
    if (!_isListening) return;
    
    final finalMessage = _recognizedText;
    setState(() {
      _isListening = false;
      _recognizedText = '';
    });
    
    await _speechService.stopListening();
    
    if (finalMessage.trim().isNotEmpty) {
      if (mounted) {
        context.read<ConversationCubit>().sendMessage(finalMessage);
      }
    }
  }
}
