// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final emailText = TextEditingController();
  final panText = TextEditingController();

  bool _hideValidation = true;

  bool showPanField = false;

  @override
  void dispose() {
    emailText.dispose();
    panText.dispose();
    super.dispose();
  }

  Future<void> getEmail() async {
    final String uEmail = emailText.text;
    final String uPan = panText.text;

    const String apiUrl =
        'https://wealthclockadvisors.com/api/client/forgot-password';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'email': uEmail, 'pan': uPan},
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final errorMessage =
            jsonResponse['message'] ?? 'Unknown error occurred';
        SnackBar snackBar = SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.green,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        final jsonResponse = jsonDecode(response.body);
        final errorMessage =
            jsonResponse['message'] ?? 'Unknown error occurred';
        SnackBar snackBar = SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        final showPan = jsonResponse['show_pan'] ?? false;

        setState(() {
          showPanField = showPan;
        });
      }
    } catch (e) {
      final errorMessage = 'Something went wrong. Please try again.';
      SnackBar snackBar = SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
          setState(() => _hideValidation = true);
          _formKey.currentState?.validate();
        },
        child: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFfffaf5), Color(0xFFe7f6f5)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              autovalidateMode: _hideValidation
                  ? AutovalidateMode.disabled
                  : AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  Image.asset('assets/images/logo_img.png', height: 120),

                  const SizedBox(height: 30),

                  Text(
                    'Password Reset'.toUpperCase(),
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF0f625c),
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ---------------- EMAIL ----------------
                  TextFormField(
                    controller: emailText,
                    decoration: _inputDecoration("Enter Your Email Address"),
                    style:
                        const TextStyle(color: Color(0xFF648683), fontSize: 15),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return _hideValidation
                            ? null
                            : "Please enter email address";
                      }

                      final emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$';
                      if (!RegExp(emailPattern).hasMatch(value)) {
                        return "Enter a valid email";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 14),

                  // ---------------- PAN ----------------
                  if (showPanField)
                    TextFormField(
                      controller: panText,
                      inputFormatters: [
                        // FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                        UpperCaseTextFormatter(),
                      ],
                      decoration: _inputDecoration("Enter PAN ID"),
                      style: const TextStyle(
                          color: Color(0xFF648683), fontSize: 15),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return _hideValidation ? null : "PAN cannot be empty";
                        }

                        final panPattern = r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$';
                        if (!RegExp(panPattern).hasMatch(value)) {
                          return "Invalid PAN format";
                        }

                        return null;
                      },
                    ),

                  const SizedBox(height: 20),

                  // ---------------- SUBMIT BUTTON ----------------
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFfdd1a0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 35,
                      ),
                    ),
                    onPressed: () {
                      setState(() => _hideValidation = false);

                      // Validate only email first
                      bool emailValid =
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$')
                              .hasMatch(emailText.text);

                      if (!emailValid) {
                        // email invalid, do not show PAN
                        // setState(() => showPanField = false);
                        _formKey.currentState!.validate();
                        return;
                      }

                      getEmail();

                      // Email valid → show PAN field
                      // setState(() => showPanField = true);

                      // If PAN is visible → validate the whole form
                      if (showPanField && _formKey.currentState!.validate()) {
                        debugPrint("VALID Email & PAN");
                      }
                    },
                    child: Text(
                      "SUBMIT",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF222222),
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // ---------------- SIGN IN LINK ----------------
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Have an account?',
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
                                builder: (_) => const LoginPage()),
                          );
                        },
                        child: Text(
                          '  Sign In',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF0da99e),
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
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
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Colors.white, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Color(0xFF0f625c), width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Colors.white, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Colors.white, width: 1),
      ),
      errorStyle: const TextStyle(color: Colors.red, fontSize: 13),
      hintText: hintText,
      hintStyle: GoogleFonts.poppins(
        color: const Color(0xFF648683),
        fontSize: 15,
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}
