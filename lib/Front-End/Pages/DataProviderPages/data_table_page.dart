import 'package:climate_edge/Front-End/Components/side_bar.dart';
import 'package:flutter/material.dart';

class DataTablePage extends StatelessWidget {
  final List<String> columnNames=[];
  final List<List<String>> rowData=[];


 DataTablePage({super.key, required emissionname , required userid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Fuel', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0E3929), // Dark Green color
        
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Notification Action
            },
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              // User Profile Action
            },
          ),
        ],
      ),
      drawer: const SideBarMenu(), // The reusable sidebar component
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sorting filter tool
              Row(
                children: [
                  const Text('Sort by:', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[300], // light grey background for the filter
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: Container(),
                        items: ['Emission Amount', 'Location', 'Date']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          // Handle sort functionality here
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Data cards for each row in the table
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: rowData.length,
                itemBuilder: (context, index) {
                  return _buildDataCard(context, index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build each data card (Dark green cards with data)
  Widget _buildDataCard(BuildContext context, int index) {
    return Card(
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
                  'Emission Amount: ${rowData[index][0]} m²',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                _buildStatusIndicator(rowData[index][4]), // Status chip
              ],
            ),
            const SizedBox(height: 5),
            // Location, Date, and Emissions Data
            Text('Location: ${rowData[index][1]}', style: const TextStyle(color: Colors.white)),
            Text('Date: ${rowData[index][2]}', style: const TextStyle(color: Colors.white)),
            Text('Emissions: ${rowData[index][3]} tCO2e', style: const TextStyle(color: Colors.white)),
            const Divider(color: Colors.white54), // A separator
            // View Attachment Button
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  // Handle View Attachment action
                },
                child: const Text('View Attachment', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
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
}
