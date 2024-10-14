import 'package:climate_edge/Front-End/Components/emission_selector.dart';
import 'package:climate_edge/Front-End/Components/page_header.dart';
import 'package:climate_edge/Front-End/Components/side_bar.dart';
import 'package:flutter/material.dart';

class DataTablePage extends StatefulWidget {
  final String emissionName;
  final String userId;
  final List<List<String>> rowData;

  const DataTablePage({
    super.key,
    required this.emissionName,
    required this.userId,
    required this.rowData,
  });

  @override
  State<DataTablePage> createState() => _DataTablePageState();
}

class _DataTablePageState extends State<DataTablePage> {
  List<String> filterationList = [
    "Emission Amount",
    "Location",
    "Date",
    "Emissions",
    "Status"
  ];
  String? filter; // Initialize as null
  String hintText = 'Sort by';
  List<List<String>> sortedRowData = []; // For sorted data

  @override
  void initState() {
    super.initState();
    // Initialize sortedRowData with the original rowData
    sortedRowData = List.from(widget.rowData);
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width to calculate card size
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60.0), // Adjust the height if needed
        child: PageHeader(),
      ),
      drawer: const SideBarMenu(), // The reusable sidebar component
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 18),
              Text(
                widget.emissionName,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 18),
              ),
              // Sorting filter tool
              const SizedBox(height: 18),
              Row(
                children: [
                  const Text(
                    "Sort By :",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 18),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 200, // Control the width directly here
                    child: EmissionSelector(
                      itemLists: filterationList,
                      backgroundColor: const Color(0xFFECEFF1),
                      textColor: Colors.black,
                      borderColor: const Color.fromARGB(255, 0, 0, 0),
                      selectedItem: filter,
                      hintText: hintText,
                      onChanged: (String? newItem) {
                        setState(() {
                          filter = newItem;
                          _sortRowData(); // Call sorting method
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Data cards for each row in the table
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sortedRowData.length,
                itemBuilder: (context, index) {
                  return _buildDataCard(context, index, screenWidth);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

// Function to build each data card (Dynamic dark green cards with data)
Widget _buildDataCard(BuildContext context, int index, double screenWidth) {
  return SizedBox(
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      color: const Color(0xFF0E3929), // Dark green background for the data cards
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emission Amount and Status Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Emission Amount: ${sortedRowData[index][0]} m²',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                _buildStatusIndicator(sortedRowData[index][4]), // Status chip
              ],
            ),
            const Divider(color: Color.fromRGBO(255, 255, 255, 48)), // A separator
            const SizedBox(height: 5),
            // Location, Date, and Emissions Data
            Text('Location: ${sortedRowData[index][1]}',
                style: const TextStyle(color: Colors.white)),
            Text('Date: ${sortedRowData[index][2]}',
                style: const TextStyle(color: Colors.white)),
            Text('Emissions: ${sortedRowData[index][3]} tCO2e',
                style: const TextStyle(color: Colors.white)),
            const Divider(color: Color.fromRGBO(255, 255, 255, 48)), // A separator
            // View Attachment Button
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: screenWidth * 0.8, // Set the button width to 90% of the screen width
                child: TextButton(
                  onPressed: () {
                    // Handle View Attachment action
                    // Add your dynamic logic here to load attachment
                  },
                  child: const Text('View Attachment',
                      style: TextStyle(color: Color.fromRGBO(14, 57, 41, 1))),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Color.fromRGBO(255, 255, 255, 48), // Set the desired color here
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  // Function to build the status indicator (Accepted, Rejected, Pending)
  Widget _buildStatusIndicator(String status) {
    Color statusColor;
    if (status == 'Accepted') {
      statusColor = Colors.green;
    } else if (status == 'Rejected') {
      statusColor = Colors.red;
    } else {
      statusColor = Colors.yellow[700]!;
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        status,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  // Function to sort the row data based on the selected filter
  void _sortRowData() {
    if (filter == null) return;

    switch (filter) {
      case "Emission Amount":
        sortedRowData.sort((a, b) =>
            int.parse(b[0]).compareTo(int.parse(a[0]))); // Descending order
        break;
      case "Location":
        sortedRowData.sort((a, b) => b[1].compareTo(a[1])); // Descending order
        break;
      case "Date":
        sortedRowData.sort((a, b) => DateTime.parse(b[2])
            .compareTo(DateTime.parse(a[2]))); // Descending order
        break;
      case "Emissions":
        sortedRowData.sort((a, b) =>
            int.parse(b[3]).compareTo(int.parse(a[3]))); // Descending order
        break;
      case "Status":
        sortedRowData.sort((a, b) => b[4].compareTo(a[4])); // Descending order
        break;
      default:
        break;
    }
  }
}
