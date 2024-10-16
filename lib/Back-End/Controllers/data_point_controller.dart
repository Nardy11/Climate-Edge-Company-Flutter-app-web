import 'package:climate_edge/Back-End/Models/data_point_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'dart:io'; // For Platform
import 'package:flutter/material.dart';


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



Future<void> createEmissionCard(Datapoint datapoint) async {
  try {
    // Reference to the Firestore collection
    CollectionReference collection = FirebaseFirestore.instance.collection('emissions');

    // Creating the emission card with status set to "Pending"
    await collection.add(datapoint.toMap());
    print("Emission card created successfully with ID: ${datapoint.id}");
  } catch (e) {
    print("Error creating emission card: $e");
  }
}
Future<List<List<String>>> getEmissionCardsBySource(String emissionSource) async {
  List<List<String>> rowData = [];

  try {
    // Reference to the Firestore collection
    CollectionReference collection = FirebaseFirestore.instance.collection('emissions');

    // Fetching documents for the specific emission source
    QuerySnapshot querySnapshot = await collection
        .where('emissionSource', isEqualTo: emissionSource)
        .get();

    // Mapping documents to the desired row format
    for (var doc in querySnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;

      // Handle potential null values by providing default values or empty strings
      String emissionAmount = data['emissionAmount']?.toString() ?? '0'; // Default to '0' if null
      String location = data['location'] ?? 'Unknown'; // Default to 'Unknown' if null
      String date = data['date'] != null
          ? DateTime.parse(data['date']).toIso8601String().split('T')[0]
          : 'N/A'; // Default to 'N/A' if null or invalid date
      String emissionCalculated = data['emissionCalculated']?.toString() ?? '0'; // Default to '0' if null
      String status = data['status'] ?? 'Pending'; // Default to 'Pending' if null
      String emissionType = data['emissionType'] ?? 'Unknown'; // Default to 'Unknown' if null
      String fileAttachment = data['fileAttachment'] ?? ''; // Default to empty string if null

      // Create a row for each emission card
      List<String> row = [
        emissionAmount,
        location,
        date,
        emissionCalculated,
        status,
        emissionType,
        fileAttachment,
      ];

      rowData.add(row);
    }

    print("Retrieved ${rowData.length} emission cards for source: $emissionSource.");
  } catch (e) {
    print("Error retrieving emission cards: $e");
  }

  return rowData;
}
