import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
// Make sure to import this for JSON handling
import 'forgot_password.dart';
import 'signup.dart';
import 'terms_condition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_after_login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailText = TextEditingController();
  final passText = TextEditingController();
  final panText = TextEditingController();
  bool isLoading = false; // For showing a loading spinner

  // Function to show the error or success messages
  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // Function to handle login API request
  Future<void> _login() async {
    String uEmail = emailText.text.trim();
    String uPass = passText.text.trim();
    String uPan = panText.text.trim();

    if (uEmail.isEmpty || uPass.isEmpty) {
      _showMessage("Please enter email and password");
      print("Login failed: Email or Password is empty");
      return;
    } else if (uPan.isEmpty) {
      // If PAN is empty, proceed with login using email and password
      print("Warning: PAN ID is empty. Proceeding with login...");
    } else {
      // All fields are filled, continue with normal sign-in process
      print("Proceeding with login...");
    }

    setState(() {
      isLoading = true;
    });

    try {
      // API URL is updated for login with PAN
      final apiUrl = uPan.isEmpty
          ? 'https://wealthclockadvisors.com/api/client/login'
          : 'https://wealthclockadvisors.com/api/client/login-with-pan';
      print("Attempting to login with email: $uEmail"); // Print email for debugging

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'email': uEmail,
          'password': uPass,
          'pan': uPan, // Send PAN if available
        },
      );

      setState(() {
        isLoading = false;
      });

      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print("Login successful, response data: $responseData");

        if (responseData.containsKey('token')) {
          String token = responseData['token'];
          String userId = responseData['user_id'].toString();

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          await prefs.setString('user_id', userId);

          _showMessage("Login successful.");

          // Navigate to dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => dashboardAfterLogin(userId: userId)),
          );
        } else {
          print("Unexpected response structure.");
          _showMessage("Unexpected response from server.");
        }
      } else if (response.statusCode == 400) {
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        print("Bad request: ${errorResponse['message']}");
        _showMessage(errorResponse['message'] ?? "Login failed. Please try again.");
      } else if (response.statusCode == 401) {
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        print("Unauthorized: ${errorResponse['message']}");
        _showMessage(errorResponse['message'] ?? "Login failed. Please try again.");
      } else if (response.statusCode == 409) {
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        print("Conflict: ${errorResponse['message']}");
        _showMessage(errorResponse['message'] ?? "Login failed. Please try again.");
      } else {
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        print("Login error: ${errorResponse['message']}");
        _showMessage(errorResponse['message'] ?? "Login failed. Please try again.");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Exception caught: $e");
      _showMessage("Error: Unable to connect to the server.");
    }
  }
  bool _isPanVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFfffaf5),
              Color(0xFFe7f6f5),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 100),
                child: Image.asset(
                  'assets/images/logo_img.png',
                  height: 120,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'LOGIN INTO YOUR ACCOUNT',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF0f625c),
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailText,
                decoration: _inputDecoration('youremail@gmail.com'),
                style: const TextStyle(color: Color(0xFF648683), fontSize: 15),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: passText,
                obscureText: !_isPanVisible, // Toggle text visibility
                decoration: _inputDecoration('**********').copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPanVisible ? Icons.visibility : Icons.visibility_off,
                      color: Color(0xFF648683),
                    ),
                    onPressed: () {
                      setState(() {
                        _isPanVisible = !_isPanVisible; // Toggle visibility
                      });
                    },
                  ),
                ),
                style: const TextStyle(color: Color(0xFF648683), fontSize: 15),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: panText,
                decoration: _inputDecoration('PAN ID (Optional)'),
                style: const TextStyle(color: Color(0xFF648683), fontSize: 15),
              ),
              const SizedBox(height: 14),
              ElevatedButton(
                onPressed:
                isLoading ? null : _login, // Disable button while loading
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFfdd1a0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 35),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                    color: Colors.white) // Show loading spinner
                    : Text(
                  'SIGN IN',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF222222),
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 3),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const forgotPasswordPage()));
                  },
                  child: Text(
                    'Forgot Password?',
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0f625c),
                      decoration: TextDecoration.underline,
                      decorationColor: const Color(0xFF0f625c),
                      decorationThickness: 1.2,
                      height: 0.5,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'By proceeding, you agree to the ',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF648683),
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Wrap(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const termsCondPage()));
                          },
                          child: Text(
                            'Terms & Conditions',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF0da99e),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              decorationColor: const Color(0xFF0da99e),
                              decorationThickness: 1.5,
                              height: 1.5,
                            ),
                          ),
                        ),
                        Text(
                          ' of Wealthclock Advisor.',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF648683),
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 40, bottom: 30),
                          width: double.infinity,
                          height: 1,
                          color: const Color(0xFFc7d2d0),
                        ),
                        Positioned(
                          top: 22,
                          left: 160,
                          child: Container(
                            width: 33,
                            height: 33,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Center(
                              child: Text(
                                'or',
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF648683),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 400,
                      margin: const EdgeInsets.only(top: 0),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          Text(
                            'Don’t have an account?',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF0f625c),
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const SignupPage()));
                            },
                            child: Text(
                              'Sign Up',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF0da99e),
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(
          color: Color(0xFF0f625c),
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(
          color: Colors.white,
          width: 1,
        ),
      ),
      hintText: hintText,
      hintStyle: GoogleFonts.poppins(
        color: const Color(0xFF648683),
        fontSize: 15,
      ),
    );
  }
}