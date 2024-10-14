import 'package:climate_edge/Front-End/Pages/DataProviderPages/data_table_page.dart';
import 'package:climate_edge/Front-End/Pages/DataProviderPages/home_page.dart';
import 'package:climate_edge/Front-End/log_in_page.dart';
import 'package:flutter/material.dart';
import 'Front-End/log_in_page.dart'; // Make sure to import the LoginPage

void main() {
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
      home: const LoginPage()

    );
  }
}
