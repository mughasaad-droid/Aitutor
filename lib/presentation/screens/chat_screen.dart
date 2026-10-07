import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/utils/connectivity_helper.dart';
import '../../core/constants/app_strings.dart';
import '../bloc/conversation_cubit.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/mic_button.dart';
import '../widgets/pronunciation_meter.dart';
import '../widgets/no_internet_widget.dart';
import '../widgets/app_background.dart';
import 'settings_screen.dart';
import '../../services/tts_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final TTSService _ttsService = TTSService();
  bool _hasInternet = true;

  @override
  void initState() {
    super.initState();
    _ttsService.initialize();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    final connected = await ConnectivityHelper.isConnected();
    setState(() => _hasInternet = connected);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _ttsService.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _showClearConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat?'),
        content: const Text('This will delete all messages in this conversation.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<ConversationCubit>().clearConversation();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFD1FFD7), // Mint Green
            Color(0xFFB1E5FF), // Sky Blue
            Color(0xFF93C5FD), // Soft Blue
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
            CircleAvatar(
              radius: 22, // Slightly larger
              backgroundColor: Colors.white.withOpacity(0.4),
              backgroundImage: const AssetImage('assets/data/woman.png'),
            ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppStrings.aiTeacherName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                  Text(
                    'Online',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal, color: Color(0xFF065F46)),
                  ),
                ],
              ),
            ],
          ),
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined, color: Colors.black),
              onPressed: () => _showClearConfirmation(context),
              tooltip: 'Clear Conversation',
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
          ],
        ),
        body: Container(
          child: !_hasInternet
              ? NoInternetWidget(onRetry: _checkConnectivity)
              : Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).padding.top + 56),
                    // Pronunciation Score
                    BlocBuilder<ConversationCubit, ConversationState>(
                      builder: (context, state) {
                        if (state is ConversationLoaded &&
                            state.lastPronunciationScore != null) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: PronunciationMeter(
                              score: state.lastPronunciationScore!,
                              feedback: state.lastFeedback ?? '',
                            ).animate().slideY(begin: -0.2, end: 0).fadeIn(),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),

                    // Chat Messages
                    Expanded(
                      child: BlocConsumer<ConversationCubit, ConversationState>(
                        listener: (context, state) {
                          if (state is ConversationLoaded) {
                            _scrollToBottom();
                            if (state.messages.isNotEmpty &&
                                !state.messages.last.isUser &&
                                !state.isLoading) {
                              _ttsService.speak(state.messages.last.text);
                            }
                          }
                        },
                        builder: (context, state) {
                          if (state is ConversationInitial) {
                            return _buildWelcomeScreen();
                          }

                          if (state is ConversationLoaded) {
                            return ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              itemCount: state.messages.length + (state.isLoading ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == state.messages.length) {
                                  return _buildTypingIndicator(theme);
                                }
                                final message = state.messages[index];
                                return ChatBubble(
                                  message: message,
                                  onTapWord: (word) =>
                                      _showWordDefinition(context, word),
                                ).animate().fadeIn(duration: 300.ms).slideX(begin: message.isUser ? 0.1 : -0.1, end: 0);
                              },
                            );
                          }

                          return const Center(child: CircularProgressIndicator());
                        },
                      ),
                    ),

                    // Mic Button Area
                    Container(
                      padding: const EdgeInsets.only(bottom: 24, top: 16),
                      child: const MicButton(),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(ThemeData theme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Text(
              'Ella is thinking...',
              style: TextStyle(fontSize: 12, color: theme.colorScheme.outline),
            ),
          ],
        ),
      ).animate().fadeIn(),
    );
  }

  Widget _buildWelcomeScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            AppStrings.tapToSpeak,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.speakAnyLanguage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _showWordDefinition(BuildContext context, String word) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              word,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Definition: A common English word. Tap to see full meaning from AI.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Example: "This is how you use it in a sentence."',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
