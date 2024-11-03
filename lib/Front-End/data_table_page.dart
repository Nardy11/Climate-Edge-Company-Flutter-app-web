import 'package:climate_edge/Back-End/Controllers/data_point_controller.dart';
import 'package:climate_edge/Back-End/Models/data_point_model.dart';
import 'package:flutter/material.dart';
import 'package:climate_edge/Front-End/Components/emission_selector.dart';
import 'package:climate_edge/Front-End/Components/page_header.dart';
import 'package:climate_edge/Front-End/Components/side_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class DataTablePage extends StatefulWidget {
  final String emissionName;
  final String userId;
  final String userRole;

  const DataTablePage(
      {super.key,
      required this.emissionName,
      required this.userId,
      required this.userRole});

  @override
  State<DataTablePage> createState() => _DataTablePageState();
}

class _DataTablePageState extends State<DataTablePage> {
  List<List<String>> rowData = [];
  List<String> filterationList = [
    "Emission Amount",
    "Location",
    "Date",
    "Emissions",
    "Status"
  ];
  String? filter;
  String hintText = 'Sort by';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => isLoading = true); // Set loading to true
    try {
      List<List<String>>? data;

      // Fetch the data using the getEmissionCardsBySource function
      if (widget.userRole == "dataProvider") {
        data = await getEmissionCardsBySource(widget.emissionName, '');
      } else if (widget.userRole == "dataViewer") {
        data = await getEmissionCardsBySource(widget.emissionName, 'status');
      }

      setState(() {
        rowData = data!;
        isLoading = false;
      });
    } catch (e) {
      // Handle error
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: PageHeader(),
      ),
      drawer: SideBarMenu(userId: widget.userId, userRole: widget.userRole),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show a loader while data is being fetched
          : SingleChildScrollView(
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
                          width: 300,
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
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: rowData.length,
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

  Widget _buildDataCard(BuildContext context, int index, double screenWidth) {
    return SizedBox(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        color: const Color.fromRGBO(14, 57, 41, 1),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Emission Amount: ${rowData[index][0]} m²',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  if (widget.userRole == "dataViewer") ...[
                    _buildStatusChanger('Accept', rowData[index]),
                    _buildStatusIndicator(rowData[index][4]),
                    _buildStatusChanger('Reject', rowData[index]),
                  ] else ...[
                    _buildStatusIndicator(rowData[index][4]),
                  ],
                ],
              ),
              const Divider(color: Color.fromRGBO(255, 255, 255, 48)),
              const SizedBox(height: 5),
              Text('Location: ${rowData[index][1]}',
                  style: const TextStyle(color: Colors.white)),
              Text('Date: ${rowData[index][2]}',
                  style: const TextStyle(color: Colors.white)),
              Text('Emissions: ${rowData[index][3]} tCO2e',
                  style: const TextStyle(color: Colors.white)),
              const Divider(color: Color.fromRGBO(255, 255, 255, 48)),
              if (rowData[index][4] == "Rejected") ...[
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 2.0), // Add horizontal padding to the Row
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between text and button
    children: [
      Text(
        'Reason of Rejection is: ${rowData[index][8]}',
        style: const TextStyle(
          color: Color.fromARGB(255, 255, 40, 24),
          fontWeight: FontWeight.w800,
        ),
      ),
      TextButton.icon(
        onPressed: () {
          _showEditEmissionDialog(rowData[index]); // Assuming rowData[index] holds the current emission data
        },
        label: const Text(
          'Edit emission card',
          style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
        ),
        icon: const Icon(Icons.edit, color: Colors.white),
      ),
    ],
  ),
),


                const Divider(color: Color.fromRGBO(255, 255, 255, 48)),
              ],
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  child: TextButton(
                    onPressed: () async {
                      String? fileUrl = rowData[index][6];

                      if (fileUrl != null && fileUrl.isNotEmpty) {
                        if (await canLaunch(fileUrl)) {
                          await launch(fileUrl);
                        } else {
                          print('Could not launch file URL');
                        }
                      } else {
                        print('No file to view');
                      }
                    },
                    child: const Text(
                      'View Attachment',
                      style: TextStyle(color: Color.fromRGBO(14, 57, 41, 1)),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(255, 255, 255, 48),
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

  Widget _buildStatusChanger(String status, List<String> rowData) {
    Color acceptedColor = Colors.green.shade200;
    Color rejectColor = Colors.red.shade200;
    Color statusColor = status == 'Accept' ? acceptedColor : rejectColor;
    String newstatus = status == 'Reject' ? 'Rejected' : 'Accepted';

    return GestureDetector(
      onTap: () {
        if (status == 'Reject') {
          // Show dialog for rejection reason
          _showRejectionDialog(rowData, newstatus);
        } else {
          // Directly accept
          updateEmissionCard(
                  context, rowData, newstatus, widget.emissionName, '')
              .then((_) {
            _fetchData(); // Refetch data after updating
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
        decoration: BoxDecoration(
          color: statusColor,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          status,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _showRejectionDialog(List<String> rowData, String newstatus) {
    TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Rejection Reason'),
          content: TextField(
            controller: reasonController,
            decoration: InputDecoration(
              hintText: 'Enter reason for rejection',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
            maxLines: 3,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String rejectedReason = reasonController.text.trim();
                if (rejectedReason.isNotEmpty) {
                  updateEmissionCard(context, rowData, newstatus,
                          widget.emissionName, rejectedReason)
                      .then((_) {
                    _fetchData(); // Refetch data after updating
                    Navigator.of(context)
                        .pop(); // Close dialog after submission
                  });
                } else {
                  // Optionally, show an error if the reason is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reason cannot be empty.')),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _showEditEmissionDialog(List<String> currentData) {
    print('entered:');
    print(currentData);
    // Create controllers for each field to hold the current values
    TextEditingController emissionAmountController =
        TextEditingController(text: currentData[0]);
    TextEditingController locationController =
        TextEditingController(text: currentData[1]);
    TextEditingController dateController =
        TextEditingController(text: currentData[2]);
    TextEditingController emissionsController =
        TextEditingController(text: currentData[3]);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Emission Card'),
          content: SizedBox(
            height: 300, // Set a height for the dialog
            child: Column(
              children: [
                TextField(
                  controller: emissionAmountController,
                  decoration: const InputDecoration(
                    labelText: 'Emission Amount (m²)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType
                      .number, // Adjust keyboard type for number input
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emissionsController,
                  decoration: const InputDecoration(
                    labelText: 'Emissions (tCO2e)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType
                      .number, // Adjust keyboard type for number input
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Collect updated values from the controllers
                String updatedEmissionAmount =
                    emissionAmountController.text.trim();
                String updatedLocation = locationController.text.trim();
                String updatedDate = dateController.text.trim();
                String updatedEmissions = emissionsController.text.trim();
                currentData[0]=updatedEmissionAmount;
                currentData[1]=updatedLocation;
                currentData[2]=updatedDate;
                currentData[3]=updatedEmissions;

                // Perform validation if necessary
                if (updatedEmissionAmount.isNotEmpty &&
                    updatedLocation.isNotEmpty &&
                    updatedDate.isNotEmpty &&
                    updatedEmissions.isNotEmpty) {
                  // Call your function to update the emission card here
                  updateEmissionCard(context, currentData, 'Pending',
                          widget.emissionName, '')
                      .then((_) {
                    _fetchData(); // Refetch data after updating
                    Navigator.of(context)
                        .pop(); // Close dialog after submission
                  });
                } else {
                  // Optionally show a message if fields are empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('All fields must be filled out.')),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  // Function to sort the row data based on the selected filter
  void _sortRowData() {
    if (filter == null) return;

    switch (filter) {
      case "Emission Amount":
        rowData.sort((a, b) => double.parse(b[0])
            .compareTo(double.parse(a[0]))); // Descending order
        break;
      case "Location":
        rowData.sort((a, b) => b[1].compareTo(a[1])); // Descending order
        break;
      case "Date":
        rowData.sort((a, b) => DateTime.parse(b[2])
            .compareTo(DateTime.parse(a[2]))); // Descending order
        break;
      case "Emissions":
        rowData.sort((a, b) => double.parse(b[3])
            .compareTo(double.parse(a[3]))); // Descending order
        break;
      case "Status":
        rowData.sort((a, b) => b[4].compareTo(a[4])); // Descending order
        break;
      default:
        break;
    }
  }
}
