import 'package:climate_edge/Back-End/Controllers/data_point_controller.dart';
import 'package:flutter/material.dart';
import 'package:climate_edge/Front-End/Components/emission_selector.dart';
import 'package:climate_edge/Front-End/Components/page_header.dart';
import 'package:climate_edge/Front-End/Components/side_bar.dart';

class DataTablePage extends StatefulWidget {
  final String emissionName;
  final String userId;

  const DataTablePage({
    super.key,
    required this.emissionName,
    required this.userId, required String emissionType,
  });

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
    try {
      // Fetch the data using the getEmissionCardsBySource function
      List<List<String>> data = await getEmissionCardsBySource(widget.emissionName);

      setState(() {
        rowData = data;
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
      drawer: const SideBarMenu(),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show a loader while data is being fetched
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
                          width: 200,
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
                  _buildStatusIndicator(rowData[index][4]),
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
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  child: TextButton(
                    onPressed: () {
                      // Handle View Attachment action
                    },
                    child: const Text('View Attachment',
                        style: TextStyle(color: Color.fromRGBO(14, 57, 41, 1))),
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

  // Function to sort the row data based on the selected filter
  void _sortRowData() {
    if (filter == null) return;

    switch (filter) {
      case "Emission Amount":
        rowData.sort((a, b) =>
            int.parse(b[0]).compareTo(int.parse(a[0]))); // Descending order
        break;
      case "Location":
        rowData.sort((a, b) => b[1].compareTo(a[1])); // Descending order
        break;
      case "Date":
        rowData.sort((a, b) => DateTime.parse(b[2])
            .compareTo(DateTime.parse(a[2]))); // Descending order
        break;
      case "Emissions":
        rowData.sort((a, b) =>
            int.parse(b[3]).compareTo(int.parse(a[3]))); // Descending order
        break;
      case "Status":
        rowData.sort((a, b) => b[4].compareTo(a[4])); // Descending order
        break;
      default:
        break;
    }
  }
}
