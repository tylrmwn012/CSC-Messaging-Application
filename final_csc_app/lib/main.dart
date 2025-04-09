import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import '../Firebase/firebase_auth.dart';
import 'package:final_csc_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {  
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepOrangeAccent, 
        brightness: Brightness.light
      )),
      home: AuthGate(),
    );
  }
}