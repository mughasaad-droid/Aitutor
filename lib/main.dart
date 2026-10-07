import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'data/local/hive_service.dart';
import 'presentation/bloc/conversation_cubit.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Firebase initialization for Web needs options. 
    // If you haven't run 'flutterfire configure', this might fail on Web.
    try {
      await Firebase.initializeApp();
    } catch (e) {
      debugPrint("Firebase initialization failed: $e");
      // If it's a web platform error, we continue so the app doesn't stay white
    }

    await HiveService.init();

    runApp(
      BlocProvider(
        create: (context) => ConversationCubit(),
        child: const MyApp(),
      ),
    );
  } catch (e, stack) {
    debugPrint("Critical error during main(): $e");
    debugPrint(stack.toString());
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(child: Text("Error starting app: $e")),
      ),
    ));
  }
}
