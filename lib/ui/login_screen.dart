import 'package:flutter/material.dart';
import 'package:food_recipes_task/services/auth_services.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _emailError;
  String? _passwordError;
  AuthService _authService = AuthService();

  // Define primary color
  final Color primaryColor = Color(0xFF2A3663);
  final Color accentColor = Colors.white;
  final Color cardColor = Color(0xFF3C4A8E); // A lighter shade for contrast

  void _login(context) async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await _authService.login(
          _emailController.text,
          _passwordController.text,
        );

        if (response["status"]) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response["message"])),
          );
          // Navigate to home
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response["message"])),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Remove the default AppBar and use a custom one if needed
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: primaryColor, // Set solid background color
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo or Image
              // Uncomment and add your logo asset if available
              /*
              Image.asset(
                'assets/logo.png', // Ensure you have a logo.png in assets
                height: 120,
              ),
              SizedBox(height: 40),
              */
              // Card for the form
              Card(
                color: cardColor, // Set card color for contrast
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 8.0,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Email Field
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: accentColor),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email, color: accentColor),
                            labelText: "Email",
                            labelStyle: TextStyle(color: accentColor),
                            hintText: "Enter your email",
                            hintStyle: TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: Color(0xFF4A539E), // Input background
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide.none,
                            ),
                            errorStyle: TextStyle(color: Colors.redAccent),
                            errorText: _emailError,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            // Simple email validation
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        // Password Field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          style: TextStyle(color: accentColor),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock, color: accentColor),
                            labelText: "Password",
                            labelStyle: TextStyle(color: accentColor),
                            hintText: "Enter your password",
                            hintStyle: TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: Color(0xFF4A539E), // Input background
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide.none,
                            ),
                            errorStyle: TextStyle(color: Colors.redAccent),
                            errorText: _passwordError,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 30),
                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              _login(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color(0xFF1C213A), // Button color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: accentColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        // Register Button
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: Text(
                            "Don't have an account? Register here!",
                            style: TextStyle(
                              color: accentColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Optional: Additional widgets like "Forgot Password"
              TextButton(
                onPressed: () {
                  // Navigate to forgot password screen
                },
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: Colors.white70,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
