import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/helpers.dart';
import 'chat_screen.dart';
import 'flashcard_screen.dart';
import 'progress_screen.dart';
import 'settings_screen.dart';
import 'quiz_screen.dart';
import 'grammar_checker_screen.dart';
import '../widgets/streak_flame.dart';
import '../widgets/app_background.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Helpers.getGreeting(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF475569),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'MEET ELLA',
                            style: GoogleFonts.montserrat(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic,
                              color: Colors.black,
                              letterSpacing: -0.5,
                              shadows: [
                                const Shadow(
                                  color: Colors.black12,
                                  offset: Offset(1, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/data/user.png',
                                width: 44,
                                height: 44,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            FirebaseAuth.instance.currentUser?.displayName ?? 'User',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Daily Goal Card (Modern Glassy)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ChatScreen()),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.psychology,
                                      color: Colors.black,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  const Text(
                                    'Ready to practice?',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                AppStrings.aiDescription,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF334155),
                                  height: 1.6,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF9333EA), Color(0xFF3B82F6)],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF9333EA).withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Text(
                                    AppStrings.startConversation,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ).animate(onPlay: (c) => c.repeat(reverse: true))
                     .shimmer(duration: 3.seconds, color: Colors.white.withOpacity(0.2))
                     .animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0),
                  ),
                ),

              // Quick Actions (Horizontal Swipe)
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Quick Actions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 160,
                            height: 160,
                            child: _ActionCard(
                              imagePath: 'assets/data/translator.png',
                              label: 'Grammar',
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const GrammarCheckerScreen(),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          SizedBox(
                            width: 160,
                            height: 160,
                            child: _ActionCard(
                              imagePath: 'assets/data/brain.png',
                              label: 'Daily Quiz',
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const QuizScreen(),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          SizedBox(
                            width: 160,
                            height: 160,
                            child: _ActionCard(
                              imagePath: 'assets/data/flash.png',
                              label: 'Flashcards',
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const FlashcardScreen(),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          SizedBox(
                            width: 160,
                            height: 160,
                            child: _ActionCard(
                              imagePath: 'assets/data/gr.png',
                              label: 'Progress',
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ProgressScreen(),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          SizedBox(
                            width: 160,
                            height: 160,
                            child: _ActionCard(
                              imagePath: 'assets/data/settings.png',
                              label: 'Settings',
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SettingsScreen(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Recent Activity Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Activity',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('See All', style: TextStyle(color: Colors.black54)),
                      ),
                    ],
                  ),
                ),
              ),

              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final activities = [
                      const _ActivityItem(
                        icon: Icons.chat_outlined,
                        title: 'Conversation Practice',
                        subtitle: '15 minutes with Ella',
                        time: '2 hours ago',
                      ),
                      const _ActivityItem(
                        icon: Icons.style_outlined,
                        title: 'Vocabulary Flashcards',
                        subtitle: 'Learned 5 new words',
                        time: 'Yesterday',
                      ),
                      const _ActivityItem(
                        icon: Icons.record_voice_over_outlined,
                        title: 'Pronunciation Drill',
                        subtitle: 'Score: 8.5/10',
                        time: 'Yesterday',
                      ),
                    ];
                    return activities[index]
                        .animate()
                        .fadeIn(duration: 400.ms, delay: (index * 100).ms)
                        .slideX(begin: 0.05, end: 0);
                  },
                  childCount: 3,
                ),
              ),

              const SliverPadding(padding: EdgeInsets.only(bottom: 30)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatefulWidget {
  final IconData? icon;
  final String? imagePath;
  final String label;
  final VoidCallback onTap;

  const _ActionCard({
    this.icon,
    this.imagePath,
    required this.label,
    required this.onTap,
  });

  @override
  State<_ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<_ActionCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.identity()..scale(_isPressed ? 0.95 : 1.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: widget.imagePath != null
                          ? Image.asset(widget.imagePath!, width: 60, height: 60, fit: BoxFit.contain)
                          : Icon(widget.icon, color: Colors.black, size: 50),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;

  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.black87, size: 22),
            ),
            title: Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            subtitle: Text(
              subtitle,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
            trailing: Text(
              time,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black45,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
