# AI Tutor 🤖📚

An AI-powered English Language Learning Flutter Application designed specifically for Pakistani learners. The app understands Urdu and Roman Urdu prompts and responds in clear, instructional English to help users build confidence, vocabulary, and grammar skills.

---

## 🌟 Key Features

- 💬 **Interactive AI Chat Assistant**: Practice English conversation with Gemini AI. Supports bilingual understanding (Urdu / Roman Urdu inputs) with explanations in English.
- 🎯 **Grammar Checker**: Real-time sentence structure, grammar, and style analysis with instant corrections and explanations.
- 🎴 **Interactive AI Flashcards**: Smart vocabulary flashcards generated dynamically based on chosen topics.
- 📝 **Dynamic AI Quizzes**: Interactive multiple-choice quizzes created on the fly to test English comprehension and grammar skills.
- 🎙️ **Voice & Pronunciation Assistance**: Integrated Speech-to-Text and Text-to-Speech (TTS / ElevenLabs) for natural spoken conversation practice.
- 🔥 **Streak & Progress Tracking**: Daily learning streaks, points, and performance analytics with interactive charts.
- 🔐 **Firebase Authentication**: Secure Sign Up, Login, and user profile management via Firebase Auth & Cloud Firestore.
- 💾 **Offline Caching & Fast Performance**: Local data storage powered by Hive and SharedPreferences.

---

## 🛠️ Tech Stack & Architecture

- **Framework**: [Flutter](https://flutter.dev) (Dart SDK `>=3.0.0 <4.0.0`)
- **State Management**: BLoC / Cubit (`flutter_bloc`)
- **AI Engine**: Google Gemini AI (`google_generative_ai`), OpenAI (fallback), ElevenLabs (TTS)
- **Backend & Auth**: Firebase Auth, Cloud Firestore, Firebase Core
- **Local Database**: Hive, SharedPreferences
- **UI Components**: Google Fonts, Flutter Animate, FL Chart, Confetti, Flip Card, Percent Indicator, Shimmer

---

## 📁 Directory Structure

```text
lib/
├── core/                  # App constants, themes, and utility helper functions
│   ├── constants/         # API endpoints, keys setup, asset paths
│   ├── theme/             # Color palettes, typography, and Material theme definitions
│   └── utils/             # Helper utilities
├── data/                  # Data models, local storage (Hive), and repository classes
│   ├── local/             # Hive database service and offline storage
│   ├── models/            # Data models (Chat, Lesson, Flashcard, User, Quiz)
│   └── repositories/      # Data handling abstraction repositories
├── presentation/          # Application UI layer
│   ├── bloc/              # State management Cubits & Blocs
│   ├── screens/           # Screens (Home, Chat, Grammar, Quiz, Flashcards, Progress, Settings, Auth)
│   └── widgets/           # Reusable UI widgets
└── services/              # External service integrations (AI, TTS, Speech Recognition)
```

---

## ⚙️ Setup & Configuration

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/mughasaad-droid/Aitutor.git
   cd Aitutor
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Configure API Keys**:
   Open `lib/core/constants/api_constants.dart` and insert your Gemini API key:
   ```dart
   class ApiConstants {
     static const String geminiApiKey = 'YOUR_GEMINI_API_KEY_HERE';
     // Optional fallback keys:
     static const String openAiApiKey = 'YOUR_OPENAI_API_KEY_HERE';
     static const String elevenLabsApiKey = 'YOUR_ELEVENLABS_API_KEY_HERE';
   }
   ```

4. **Run the Application**:
   ```bash
   flutter run
   ```

---

## 🔒 Security Note

All sensitive private API keys have been removed from the repository codebase for safety and compliance. Please generate your own API keys from Google AI Studio / Firebase / ElevenLabs before running the app.

---

## 📄 License

This project is licensed under the MIT License.
