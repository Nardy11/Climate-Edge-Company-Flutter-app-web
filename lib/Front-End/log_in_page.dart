import 'package:climate_edge/Back-End/Controllers/user_controller.dart';
import 'package:climate_edge/Front-End/Pages/DataProviderPages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:climate_edge/Front-End/Pages/DataReviewerPages/home_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen size information
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final logoSize = isSmallScreen
        ? size.width * 0.4
        : size.width * 0.2; // Logo scales with screen width

    // Define controllers for email and password
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: Stack(
        children: [
          // Background images (plants on the corners)
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              'assets/images/left_top_plant.png',
              width: isSmallScreen ? 80 : 150,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              'assets/images/right_top_plant.png',
              width: isSmallScreen ? 80 : 250,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              'assets/images/left_bottom_plant.png',
              width: isSmallScreen ? 150 : 250,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'assets/images/right_bottom_plant.png',
              width: isSmallScreen ? 150 : 250,
            ),
          ),

          // Main content with scrollable feature to prevent overflow
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Climate Edge Logo
                  Image.asset(
                    'assets/images/green_planet.png',
                    width: logoSize,
                    height: logoSize,
                  ),
                  const SizedBox(height: 20),

                  // Welcome Text
                  const Text(
                    'Welcome to CLIMATE EDGE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 14, 57, 41),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Email TextField
                  SizedBox(
                    width: isSmallScreen ? size.width * 0.85 : size.width * 0.5,
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelText: 'Email:',
                        hintText: 'Please Enter The Email',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password TextField
                  SizedBox(
                    width: isSmallScreen ? size.width * 0.85 : size.width * 0.5,
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelText: 'Password:',
                        hintText: 'Please Enter The Password',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Log In Button
                  SizedBox(
                    width: isSmallScreen ? size.width * 0.85 : size.width * 0.5,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Get email and password values
                        String email = emailController.text.trim();
                        String password = passwordController.text.trim();

                        // Call signInWithEmailPassword function from AuthService
                        var user = await AuthService()
                            .signInWithEmailPassword(context, email, password);
                        if (user != null) {
                          // Successfully signed in, navigate or show success message
                          if (user.role == ("dataProvider")) {
                            Navigator.pushReplacement(
                              // ignore: use_build_context_synchronously
                              context,
                              MaterialPageRoute(
                                builder: (context) => DataProviderHomePage(
                                    userId: user.id, userRole: user.role),
                              ),
                            );
                          } else {
                            if (user.role == ("dataViewer")) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePageReviewer(
                                      userId: user.id, userRole: user.role),
                                ),
                              );
                            }
                          }
                        } else {
                          // Handle sign-in error (show a message, etc.)
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Invalid email or password')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                      ),
                      child: const Text(
                        'Log In',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
