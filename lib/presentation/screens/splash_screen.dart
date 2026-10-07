import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/app_background.dart';
import 'auth/auth_wrapper.dart';
import 'onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // Wait for 3 seconds
    await Future.delayed(const Duration(seconds: 3));
    
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final onboardingComplete = prefs.getBool('onboarding_complete') ?? false;

    if (!onboardingComplete) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthWrapper()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo with shadow/glow
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.2),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/data/logo.png',
                  height: 150,
                  width: 150,
                ),
              ),
              const SizedBox(height: 30),
              // Italicized Montserrat Text with Shadow
              Text(
                'MEET ELLA',
                style: GoogleFonts.montserrat(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                  letterSpacing: 4,
                  shadows: [
                    const Shadow(
                      color: Colors.black26,
                      offset: Offset(2, 4),
                      blurRadius: 8,
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
