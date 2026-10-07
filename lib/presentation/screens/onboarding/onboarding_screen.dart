import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/app_background.dart';
import '../auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'icon': Icons.psychology,
      'title': 'Meet Ella',
      'description':
          'Your personal AI English teacher who understands Urdu and Roman Urdu too!',
      'color': const Color(0xFF0F172A),
    },
    {
      'icon': Icons.mic,
      'title': 'Speak Naturally',
      'description':
          'Just tap the mic and talk. Ella will listen, understand, and reply in English.',
      'color': const Color(0xFF0F172A),
    },
    {
      'icon': Icons.record_voice_over,
      'title': 'Get Feedback',
      'description':
          'Ella checks your pronunciation and gently corrects your mistakes.',
      'color': const Color(0xFF0F172A),
    },
    {
      'icon': Icons.local_fire_department,
      'title': 'Build Streaks',
      'description':
          'Practice daily to keep your streak alive and become fluent faster!',
      'color': const Color(0xFF0F172A),
    },
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              page['icon'] as IconData,
                              size: 80,
                              color: page['color'] as Color,
                            ),
                          ),
                          const SizedBox(height: 40),
                          Text(
                            page['title'] as String,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            page['description'] as String,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF1E293B),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: _pages.length,
                      effect: WormEffect(
                        dotColor: Colors.white.withOpacity(0.3),
                        activeDotColor: const Color(0xFF0F172A),
                        dotHeight: 10,
                        dotWidth: 10,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_currentPage < _pages.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            _completeOnboarding();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F172A),
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          _currentPage < _pages.length - 1
                              ? 'Next'
                              : 'Get Started',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
