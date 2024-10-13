import 'package:climate_edge/Front-End/Pages/DataProviderPages/data_table_page.dart';
import 'package:flutter/material.dart';

class DataProviderHomePage extends StatelessWidget {

  const DataProviderHomePage({super.key,  required emissionType});

  @override
  Widget build(BuildContext context) {
        final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E3D25), // Green color from design
        title: Row(
          children: [
            // Company logo at the left
            Image.asset(
              "assets/images/company's_logo.png", // Replace with the actual path
              height: 40,
              width: 40,
            ),
            const SizedBox(width: 10),
            const Text(
              "CLIMATE EDGE",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text
              ),
            ),
            const Spacer(),
            // Icons for notifications and user profile
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white), // White icon
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.person, color: Colors.white), // White icon
              onPressed: () {},
            ),
          ],
        ),
      ),
      body:
      Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Which Emission do you want to view?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0E3D25), // Same green color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shadowColor: Colors.black.withOpacity(0.5),
                  elevation: 8,
                ),
                onPressed: () {
                  _showDropdownMenu(context);
                },
                child: const Text(
                  "Select Emission Source",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action for Floating Action Button
          _showEmissionPopup(context); // Pop-up action
        },
        backgroundColor: const Color(0xFF0E3D25), // Same green color
        child: const Icon(Icons.add, color: Colors.white), // White "+" icon
      ),
    );
  }

  // Popup dialog for emissions with the required fields
void _showEmissionPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.25, // Responsive width, 85% of screen
              ),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF0E3929), // Popup background shade of green
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Location",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // White text
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(context, "Enter location"),
                      const SizedBox(height: 20),
                      const Text(
                        "Emission Source",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // White text
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(context, "Enter emission source"),
                      const SizedBox(height: 20),
                      const Text(
                        "Select Date",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // White text
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 5,
                          shadowColor: Colors.black.withOpacity(0.3),
                        ),
                        onPressed: () {
                          _selectDate(context);
                        },
                        child: const Text(
                          "Pick Date",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 5,
                          shadowColor: Colors.black.withOpacity(0.3),
                        ),
                        onPressed: () {
                          // Add attachments action
                        },
                        label: const Text(
                          "Add Attachment",
                          style: TextStyle(color: Colors.black),
                        ),
                        icon: const Icon(Icons.attach_file, color: Colors.black),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}

  // Method to build text fields
  Widget _buildTextField(BuildContext context, String hintText) {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Method to show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      // Handle date picked
    }
  }
}
 // Function to show dropdown menu
  void _showDropdownMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? selectedItem;
        return AlertDialog(
          title: const Text('Select Emission Type'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return DropdownButton<String>(
                value: selectedItem,
                hint: const Text("Choose an emission type"),
                items: <String>[
                  'Purchased Electricity',
                  'Stationary Fuel',
                  'Refrigerants',
                  'Mobile Fuel',
                  'Fertilizers'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedItem = newValue;
                  });
                },
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedItem != null) {
                  // Call DataTablePage with the selected item
                  Navigator.of(context).pop();
                  _navigateToDataTablePage(context, selectedItem!);
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
 void _navigateToDataTablePage(BuildContext context, String selectedItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DataTablePage( userid: null, emissionname: null,),
      ),
    );
  
}