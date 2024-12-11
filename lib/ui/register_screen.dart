import 'package:flutter/material.dart';
import 'package:food_recipes_task/services/auth_services.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controllers for input fields
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _retypePasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Error messages for each field
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _retypePasswordError;

  // Services
  AuthService _authService = AuthService();

  // Define primary and accent colors
  final Color primaryColor = Color(0xFF2A3663);
  final Color accentColor = Colors.white;
  final Color cardColor = Color(0xFF3C4A8E); // A lighter shade for contrast

  void _register(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // Check if passwords match
      if (_passwordController.text == _retypePasswordController.text) {
        try {
          final response = await _authService.register(
            _nameController.text,
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
            // Show specific error messages
            setState(() {
              _nameError = response["error"]["name"]?[0];
              _emailError = response["error"]["email"]?[0];
              _passwordError = response["error"]["password"]?[0];
              _retypePasswordError = response["error"]["retype_password"]?[0];
            });
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed: $e")),
          );
        }
      } else {
        // Passwords do not match
        setState(() {
          _retypePasswordError = "Passwords do not match";
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Passwords do not match")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use a solid background color
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: primaryColor, // Solid background color
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Optional: Logo or Image
              /*
              Image.asset(
                'assets/logo.png', // Ensure you have a logo.png in assets
                height: 120,
              ),
              SizedBox(height: 40),
              */
              // Card for the registration form
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
                        // Name Field
                        TextFormField(
                          controller: _nameController,
                          style: TextStyle(color: accentColor),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person, color: accentColor),
                            labelText: "Name",
                            labelStyle: TextStyle(color: accentColor),
                            hintText: "Enter your name",
                            hintStyle: TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: Color(0xFF4A539E), // Input background
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide.none,
                            ),
                            errorStyle: TextStyle(color: Colors.redAccent),
                            errorText: _nameError,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
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
                        SizedBox(height: 20),
                        // Retype Password Field
                        TextFormField(
                          controller: _retypePasswordController,
                          obscureText: true,
                          style: TextStyle(color: accentColor),
                          decoration: InputDecoration(
                            prefixIcon:
                                Icon(Icons.lock_outline, color: accentColor),
                            labelText: "Retype Password",
                            labelStyle: TextStyle(color: accentColor),
                            hintText: "Re-enter your password",
                            hintStyle: TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: Color(0xFF4A539E), // Input background
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide.none,
                            ),
                            errorStyle: TextStyle(color: Colors.redAccent),
                            errorText: _retypePasswordError,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please retype your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 30),
                        // Register Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              _register(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color(0xFF1C213A), // Button color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            child: Text(
                              "Register",
                              style: TextStyle(
                                color: accentColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        // Navigate to Login Screen
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: Text(
                            "Already have an account? Login here!",
                            style: TextStyle(
                              color: accentColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
