import 'package:climate_edge/Front-End/Pages/DataProviderPages/data_table_page.dart';
import 'package:climate_edge/Front-End/Pages/DataProviderPages/home_page.dart';
import 'package:flutter/material.dart';

class SideBarMenu extends StatelessWidget {
  const SideBarMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      color: const Color(
          0xFF0E3929), // Dark Green shade for the entire drawer background
      child: Center(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color:
                    Color(0xFF0E3929), // Ensure header has the same green color
              ),
              child: Center(
                  child: _buildDrawerItem(
                              size: 30,icon: Icons.home,
                text: 'Main Page',
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DataProviderHomePage(context),
                    ),
                  );
                },
              )),
            ),
            const Text(
              'Emission Sources',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            _buildDrawerItem(
                              size: 20,icon: Icons.electric_rickshaw_outlined,
                text: 'Purchased Electricity',
                onTap:() { Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DataTablePage(
                        emissionName: 'Purchased Electricity',
                        userId: 'User123',
                        rowData: [
                          ['200', 'Location 1', '2024-10-14', '100', 'Accepted'],
                          ['150', 'Location 2', '2024-10-12', '75', 'Rejected'],
                          ['151', 'Location 3', '2024-10-13', '750', 'Pending'],
                          // Add more rows if needed
                        ],
                      ),
                    ),
                  );}),
            _buildDrawerItem(
                              size: 20,icon: Icons.local_gas_station,
                text: 'Stationary Fuel',
                onTap: () { Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DataTablePage(
                        emissionName: 'Stationary Fuel',
                        userId: 'User123',
                        rowData: [
                          ['200', 'Location 1', '2024-10-14', '100', 'Accepted'],
                          ['150', 'Location 2', '2024-10-12', '75', 'Rejected'],
                          ['151', 'Location 3', '2024-10-13', '750', 'Pending'],
                          // Add more rows if needed
                        ],
                      ),
                    ),
                  );}),
            _buildDrawerItem(
                              size: 20,icon: Icons.ac_unit, text: 'Refrigerants', onTap: () { Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DataTablePage(
                        emissionName: 'Refrigerants',
                        userId: 'User123',
                        rowData: [
                          ['200', 'Location 1', '2024-10-14', '100', 'Accepted'],
                          ['150', 'Location 2', '2024-10-12', '75', 'Rejected'],
                          ['151', 'Location 3', '2024-10-13', '750', 'Pending'],
                          // Add more rows if needed
                        ],
                      ),
                    ),
                  );}),
            _buildDrawerItem(
                              size: 20,icon: Icons.local_shipping, text: 'Mobile Fuel', onTap: () { Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DataTablePage(
                        emissionName: 'Mobile Fuel',
                        userId: 'User123',
                        rowData: [
                          ['200', 'Location 1', '2024-10-14', '100', 'Accepted'],
                          ['150', 'Location 2', '2024-10-12', '75', 'Rejected'],
                          ['151', 'Location 3', '2024-10-13', '750', 'Pending'],
                          // Add more rows if needed
                        ],
                      ),
                    ),
                  );}),
            _buildDrawerItem(
              size: 20,
                icon: Icons.agriculture, text: 'Fertilizers', onTap: () { Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DataTablePage(
                        emissionName: 'Fertilizers',
                        userId: 'User123',
                        rowData: [
                          ['200', 'Location 1', '2024-10-14', '100', 'Accepted'],
                          ['150', 'Location 2', '2024-10-12', '75 ', 'Rejected'],
                          ['151', 'Location 3', '2024-10-13', '750', 'Pending'],
                          // Add more rows if needed
                        ],
                      ),
                    ),
                  );}),
          ],
        ),
      ),
    ));
  }

  // Reusable function for drawer items
  ListTile _buildDrawerItem(
      {required IconData icon,
      required String text,
      required GestureTapCallback onTap,
      required double size ,
      }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(text, style: TextStyle(color: Colors.white,      fontSize: size, // Increase the font size here
)),
      onTap: onTap,
      tileColor: const Color(
          0xFF0E3929), // Set background color for each tile to dark green
    );
  }
}
