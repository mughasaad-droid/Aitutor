import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:confetti/confetti.dart';
import '../widgets/app_background.dart';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  late ConfettiController _confettiController;
  
  final List<Map<String, String>> _flashcards = [
    {
      'front': 'Serendipity', 
      'back': 'A happy accident\n\n"Finding my favorite book at the library was pure serendipity."',
      'image': 'assets/data/seren.jpg'
    },
    {
      'front': 'Ephemeral', 
      'back': 'Lasting for a very short time\n\n"The beauty of the sunset is ephemeral."',
      'image': 'assets/data/eph.jpg'
    },
    {
      'front': 'Resilience', 
      'back': 'Ability to recover quickly\n\n"Her resilience after failure inspired everyone."',
      'image': 'assets/data/res.jpg'
    },
    {
      'front': 'Eloquent', 
      'back': 'Fluent and persuasive in speaking\n\n"He gave an eloquent speech."',
      'image': 'assets/data/eq.jpg'
    },
    {
      'front': 'Ubiquitous', 
      'back': 'Present everywhere\n\n"Smartphones are ubiquitous nowadays."',
      'image': 'assets/data/images.jpg'
    },
  ];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.2,
          colors: [
            Color(0xFFF5D1FF), // Bright Lavender (Center)
            Color(0xFFFFB8D1), // Soft Pink
            Color(0xFFFFF2D1), // Light Yellow (Outer)
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Vocabulary Flashcards', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          foregroundColor: Colors.black,
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Progress
                Text(
                  'Card ${_currentIndex + 1} of ${_flashcards.length}',
                  style: const TextStyle(fontSize: 16, color: Color(0xFF0F172A), fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                
                // Flip Card
                FlipCard(
                  direction: FlipDirection.HORIZONTAL,
                  front: _buildCardSide(
                    _flashcards[_currentIndex]['front']!,
                    Colors.white.withOpacity(0.5),
                    Icons.lightbulb_outline,
                    imagePath: _flashcards[_currentIndex]['image'],
                  ),
                  back: _buildCardSide(
                    _flashcards[_currentIndex]['back']!,
                    Colors.white.withOpacity(0.8),
                    null, // No icon for the back
                    isItalic: true,
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _currentIndex > 0 
                        ? () => setState(() => _currentIndex--) 
                        : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F172A),
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Previous'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: _currentIndex < _flashcards.length - 1
                        ? () => setState(() => _currentIndex++)
                        : () {
                            _confettiController.play();
                            _showCompletionDialog();
                          },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F172A),
                        foregroundColor: Colors.white,
                      ),
                      icon: Icon(_currentIndex < _flashcards.length - 1 
                        ? Icons.arrow_forward 
                        : Icons.celebration),
                      label: Text(_currentIndex < _flashcards.length - 1 
                        ? 'Next' 
                        : 'Finish!'),
                    ),
                  ],
                ),
              ],
            ),
            
            // Confetti
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.green, Colors.blue, Colors.orange],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardSide(String text, Color color, IconData? icon, {String? imagePath, bool isItalic = false}) {
    return Container(
      width: 320,
      height: 250,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.5), 
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Main Content (Image or Text)
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: imagePath != null 
              ? Image.asset(
                  imagePath, 
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 40, color: const Color(0xFF0F172A)),
                      const SizedBox(height: 16),
                    ],
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isItalic ? 16 : 22,
                          fontWeight: isItalic ? FontWeight.w500 : FontWeight.bold,
                          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
                          color: const Color(0xFF0F172A),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
          ),
          
          // Premium Glossy Shine Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.4), // Bright Shine
                    Colors.white.withOpacity(0.1),
                    Colors.transparent,
                    Colors.black.withOpacity(0.05), // Depth
                  ],
                  stops: const [0.0, 0.2, 0.5, 1.0],
                ),
              ),
            ),
          ),
          
          // Subtle Reflection Border
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Lesson Complete!'),
        content: const Text('You\'ve learned 5 new words today. Great job!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _currentIndex = 0);
            },
            child: const Text('Restart'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}
