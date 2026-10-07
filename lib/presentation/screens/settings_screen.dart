import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/app_background.dart';
import 'auth/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _speechRate = 0.45;
  bool _isDarkMode = false;
  String _targetLanguage = 'English';
  String _selectedVoice = 'Ella';
  double _voiceTone = 0.5;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _speechRate = prefs.getDouble('speech_rate') ?? 0.45;
      _isDarkMode = prefs.getBool('dark_mode') ?? false;
      _targetLanguage = prefs.getString('target_language') ?? 'English';
      _selectedVoice = prefs.getString('selected_voice_name') ?? 'Ella';
      _voiceTone = prefs.getDouble('voice_tone') ?? 0.5;
    });
  }

  Future<void> _saveVoice(String name, String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_voice_name', name);
    await prefs.setString('voice_id', id);
    setState(() => _selectedVoice = name);
  }

  Future<void> _saveTone(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('voice_tone', value);
    setState(() => _voiceTone = value);
  }

  Future<void> _saveSpeechRate(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('speech_rate', value);
    setState(() => _speechRate = value);
  }

  Future<void> _saveDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', value);
    setState(() => _isDarkMode = value);
  }

  Future<void> _saveTargetLanguage(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('target_language', value);
    setState(() => _targetLanguage = value);
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF82ADFF), // Sky Blue
            Color(0xFFC1D9FF), // Light Blue
            Color(0xFFFFFFFF), // Pure White
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Settings', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          foregroundColor: Colors.black,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // AI Voice Selection
            _buildSectionTitle('Ella\'s Voice'),
            Card(
              color: Colors.white.withOpacity(0.4),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'Ella', label: Text('Ella', style: TextStyle(color: Color(0xFF0F172A))), icon: Icon(Icons.face, color: Color(0xFF0F172A))),
                        ButtonSegment(value: 'Bella', label: Text('Bella', style: TextStyle(color: Color(0xFF0F172A))), icon: Icon(Icons.face_retouching_natural, color: Color(0xFF0F172A))),
                        ButtonSegment(value: 'Adam', label: Text('Adam', style: TextStyle(color: Color(0xFF0F172A))), icon: Icon(Icons.face_unlock_sharp, color: Color(0xFF0F172A))),
                      ],
                      selected: {_selectedVoice},
                      onSelectionChanged: (set) {
                        final name = set.first;
                        String id = '21m00Tcm4TlvDq8ikWAM'; // Ella (Rachel)
                        if (name == 'Bella') id = 'EXAVITQu4vr4xnSDxMaL';
                        if (name == 'Adam') id = 'pNInz6obpgueM0WZtGQC';
                        _saveVoice(name, id);
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Voice Tone (Stability)', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold)),
                        Text('${(_voiceTone * 100).toInt()}%', style: const TextStyle(color: Color(0xFF0F172A))),
                      ],
                    ),
                    Slider(
                      value: _voiceTone,
                      min: 0.1,
                      max: 1.0,
                      activeColor: const Color(0xFF0F172A),
                      inactiveColor: const Color(0xFF0F172A).withOpacity(0.2),
                      onChanged: _saveTone,
                    ),
                    const Text(
                      'High stability makes the voice more consistent but less expressive.',
                      style: TextStyle(fontSize: 11, color: Color(0xFF334155)),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // AI Voice Speed
            _buildSectionTitle('Speech Speed'),
            Card(
              color: Colors.white.withOpacity(0.4),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Speech Speed', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold)),
                        Text('${_speechRate.toStringAsFixed(2)}x', style: const TextStyle(color: Color(0xFF0F172A))),
                      ],
                    ),
                    Slider(
                      value: _speechRate,
                      min: 0.2,
                      max: 1.0,
                      divisions: 8,
                      activeColor: const Color(0xFF0F172A),
                      inactiveColor: const Color(0xFF0F172A).withOpacity(0.2),
                      label: _speechRate.toStringAsFixed(2),
                      onChanged: _saveSpeechRate,
                    ),
                    const Text(
                      'Slower speed helps with learning pronunciation',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Target Language
            _buildSectionTitle('Learning Preferences'),
            Card(
              color: Colors.white.withOpacity(0.4),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Target Language', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'English', label: Text('English', style: TextStyle(color: Color(0xFF0F172A)))),
                        ButtonSegment(value: 'Spanish', label: Text('Spanish', style: TextStyle(color: Color(0xFF0F172A)))),
                        ButtonSegment(value: 'French', label: Text('French', style: TextStyle(color: Color(0xFF0F172A)))),
                      ],
                      selected: {_targetLanguage},
                      onSelectionChanged: (set) => _saveTargetLanguage(set.first),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Appearance
            _buildSectionTitle('Appearance'),
            Card(
              color: Colors.white.withOpacity(0.4),
              child: SwitchListTile(
                title: const Text('Dark Mode', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold)),
                subtitle: const Text('Easier on the eyes at night', style: TextStyle(color: Color(0xFF1E293B))),
                value: _isDarkMode,
                activeColor: const Color(0xFF0F172A),
                onChanged: _saveDarkMode,
              ),
            ),

            const SizedBox(height: 16),

            // Account
            _buildSectionTitle('Account'),
            Card(
              color: Colors.white.withOpacity(0.4),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person_outline, color: Color(0xFF0F172A)),
                    title: const Text('Profile', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold)),
                    subtitle: Text(FirebaseAuth.instance.currentUser?.email ?? '', style: const TextStyle(color: Color(0xFF1E293B))),
                    trailing: const Icon(Icons.chevron_right, color: Color(0xFF0F172A)),
                  ),
                  const Divider(height: 1, color: Colors.white24),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    onTap: () => _showLogoutDialog(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0F172A),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout?', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to logout?', style: TextStyle(color: Color(0xFF334155))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF0F172A))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
