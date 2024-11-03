import 'package:climate_edge/Front-End/Components/emission_selector.dart';
import 'package:flutter/material.dart';

import '../../Components/page_header.dart';
import '../../data_table_page.dart';

class HomePageReviewer extends StatefulWidget {
    final String userId;
    final String userRole;

  const HomePageReviewer({super.key, required this.userId, required this.userRole});

  @override
  State<HomePageReviewer> createState() => _HomePageReviewerState();
}

class _HomePageReviewerState extends State<HomePageReviewer> {
  String? selectedEmission; // Track the selected emission
  String? newItemSaved; // Track the selected emission
  
  List<String> itemList = [
    'Purchased Electricity',
    'Stationary Fuel',
    'Refrigerants',
    'Mobile Fuel',
    'Fertilizers'
  ];
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60.0), // Adjust the height if needed
        child: PageHeader(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Text(
              "Which Emission do you want to view?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            EmissionSelector(
              itemLists: itemList,
              backgroundColor: const Color(0xFFECEFF1),
              textColor: Colors.black,
              borderColor: const Color.fromARGB(255, 0, 0, 0),
              selectedItem: selectedEmission,
              onChanged: (String? newItem) {
                setState(() {
                  selectedEmission = newItem;
                  newItemSaved = newItem;
                });
                _navigateToDataTablePage(context, selectedEmission);
              },
            ),
          ],
        ),
      ),
    );
  }
  
  void _navigateToDataTablePage(
      BuildContext context, String? selectedEmission) {
    if (selectedEmission != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DataTablePage(
            emissionName: selectedEmission,
            userId: widget.userId,
            userRole: widget.userRole,
          ),
        ),
      );
    }
  }
}