// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:wealthclock28/biometric_auth.dart';
import 'package:wealthclock28/extras/signupPdsfirst.dart';
// Make sure to import this for JSON handling
import 'forgot_password.dart';
import '../extras/terms_condition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_after_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Create a storage instance
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  final emailText = TextEditingController();
  final passText = TextEditingController();
  final panText = TextEditingController();
  bool isLoading = false; // For showing a loading spinner

  // Function to show the error or success messages
  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials(); // ✅ Load saved credentials when screen loads
  }

  Future<void> _loadSavedCredentials() async {
    String? savedEmail = await secureStorage.read(key: 'saved_email');
    String? savedPassword = await secureStorage.read(key: 'saved_password');
    String? savedPan = await secureStorage.read(key: 'saved_pan');

    if (savedEmail != null && savedPassword != null && savedPan != null) {
      setState(() {
        emailText.text = savedEmail;
        passText.text = savedPassword;
        panText.text = savedPan;
      });
    }
  }

  Future<void> _login() async {
    String uEmail = emailText.text.trim();
    String uPass = passText.text.trim();
    String uPan = panText.text.trim();

    if (uEmail.isEmpty || uPass.isEmpty) {
      _showMessage("Please enter email and password");
      //print("Login failed: Email or Password is empty");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // API URL based on whether PAN is provided
      final apiUrl = uPan.isEmpty
          ? 'https://wealthclockadvisors.com/api/client/login'
          : 'https://wealthclockadvisors.com/api/client/login-with-pan';

      //print("Attempting to login with email: $uEmail");

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'email': uEmail, 'password': uPass, 'pan': uPan},
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('token') &&
            responseData.containsKey('userId')) {
          String token = responseData['token'];
          String userId = responseData['userId'].toString();
          String userName = responseData['userName'].toString();
          String? expiresAt = responseData['expiresAt'];

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          await prefs.setString('user_id', userId);
          await prefs.setString('user_name', userName);
          if (expiresAt != null) {
            await prefs.setString('expires_at', expiresAt);
          }

          // Additional check before navigating
          if (prefs.getString('auth_token') == null ||
              prefs.getString('user_id') == null) {
            _showMessage("Something went wrong while saving login data.");
            return;
          }

          _showMessage("Login successful.");

          // Check if biometric setup prompt was already shown
          bool setupDone = prefs.getBool('biometric_setup_done') ?? false;

          if (!setupDone) {
            final enableBiometric = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text("Enable Biometric Login?"),
                content: const Text(
                  "Would you like to use fingerprint or face ID to quickly log in next time?",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text("No"),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text("Yes"),
                  ),
                ],
              ),
            );

            final prefs = await SharedPreferences.getInstance();

            if (enableBiometric == true) {
              final biometric = BiometricAuth();
              final success = await biometric.enableBiometricAuth();

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("✅ Biometric login enabled")),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("❌ Failed to enable biometric login")),
                );
              }
            }

            // Mark that the setup prompt was shown (regardless of user choice)
            await prefs.setBool('biometric_setup_done', true);
          }

          // Only show prompt if it has never been shown
          // if (!setupDone) {
          //   final enableBiometric = await showDialog<bool>(
          //     context: context,
          //     builder: (ctx) => AlertDialog(
          //       title: const Text("Enable Biometric Login?"),
          //       content: const Text(
          //           "Would you like to use fingerprint/face ID to quickly login next time?"),
          //       actions: [
          //         TextButton(
          //           onPressed: () => Navigator.pop(ctx, false),
          //           child: const Text("No"),
          //         ),
          //         ElevatedButton(
          //           onPressed: () => Navigator.pop(ctx, true),
          //           child: const Text("Yes"),
          //         ),
          //       ],
          //     ),
          //   );

          //   if (enableBiometric == true) {
          //     final biometric = BiometricAuth();
          //     final success = await biometric.checkBiometric(setupMode: true);

          //     if (success) {
          //       await prefs.setBool('isBiometricEnabled', true);
          //     }
          //   }

          //   // Mark that the prompt was shown, regardless of user choice
          //   await prefs.setBool('biometric_setup_done', true);
          // }

          // Navigate to dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => dashboardAfterLogin(userId: userId)),
          );
        } else {
          _showMessage("Unexpected response from server.");
        }
      } else {
        // Handle different status codes with better error handling
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        String errorMessage =
            errorResponse['message'] ?? "Login failed. Please try again.";

        //print("Login error: $errorMessage");
        _showMessage(errorMessage);
      }

      //print("Response status code: ${response.statusCode}");
      //print("Response body: ${response.body}");

      // if (response.statusCode == 200) {
      //   final Map<String, dynamic> responseData = json.decode(response.body);

      //   if (responseData.containsKey('token') &&
      //       responseData.containsKey('userId')) {
      //     String token = responseData['token'];
      //     String userId = responseData['userId'].toString();
      //     String userName = responseData['userName'].toString();
      //     String? expiresAt = responseData['expiresAt'];

      //     SharedPreferences prefs = await SharedPreferences.getInstance();
      //     await prefs.setString('auth_token', token);
      //     await prefs.setString('user_id', userId);
      //     await prefs.setString('user_name', userName);
      //     if (expiresAt != null) {
      //       await prefs.setString('expires_at', expiresAt);
      //     }

      //     // Additional check before navigating
      //     if (prefs.getString('auth_token') == null ||
      //         prefs.getString('user_id') == null) {
      //       _showMessage("Something went wrong while saving login data.");
      //       return;
      //     }

      //     _showMessage("Login successful.");

      //     Navigator.pushReplacement(
      //       // ignore: use_build_context_synchronously
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => dashboardAfterLogin(userId: userId),
      //       ),
      //     );
      //   } else {
      //     //print("Unexpected response structure.");
      //     _showMessage("Unexpected response from server.");
      //   }
      // }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      //print("Exception caught: $e");
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
                autofillHints: [AutofillHints.email],
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
                autofillHints: [AutofillHints.password],
              ),
              const SizedBox(height: 14),
              TextField(
                controller: panText,
                decoration: _inputDecoration('PAN ID (Optional)'),
                style: const TextStyle(color: Color(0xFF648683), fontSize: 15),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'[A-Z0-9]')), // Only uppercase letters & numbers
                  UpperCaseTextFormatter(), // Converts lowercase to uppercase automatically
                ],
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
                        color: Colors.white,
                      ) // Show loading spinner
                    : Text(
                        'SIGN IN',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF222222),
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
              // Container(
              //   margin: const EdgeInsets.only(
              //     top: 10,
              //     bottom: 3,
              //   ),
              //   child: TextButton(
              //     onPressed: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => const ForgotPasswordPage(),
              //         ),
              //       );
              //     },
              //     child: Text(
              //       'Forgot Password?',
              //       style: GoogleFonts.poppins(
              //         fontSize: 17,
              //         fontWeight: FontWeight.w600,
              //         color: const Color(0xFF0f625c),
              //         decoration: TextDecoration.underline,
              //         decorationColor: const Color(0xFF0f625c),
              //         decorationThickness: 1.2,
              //         height: 0.5,
              //       ),
              //     ),
              //   ),
              // ),

              SizedBox(height: 10),

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
                                builder: (context) => const TermsCondPage(),
                              ),
                            );
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
                    // Stack(
                    //   children: [
                    //     Container(
                    //       margin: const EdgeInsets.only(top: 40, bottom: 30),
                    //       width: double.infinity,
                    //       height: 1,
                    //       color: const Color(0xFFc7d2d0),
                    //     ),
                    //     Positioned(
                    //       top: 22,
                    //       left: 160,
                    //       child: Container(
                    //         width: 33,
                    //         height: 33,
                    //         decoration: BoxDecoration(
                    //           color: Colors.white,
                    //           borderRadius: BorderRadius.circular(100),
                    //         ),
                    //         child: Center(
                    //           child: Text(
                    //             'or',
                    //             style: GoogleFonts.poppins(
                    //               color: const Color(0xFF648683),
                    //               fontSize: 17,
                    //               fontWeight: FontWeight.w400,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Container(
                    //   width: 400,
                    //   margin: const EdgeInsets.only(top: 0),
                    //   child: Wrap(
                    //     alignment: WrapAlignment.center,
                    //     children: [
                    //       Text(
                    //         'Don’t have an account?',
                    //         style: GoogleFonts.poppins(
                    //           color: const Color(0xFF0f625c),
                    //           fontSize: 17,
                    //           fontWeight: FontWeight.w500,
                    //         ),
                    //       ),
                    //       InkWell(
                    //         onTap: () {
                    //           Navigator.push(
                    //             context,
                    //             PageRouteBuilder(
                    //               transitionDuration: Duration(milliseconds: 500), // ✅ Smooth transition
                    //               pageBuilder: (context, animation, secondaryAnimation) => const SignupPdsFirst(),
                    //               transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    //                 const begin = Offset(1.0, 0.0); // ✅ Slide from right
                    //                 const end = Offset.zero; // ✅ End position (normal)
                    //                 const curve = Curves.easeInOut;

                    //                 var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                    //                 var offsetAnimation = animation.drive(tween);

                    //                 return SlideTransition(
                    //                   position: offsetAnimation,
                    //                   child: child,
                    //                 );
                    //               },
                    //             ),
                    //           );
                    //         },
                    //         child: Text(
                    //           'Sign Up',
                    //           style: GoogleFonts.poppins(
                    //             color: const Color(0xFF0da99e),
                    //             fontSize: 17,
                    //             fontWeight: FontWeight.w500,
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                              color: Colors.white, // Optional background color
                              borderRadius:
                                  BorderRadius.circular(100), // Rounded corners
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 400,
                              margin: const EdgeInsets.only(top: 70),
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                children: [
                                  Text(
                                    'Don\'t have an account? ',
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFF0f625c),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      // Handle the link click here
                                      //print('Sign up clicked');
                                      // Navigate to the Terms and Conditions page if needed
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const SignupPdsFirst(),
                                        ),
                                      );
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
                      ],
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
