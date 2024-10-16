import 'package:climate_edge/Front-End/log_in_page.dart';
import 'package:flutter/material.dart';
import 'package:climate_edge/Back-End/Controllers/user_controller.dart';

class PageHeader extends StatefulWidget {
  const PageHeader({super.key});

  @override
  State<PageHeader> createState() => _PageHeaderState();
}

class _PageHeaderState extends State<PageHeader> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
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
                      Icons.logout,
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
                // Navigate to LoginPage on logout selection
                AuthService().signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
