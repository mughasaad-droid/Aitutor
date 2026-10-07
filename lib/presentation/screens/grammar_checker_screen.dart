import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../../services/ai_service.dart';
import '../widgets/app_background.dart';

class GrammarCheckerScreen extends StatefulWidget {
  const GrammarCheckerScreen({super.key});

  @override
  State<GrammarCheckerScreen> createState() => _GrammarCheckerScreenState();
}

class _GrammarCheckerScreenState extends State<GrammarCheckerScreen> {
  final TextEditingController _controller = TextEditingController();
  final AIService _aiService = AIService();
  final ImagePicker _picker = ImagePicker();
  final TextRecognizer _textRecognizer = TextRecognizer();

  bool _isLoading = false;
  Map<String, dynamic>? _result;

  @override
  void dispose() {
    _controller.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image == null) return;

    setState(() => _isLoading = true);
    try {
      final inputImage = InputImage.fromFilePath(image.path);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      
      setState(() {
        _controller.text = recognizedText.text;
      });
      
      // Auto-check after extraction
      if (recognizedText.text.trim().isNotEmpty) {
        await _checkGrammar();
      }
    } catch (e) {
      _showError('Galti: Image se text nahi nikal saka.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _checkGrammar() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _result = null;
    });

    try {
      final response = await _aiService.checkGrammar(_controller.text.trim());
      setState(() {
        _result = response;
      });
    } catch (e) {
      _showError('Oho! Kuch masla hua. Phir se koshish karein.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF22D1EE), // Vibrant Cyan
            Color(0xFFFCD34D), // Soft Yellow
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Grammar Checker', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF0F172A)),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Intro
              const Text(
                'Let Ella fix your writing!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Type krain ya photo kheenchain, Ella sahi kar degi.',
                style: TextStyle(color: Color(0xFF334155), fontSize: 14),
              ),
              const SizedBox(height: 24),

              // Input Area (Glassmorphic)
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _controller,
                          maxLines: 6,
                          style: const TextStyle(color: Color(0xFF0F172A), fontSize: 16),
                          decoration: InputDecoration(
                            hintText: 'Enter text here...',
                            hintStyle: TextStyle(color: Color(0xFF0F172A).withOpacity(0.4)),
                            border: InputBorder.none,
                          ),
                        ),
                        const Divider(color: Colors.white24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _IconButton(
                              icon: Icons.camera_alt_rounded,
                              label: 'Camera',
                              onTap: () => _pickImage(ImageSource.camera),
                            ),
                            _IconButton(
                              icon: Icons.photo_library_rounded,
                              label: 'Gallery',
                              onTap: () => _pickImage(ImageSource.gallery),
                            ),
                            _IconButton(
                              icon: Icons.auto_awesome,
                              label: 'Check',
                              onTap: _isLoading ? null : _checkGrammar,
                              isPrimary: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Results Area
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                )
              else if (_result != null)
                _buildResults(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResults() {
    final corrections = _result!['corrections'] as List? ?? [];
    final fullText = _result!['full_corrected_text'] ?? '';
    final feedback = _result!['overall_feedback'] ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Ella's Feedback
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(Icons.face_retouching_natural, color: Color(0xFF0F172A), size: 30),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  feedback,
                  style: const TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Corrected Full Text
        const Text(
          'Corrected Text:',
          style: TextStyle(color: Color(0xFF334155), fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: SelectableText(
            fullText,
            style: const TextStyle(color: Color(0xFF0F172A), fontSize: 16),
          ),
        ),
        
        const SizedBox(height: 20),

        // Detailed Corrections
        if (corrections.isNotEmpty) ...[
          const Text(
            'Mistakes & Explanations:',
            style: TextStyle(color: Color(0xFF334155), fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...corrections.map((c) => _CorrectionItem(correction: c)),
        ],
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isPrimary;

  const _IconButton({
    required this.icon,
    required this.label,
    this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isPrimary ? Colors.white : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: isPrimary ? const Color(0xFF9333EA) : const Color(0xFF0F172A), size: 24),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Color(0xFF334155), fontSize: 12)),
        ],
      ),
    );
  }
}

class _CorrectionItem extends StatelessWidget {
  final dynamic correction;

  const _CorrectionItem({required this.correction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                correction['original'] ?? '',
                style: const TextStyle(
                  color: Colors.redAccent,
                  decoration: TextDecoration.lineThrough,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(Icons.arrow_right_alt, color: Color(0xFF0F172A), size: 20),
              Text(
                correction['corrected'] ?? '',
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            correction['reason'] ?? '',
            style: const TextStyle(color: Color(0xFF334155), fontSize: 13),
          ),
        ],
      ),
    );
  }
}
