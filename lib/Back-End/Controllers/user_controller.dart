
import 'package:climate_edge/Back-End/Models/user_model.dart 'as user;
import 'package:climate_edge/Front-End/Pages/DataProviderPages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'dart:io'; // For Platform
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<user.User?> signInWithEmailPassword(BuildContext context, String email, String password) async {
  try {
    final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Fetch user data from Firestore
    QuerySnapshot querySnapshot = await _firestore
        .collection('user')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic> userData = querySnapshot.docs[0].data() as Map<String, dynamic>;

      // Create User object
      final user.User currentUser = user.User.fromMap(
        userData,
        querySnapshot.docs[0].id,
      );

      // Check user role and navigate accordingly
      if (currentUser.role == ("dataProvider")) {
        // Navigate to DataProviderHomePage with user ID
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DataProviderHomePage(userId: currentUser.id),
          ),
        );
      }

      return currentUser; // Return the current user
    } else {
      // No matching user found
      return null;
    }
  } on FirebaseAuthException catch (e) {
    print("Error signing in: ${e.message}");
    // Handle errors (e.g., show an error message to the user)
    return null;
  }
}

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print("User signed out successfully.");
    } catch (e) {
      print("Error signing out: $e");
      // Handle errors (e.g., show an error message to the user)
    }
  }
}

class FirebaseService {
  FirebaseService._privateConstructor();

  static final FirebaseService instance = FirebaseService._privateConstructor();

  Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    if (kIsWeb || Platform.isWindows) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyANizzbVThQQuQZ951EZD8cKOfGimoVm8w",
            authDomain: "climate-edge-server.firebaseapp.com",
            projectId: "climate-edge-server",
            storageBucket: "climate-edge-server.appspot.com",
            messagingSenderId: "472427162945",
            appId: "1:472427162945:web:468a99ced540219cce45c0",
            measurementId: "G-8QNNZPET2Q"),
      );
    } else {
      await Firebase.initializeApp();
    }
  }

  FirebaseFirestore get firestore => FirebaseFirestore.instance;
}

final FirebaseService firebaseService = FirebaseService.instance;
