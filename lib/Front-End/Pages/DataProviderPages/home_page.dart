import 'package:climate_edge/Back-End/Controllers/data_point_controller.dart';
import 'package:climate_edge/Back-End/Models/data_point_model.dart';
import 'package:climate_edge/Front-End/Components/emission_selector.dart';
import 'package:climate_edge/Front-End/Components/page_header.dart';
import 'package:climate_edge/Front-End/Pages/DataProviderPages/data_table_page.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class DataProviderHomePage extends StatefulWidget {
  final String userId;

  const DataProviderHomePage({super.key, required this.userId});

  @override
  _DataProviderHomePageState createState() => _DataProviderHomePageState();
}

class _DataProviderHomePageState extends State<DataProviderHomePage> {
  String? selectedEmission; // Track the selected emission
  String? selectedEmission1; // Track the selected emission in the dialog
  String? newItemSaved; // Track the selected emission
  String? newItem1Saved; // Track the selected emission in the dialog
  String? stationaryFuelType; // Track the selected emission
  String? refrigerantsType; // Track the selected emission in the dialog
  String? mobileFuelType; // Track the selected emission
  String? fertilizersType; // Track the selected emission in the dialog
  List<String> itemList = [
    'Purchased Electricity',
    'Stationary Fuel',
    'Refrigerants',
    'Mobile Fuel',
    'Fertilizers'
  ];
  List<String> stationaryFuelList = [];
  List<String> refrigerantsList = [];
  List<String> mobileFuelList = [];
  List<String> fertilizersList = [];
  late String selectedDate; // Track the selected date
  String? uploadedFileName; // Track the uploaded file name

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showEmissionPopup(context); // Pop-up action
        },
        backgroundColor: const Color(0xFF0E3D25),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showEmissionPopup(BuildContext context) {
    String location = '';
    String fuelAmount = '';
    String consumptionAmount = '';
    String chargedAmount = '';

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
                  maxWidth: MediaQuery.of(context).size.width * 0.35,
                ),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E3929),
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
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildTextField(context, "Enter location",
                            onChanged: (value) {
                          location = value;
                        }),
                        const SizedBox(height: 20),
                        const Text(
                          "Emission Source",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        EmissionSelector(
                          itemLists: itemList,
                          backgroundColor: const Color(0xFFECEFF1),
                          textColor: Colors.black,
                          borderColor: const Color.fromARGB(255, 0, 0, 0),
                          selectedItem: selectedEmission1,
                          onChanged: (String? newItem1) {
                            setState(() {
                              selectedEmission1 = newItem1;
                              newItem1Saved = newItem1;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        if (newItem1Saved == 'Stationary Fuel') ...[
                          const Text(
                            "Stationary Fuel Type",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          EmissionSelector(
                            itemLists: stationaryFuelList,
                            backgroundColor: const Color(0xFFECEFF1),
                            textColor: Colors.black,
                            borderColor: const Color.fromARGB(255, 0, 0, 0),
                            selectedItem: stationaryFuelType,
                            onChanged: (String? newItem) {
                              setState(() {
                                stationaryFuelType = newItem;
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Fuel Amount",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildTextField(context, "Enter Fuel Amount",
                              suffix: "kg", onChanged: (value) {
                            fuelAmount = value;
                          }),
                        ] else if (newItem1Saved ==
                            'Purchased Electricity') ...[
                          const Text(
                            "Consumption Amount",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildTextField(context, "Enter Consumption Amount",
                              suffix: "kg", onChanged: (value) {
                            consumptionAmount = value;
                          }),
                        ] else if (newItem1Saved == 'Mobile Fuel') ...[
                          const Text(
                            "Mobile Fuel Type",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          EmissionSelector(
                            itemLists: mobileFuelList,
                            backgroundColor: const Color(0xFFECEFF1),
                            textColor: Colors.black,
                            borderColor: const Color.fromARGB(255, 0, 0, 0),
                            selectedItem: mobileFuelType,
                            onChanged: (String? newItem) {
                              setState(() {
                                mobileFuelType = newItem;
                              });
                            },
                          ),
                        ] else if (newItem1Saved == 'Refrigerants') ...[
                          const Text(
                            "Refrigerant Type",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          EmissionSelector(
                            itemLists: refrigerantsList,
                            backgroundColor: const Color(0xFFECEFF1),
                            textColor: Colors.black,
                            borderColor: const Color.fromARGB(255, 0, 0, 0),
                            selectedItem: refrigerantsType,
                            onChanged: (String? newItem) {
                              setState(() {
                                refrigerantsType = newItem;
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Charged Amount",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildTextField(context, "Enter Charged Amount",
                              suffix: "kg", onChanged: (value) {
                            chargedAmount = value;
                          }),
                        ] else if (newItem1Saved == 'Fertilizers') ...[
                          const Text(
                            "Fertilizers Type",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          EmissionSelector(
                            itemLists: fertilizersList,
                            backgroundColor: const Color(0xFFECEFF1),
                            textColor: Colors.black,
                            borderColor: const Color.fromARGB(255, 0, 0, 0),
                            selectedItem: fertilizersType,
                            onChanged: (String? newItem) {
                              setState(() {
                                fertilizersType = newItem;
                              });
                            },
                          ),
                        ],
                        const SizedBox(height: 20),
                        const Text(
                          "Select a Date",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                selectedDate =
                                    "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 255, 255, 255),
                          ),
                          child: Text(selectedDate ?? 'Select Date'),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            // File Picker logic
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles();
                            if (result != null) {
                              setState(() {
                                uploadedFileName = result.files.single.name;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 255, 255, 255),
                          ),
                          child: Text(uploadedFileName ?? 'Upload File'),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .center, // Center the buttons horizontally
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Call createEmissionCard with the gathered data
                                Datapoint datapoint=new Datapoint(date:selectedDate ,emissionAmount:double.parse(consumptionAmount),emissionSource: newItem1Saved,id: '',location: location,status: "Pending",emissionCalculated: 0,fileAttachment: uploadedFileName );

                                createEmissionCard(

                                );
                                Navigator.pop(context);
                              },
                              child: const Text("Save"),
                            ),
                            const SizedBox(
                                width:
                                    20), // Add some space between the buttons
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"),
                            ),
                          ],
                        )
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
  
  // Function to create an emission card and save to Firebase
  Future<void> createEmissionCard(
   
  ) async {
    try {
      // Reference to Firestore collection
      CollectionReference emissions =
          FirebaseFirestore.instance.collection('emissions');

      // Create the document
      await emissions.add({

        
        // Include user ID if needed
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Emission card saved successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving emission card: $e")),
      );
    }
  }

  // Helper method to build text fields
  Widget _buildTextField(BuildContext context, String hintText,
      {String? suffix, required ValueChanged<String> onChanged}) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        filled: true,
        fillColor: const Color.fromARGB(255, 255, 255, 255),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        suffixText: suffix,
        suffixStyle: const TextStyle(color: Colors.white),
      ),
    );
  }

  Future<void> _navigateToDataTablePage(
      BuildContext context, String? selectedEmission) async {
    if (selectedEmission != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DataTablePage(
            emissionName: selectedEmission,
            userId: widget.userId, emissionType: '', // Pass userId directly
          ),
        ),
      );
    }
  }
}
