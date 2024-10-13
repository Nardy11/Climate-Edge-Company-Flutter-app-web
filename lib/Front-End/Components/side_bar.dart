import 'package:flutter/material.dart';

class SideBarMenu extends StatelessWidget {
  const SideBarMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFF0E3929), // Dark Green shade for the entire drawer background
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF0E3929), // Ensure header has the same green color
              ),
              child: Text(
                'Main Page',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
             const Text(
                'Emission Sources',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            _buildDrawerItem(icon: Icons.home, text: 'Purchased Electricity', onTap: () {}),
            _buildDrawerItem(icon: Icons.local_gas_station, text: 'Stationary Fuel', onTap: () {}),
            _buildDrawerItem(icon: Icons.ac_unit, text: 'Refrigerants', onTap: () {}),
            _buildDrawerItem(icon: Icons.local_shipping, text: 'Mobile Fuel', onTap: () {}),
            _buildDrawerItem(icon: Icons.agriculture, text: 'Fertilizers', onTap: () {}),
          ],
        ),
      ),
    );
  }

  // Reusable function for drawer items
  ListTile _buildDrawerItem({required IconData icon, required String text, required GestureTapCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(text, style: TextStyle(color: Colors.white)),
      onTap: onTap,
      tileColor: const Color(0xFF0E3929), // Set background color for each tile to dark green
    );
  }
}
