import 'dart:io';
import 'dart:typed_data';

import 'package:climate_edge/Back-End/Controllers/data_point_controller.dart';
import 'package:climate_edge/Back-End/Models/data_point_model.dart';
import 'package:climate_edge/Front-End/Components/emission_selector.dart';
import 'package:climate_edge/Front-End/Components/page_header.dart';
import 'package:climate_edge/Front-End/Pages/DataProviderPages/data_table_page.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

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
  String? fertilizersType; // Track the selected emission in the

  List<String> itemList = [
    'Purchased Electricity',
    'Stationary Fuel',
    'Refrigerants',
    'Mobile Fuel',
    'Fertilizers'
  ];
  List<String> stationaryFuelList = [
    "Coal Coke",
    "Diesel",
    "Motor Gasoline",
    "Natural Gas",
    "Refinery Oil"
  ];
  List<String> refrigerantsList = [
    "HFC-134 (R-134)",
    "HFC-22 (R-22)",
    "HFC-23 (R-23)",
    "R-410A"
  ];
  List<String> mobileFuelList = [
    "CNG Light-duty Vehicles"
        "CNG Medium- and Heavy-duty Vehicles",
    "Diesel Light-duty Trucks",
    "Gasoline Bus",
    "Gasoline Passenger Cars",
  ];
  List<String> fertilizersList = ["Nitrate", "Urea"];
  String? selectedDate; // Track the selected date
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
    double fuelAmount = 0;
    double consumptionAmount = 0;
    double chargedAmount = 0;
    double FertilizerAmount = 0;

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
                              onChanged: (value) {
                            fuelAmount = double.parse(value);
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
                              onChanged: (value) {
                            consumptionAmount = double.parse(value);
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
                              onChanged: (value) {
                            chargedAmount = double.parse(value);
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
                          const SizedBox(height: 10),
                          const Text(
                            "Fertilizer Amount",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildTextField(context, "Enter Fertilizer Amount",
                              onChanged: (value) {
                            FertilizerAmount = double.parse(value);
                          }),
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
                                    "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
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
    // File Picker logic to select any file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any, // Allow any file type
    );

    if (result != null) {
      String fileName = result.files.single.name;
      Uint8List? fileData = result.files.single.bytes;

      if (fileData != null) {
        // Upload the picked file to Firebase Storage
        String? uploadedFileUrl = await uploadFile(fileName, fileData);
        if (uploadedFileUrl != null) {
          // Successfully uploaded, save the download URL
          setState(() {
            uploadedFileName = uploadedFileUrl; // Assign the URL to fileAttachment
          });
        }
      } else {
        // If bytes are null, read the file from the file path
        String? path = result.files.single.path;
        if (path != null) {
          File file = File(path);
          Uint8List fileBytes = await file.readAsBytes();
          String? uploadedFileUrl = await uploadFile(fileName, fileBytes);
          if (uploadedFileUrl != null) {
            setState(() {
              uploadedFileName = uploadedFileUrl; // Assign the URL to fileAttachment
            });
          }
        }
      }
    }
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
                                Datapoint dp = new Datapoint(
                                  id: "",
                                  emissionSource: selectedEmission1,
                                  location: location,
                                  date: selectedDate.toString(),
                                  fileAttachment: uploadedFileName,
                                  status: "Pending",
                                  emissionAmount: chargedAmount +
                                      consumptionAmount +
                                      fuelAmount +
                                      FertilizerAmount,
                                  emissionCalculated: onEmissionTypeSelected(
                                      selectedEmission1!,
                                      ((stationaryFuelType ?? '') +
                                          (refrigerantsType ?? '') +
                                          (fertilizersType ?? '') +
                                          (mobileFuelType ?? '')),
                                      (chargedAmount +
                                          consumptionAmount +
                                          fuelAmount +
                                          FertilizerAmount)),
                                  emissionType: (stationaryFuelType ?? '') +
                                      (refrigerantsType ?? '') +
                                      (fertilizersType ?? '') +
                                      (mobileFuelType ?? ''),
                                );
                                createEmissionCard(dp);

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
  Future<void> createEmissionCard(Datapoint dp) async {
    try {
      // Reference to Firestore collection
      CollectionReference emissions =
          FirebaseFirestore.instance.collection('emissions');

      // Create the document
      await emissions.add(dp.toMap());

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
        suffixStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
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
          ),
        ),
      );
    }
  }

  String getUnit(String emissionType, int subTypeId) {
    if (emissionType == itemList[0]) {
      return 'kWh';
    } else if (emissionType == 'Stationary Fuel') {
      if (subTypeId == 1) {
        // Coal Coke
        return 'kg';
      } else if (subTypeId == 4) {
        // Natural Gas
        return 'm3';
      } else {
        return 'L'; // Default for other fuel types
      }
    } else if (emissionType == 'Mobile Fuel') {
      return 'L';
    } else if (emissionType == 'Refrigerant') {
      return 'kg';
    } else if (emissionType == 'Fertilizer') {
      return 'kg';
    } else {
      return '';
    }
  }

  double getEmissionFactor(String emissionType, int subTypeId) {
    if (emissionType == 'Purchased Electricity') {
      return 0.0003767; // Emission factor from the image for Electricity
    }
    if (emissionType == 'Stationary Fuel') {
      if (subTypeId == 1) {
        // Coal Coke
        return 0.00203289525;
      } else if (subTypeId == 2) {
        // Diesel
        return 0.002709009025356;
      } else if (subTypeId == 3) {
        // Motor Gasoline
        return 0.0022874570865564;
      } else if (subTypeId == 4) {
        // Natural Gas
        return 0.00181355985024;
      } else if (subTypeId == 5) {
        // Kerosene
        return 0.0028532109063744;
      }
    }
    if (emissionType == 'Mobile Fuel') {
      if (subTypeId == 1 || subTypeId == 2) {
        // CNG Light-duty Vehicles
        return 1.9267e-06;
      } else if (subTypeId == 2) {
        // CNG Medium- and Heavy-duty Vehicles
        return 1.9267e-06;
      } else if (subTypeId == 3) {
        // Diesel Light-duty Trucks
        return 0.0027428098819836;
      } else if (subTypeId == 4) {
        // Gasoline Buses
        return 0.002340202663689;
      } else if (subTypeId == 5) {
        // Gasoline Passenger Cars
        return 0.002340202663689;
      }
    }
    if (emissionType == 'Refrigerants') {
      if (subTypeId == 1) {
        // HFC134a (R-134a)
        return 1.3;
      } else if (subTypeId == 2) {
        // HFC22 (R-22)
        return 1.76;
      } else if (subTypeId == 3) {
        // HFC23 (R-23)
        return 12.4;
      } else if (subTypeId == 4) {
        // HFC410A
        return 1.9235;
      }
    }
    if (emissionType == 'Fertilizers') {
      if (subTypeId == 1) {
        // Nitrate
        return 0.00429;
      } else if (subTypeId == 2) {
        // Urea
        return 0.00073;
      }
    }
    return 0.0; // Default if no match
  }

  double onEmissionTypeSelected(
      String emissionSource, String emissionType, double amount) {
    double emissionFactor = 0;
    switch (emissionSource) {
      case 'Fertilizers':
        emissionFactor = getEmissionFactor(
            emissionSource, fertilizersList.indexOf(emissionType) + 1);
        break;
      case 'Refrigerants':
        emissionFactor = getEmissionFactor(
            emissionSource, refrigerantsList.indexOf(emissionType) + 1);
        break;
      case 'Mobile Fuel':
        emissionFactor = getEmissionFactor(
            emissionSource, mobileFuelList.indexOf(emissionType) + 1);
        break;

      case 'Stationary Fuel':
        emissionFactor = getEmissionFactor(
            emissionSource, stationaryFuelList.indexOf(emissionType) + 1);
        break;
      case 'Purchased Electricity':
        emissionFactor = getEmissionFactor(emissionSource, 1);
        break;
    }

    return amount * emissionFactor;
  }
}
