import 'package:climate_edge/Front-End/Components/emission_selector.dart';
import 'package:climate_edge/Front-End/Pages/DataProviderPages/data_table_page.dart';
import 'package:climate_edge/Front-End/log_in_page.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class DataProviderHomePage extends StatefulWidget {
  final String emissionType;

  const DataProviderHomePage({Key? key, required this.emissionType})
      : super(key: key);

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
  String? selectedDate; // Track the selected date
  String? uploadedFileName; // Track the uploaded file name

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E3D25),
        title: Row(
          children: [
            Image.asset(
              "assets/images/company's_logo.png",
              height: 40,
              width: 40,
            ),
            const SizedBox(width: 10),
            const Text(
              "CLIMATE EDGE",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {},
            ),
            PopupMenuButton(
              icon: const Icon(Icons.person, color: Colors.white),
              itemBuilder: (BuildContext context) => [
               const PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                       Icon(
                        Icons.logout, // Use the logout icon
                        color: Colors.red,
                      ),
                       SizedBox(width: 10), // Spacing between icon and text
                      Text(
                        'LOGOUT',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'logout') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                }
              },
            ),
          ],
        ),
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
                        _buildTextField(context, "Enter location"),
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
                              suffix: "kg"),
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
                              suffix: "kg"),
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
                              suffix: "kg"),
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
                          "Date",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          selectedDate != null
                              ? selectedDate!
                              : "No date selected",
                          style: const TextStyle(
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
                                    "${pickedDate.toLocal()}".split(' ')[0];
                              });
                            }
                          },
                          child: const Text("Select Date"),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Attachment",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          uploadedFileName != null
                              ? uploadedFileName!
                              : "No file uploaded",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles();
                            if (result != null) {
                              setState(() {
                                uploadedFileName = result.files.first
                                    .name; // Update the name of the uploaded file
                              });
                            }
                          },
                          child: const Text("Add Attachment"),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            // Handle submit action here
                            Navigator.of(context).pop();
                          },
                          child: const Text("Submit"),
                        ),
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

  Widget _buildTextField(BuildContext context, String hintText,
      {String? suffix}) {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        suffixText: suffix, // Add the suffix to the input field
      ),
    );
  }

  void _navigateToDataTablePage(BuildContext context, String? selectedItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DataTablePage(
          userid: null,
          emissionname: selectedItem, // Pass selected emission name
        ),
      ),
    );
  }
}
