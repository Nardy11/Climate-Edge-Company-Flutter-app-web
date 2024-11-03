import 'package:climate_edge/Back-End/Models/data_point_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
Future<List<List<String>>> getEmissionCardsBySource(String emissionSource,String condition) async {
  List<List<String>> rowData = [];

  try {
    // Reference to the Firestore collection
    CollectionReference collection = FirebaseFirestore.instance.collection('emissions');
    QuerySnapshot querySnapshot;
    if(condition == "status"){
     querySnapshot = await collection
        .where('emissionSource', isEqualTo: emissionSource).where('status',isEqualTo: "Pending")
        .get();
    }else{
     querySnapshot = await collection
        .where('emissionSource', isEqualTo: emissionSource)
        .get();
    }
    // Fetching documents for the specific emission source


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
      String rejectedReason =data['rejectedReason']?.toString() ?? '';
      // Create a row for each emission card
      List<String> row = [
        emissionAmount,
        location,
        date,
        emissionCalculated,
        status,
        emissionType,
        fileAttachment,
        doc.id.toString(),
        rejectedReason,
      ];

      rowData.add(row);
    }

    print("Retrieved ${rowData.length} emission cards for source: $emissionSource.");
  } catch (e) {
    print("Error retrieving emission cards: $e");
  }

  return rowData;
}


Future<void> updateEmissionCard(BuildContext context, List<String> rowData, String newStatus,String emissionSource ,String rejectedReason) async {
  CollectionReference collection = FirebaseFirestore.instance.collection('emissions');
  try {
    print(rowData);
    print(rejectedReason);
    Datapoint datapoint = Datapoint(
    id: rowData[7], // Ensure you have an ID at index 0 or change accordingly
    emissionAmount: double.parse(rowData[0]),
    location: rowData[1],
    date: rowData[2],
    emissionCalculated: double.parse(rowData[3]),
    status: newStatus,
    emissionType: rowData[5],
    fileAttachment:  rowData[6] , emissionSource: emissionSource,
    rejectedReason:rejectedReason
  );
      await collection.doc(datapoint.id).update(datapoint.toMap());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Emission card was updated to be $newStatus.'),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error updating emission card status: $e'),
      ),
    );
  }
}

Future<String> uploadFile(String fileName, Uint8List fileData) async {
  try {
    Reference ref = FirebaseStorage.instance.ref().child('uploads/$fileName');

    // Upload file to Firebase Storage
    UploadTask uploadTask = ref.putData(fileData);
    TaskSnapshot snapshot = await uploadTask;

    // Check if the upload was successful
    if (snapshot.state == TaskState.success) {
      // Get download URL after successful upload
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } else {
      throw Exception('Upload failed');
    }
  } catch (e) {
    print('File upload failed: $e');
    throw Exception('Failed to upload file');
  }
}
