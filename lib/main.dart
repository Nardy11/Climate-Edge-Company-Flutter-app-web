import 'dart:io';
import 'package:climate_edge/Front-End/Pages/DataProviderPages/data_table_page.dart';
import 'package:climate_edge/Front-End/Pages/DataProviderPages/home_page.dart';
import 'package:climate_edge/Front-End/log_in_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    if (kIsWeb || Platform.isWindows) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyANizzbVThQQuQZ951EZD8cKOfGimoVm8w",
          authDomain: "climate-edge-server.firebaseapp.com",
          projectId: "climate-edge-server",
          storageBucket: "climate-edge-server.appspot.com",
          messagingSenderId: "472427162945",
          appId: "1:472427162945:web:468a99ced540219cce45c0",
          measurementId: "G-8QNNZPET2Q",
        ),
      );
    } else {
      await Firebase.initializeApp(); // Use default options for mobile
    }
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(), // Make sure the LoginPage is defined correctly
      debugShowCheckedModeBanner: false,
    );
    
  }
}
