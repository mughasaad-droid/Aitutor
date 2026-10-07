import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import '../../services/ai_service.dart';
import '../widgets/app_background.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final AIService _aiService = AIService();
  List<Map<String, dynamic>> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isAnswered = false;
  bool _isLoading = true;
  int? _selectedOptionIndex;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _loadQuiz();
  }

  Future<void> _loadQuiz() async {
    setState(() => _isLoading = true);
    try {
      final questions = await _aiService.generateQuiz();
      if (mounted) {
        setState(() {
          _questions = questions;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load quiz. Please try again.')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _handleOptionTap(int index) {
    if (_isAnswered) return;
    setState(() {
      _selectedOptionIndex = index;
      _isAnswered = true;
      if (index == _questions[_currentQuestionIndex]['answer']) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _isAnswered = false;
        _selectedOptionIndex = null;
      });
    } else {
      _confettiController.play();
      _showResultDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF7AD), Color(0xFFFFA9F4), Color(0xFFCFADFF)],
          ),
        ),
        child: const Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.black),
                SizedBox(height: 20),
                Text(
                  'Generating your dynamic quiz...',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_questions.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Could not generate quiz. Try again later.'),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    final question = _questions[_currentQuestionIndex];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF7AD), // Sunny Yellow
            Color(0xFFFFA9F4), // Pink
            Color(0xFFCFADFF), // Purple
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Daily Quiz', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: (_currentQuestionIndex + 1) / _questions.length,
                      minHeight: 10,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Question Counter
                  Text(
                    'Question ${_currentQuestionIndex + 1}/${_questions.length}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54),
                  ),
                  const SizedBox(height: 12),
                  
                  // Question Text
                  Text(
                    question['question'],
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(height: 32),
                  
                  // Options
                  Expanded(
                    child: ListView.builder(
                      itemCount: question['options'].length,
                      itemBuilder: (context, index) {
                        return _buildOption(index, question['options'][index], question['answer']);
                      },
                    ),
                  ),

                  // Explanation
                  if (_isAnswered)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          question['explanation'] ?? '',
                          style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                        ),
                      ).animate().fadeIn(),
                    ),
                  
                  // Next Button
                  if (_isAnswered)
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _nextQuestion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text(
                          _currentQuestionIndex == _questions.length - 1 ? 'Finish Quiz' : 'Next Question',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ).animate().scale(begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0)),
                    ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(int index, String text, int correctAnswerIndex) {
    bool isCorrect = index == correctAnswerIndex;
    bool isSelected = index == _selectedOptionIndex;
    
    Color bgColor = Colors.white.withOpacity(0.5);
    Color borderColor = Colors.white.withOpacity(0.2);
    IconData? icon;

    if (_isAnswered) {
      if (isCorrect) {
        bgColor = Colors.green.withOpacity(0.2);
        borderColor = Colors.green;
        icon = Icons.check_circle;
      } else if (isSelected) {
        bgColor = Colors.red.withOpacity(0.2);
        borderColor = Colors.red;
        icon = Icons.cancel;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: () => _handleOptionTap(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor, width: 2),
            boxShadow: [
              if (isSelected)
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ),
              if (icon != null) Icon(icon, color: borderColor),
            ],
          ),
        ),
      ),
    );
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Quiz Completed!', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.stars, size: 80, color: Colors.orange),
            const SizedBox(height: 16),
            Text('Your Score: $_score/${_questions.length}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(
              _score == _questions.length ? 'Zabardast! Aap toh genius hain! 🌟' : 'Bohat khoob! Thori aur practice karein. 💪',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text('Back to Home'),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
