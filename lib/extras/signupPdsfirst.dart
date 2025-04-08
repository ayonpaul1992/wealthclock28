// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/login.dart';
import 'signupAds.dart';
import 'signupPds.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SignupPdsFirst extends StatefulWidget {
  const SignupPdsFirst({super.key});

  @override
  State<SignupPdsFirst> createState() => _SignupPdsFirstState();
}

class _SignupPdsFirstState extends State<SignupPdsFirst> {
  final emailText = TextEditingController();
  final passText = TextEditingController();
  final repassText = TextEditingController();
  final phoneText = TextEditingController();
  final othersController = TextEditingController();
  final pdsAddressController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode passFocusNode = FocusNode();
  FocusNode repassFocusNode = FocusNode();
  bool isLoading = false;
  bool _isPanVisible = false; // For showing a loading spinner
  bool _isrePasVisible = false; // For showing a loading spinner
  String _emailError = '';
  String _phoneError = '';
  String _passError = '';
  String _repassError = '';
  // Function to show the error or success messages

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    super.initState();
    emailFocusNode.addListener(_handleEmailFocusChange);
    phoneFocusNode.addListener(_handlePhoneFocusChange);
    passFocusNode.addListener(_handlePassFocusChange);
    repassFocusNode.addListener(_handleRepassFocusChange);
  }

  @override
  void dispose() {
    emailFocusNode.removeListener(_handleEmailFocusChange);
    phoneFocusNode.removeListener(_handlePhoneFocusChange);
    passFocusNode.removeListener(_handlePassFocusChange);
    repassFocusNode.removeListener(_handleRepassFocusChange);
    emailFocusNode.dispose();
    phoneFocusNode.dispose();
    passFocusNode.dispose();
    repassFocusNode.dispose();
    super.dispose();
  }

  void _handleEmailFocusChange() {
    if (!emailFocusNode.hasFocus) {
      setState(() {
        _emailError = _validateEmail(emailText.text);
      });
    }
  }

  void _handlePhoneFocusChange() {
    if (!phoneFocusNode.hasFocus) {
      setState(() {
        _phoneError = _validatePhone(phoneText.text);
      });
    }
  }

  void _handlePassFocusChange() {
    if (!passFocusNode.hasFocus) {
      setState(() {
        _passError = _validatePassword(passText.text);
      });
    }
  }

  void _handleRepassFocusChange() {
    if (!repassFocusNode.hasFocus) {
      setState(() {
        _repassError = _validateRePassword(repassText.text);
      });
    }
  }

  String _validateEmail(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'Please enter your email address.';
    }
    if (!trimmed.contains('@') || !trimmed.contains('.')) {
      return 'Please enter a valid email address.';
    }
    return '';
  }

  String _validatePhone(String value) {
    if (value.trim().isEmpty) {
      return 'Please enter your phone number.';
    }
    if (value.trim().length != 10) {
      return 'Phone number must be 10 digits.';
    }
    return '';
  }

  String _validatePassword(String value) {
    if (value.trim().isEmpty) {
      return 'Please enter your password.';
    }
    // You can add more password strength validation here if needed
    return '';
  }

  String _validateRePassword(String value) {
    if (value.trim().isEmpty) {
      return 'Please re-enter your password.';
    }
    if (value.trim() != passText.text.trim()) {
      return 'Passwords do not match.';
    }
    return '';
  }

  bool _isValidEmail(String value) {
    return value.trim().isNotEmpty &&
        value.trim().contains('@') &&
        value.trim().contains('.');
  }

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
                'Register your account'.toUpperCase(),
                style: GoogleFonts.poppins(
                  color: const Color(0xFF0f625c),
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 90,
                        height: 1,
                        color: const Color(0xFFc7d2d0),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Personal Details',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF3F4B4B),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 90,
                        height: 1,
                        color: const Color(0xFFc7d2d0),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Wrap(
                  spacing: 10, // Space between text fields

                  runSpacing: 15,

                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            left: 10,
                          ),
                          child: Text(
                            'Email Id',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF6E7B7A),
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.1), // Shadow color

                                blurRadius: 15, // Blur effect

                                spreadRadius: 0, // Spread effect

                                offset: Offset(0, 3), // Position of shadow
                              ),
                            ],
                          ),
                          child: SizedBox(
                            width: 171,
                            child: TextField(
                              controller: emailText,
                              decoration: _inputDecoration(''),
                              style: const TextStyle(
                                color: Color(0xFF648683),
                                fontSize: 14,
                              ),
                              autofillHints: [AutofillHints.email],
                              onChanged: (value) {
                                setState(() {
                                  _emailError = _validateEmail(value);
                                });
                              },
                            ),
                          ),
                        ),
                        if (_emailError.isNotEmpty)
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, top: 5.0),
                            child: Text(
                              _emailError,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            left: 10,
                          ),
                          child: Text(
                            'Phone',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF6E7B7A),
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 15,
                                spreadRadius: 0,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: SizedBox(
                            width: 171,
                            child: TextField(
                              controller: phoneText,
                              keyboardType: TextInputType.phone,
                              decoration: _inputDecoration(''),
                              style: const TextStyle(
                                color: Color(0xFF648683),
                                fontSize: 14,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter
                                    .digitsOnly, // Allow only digits

                                LengthLimitingTextInputFormatter(
                                    10), // Limit to 10 characters
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _phoneError = _validatePhone(value);
                                });
                              },
                            ),
                          ),
                        ),
                        if (_phoneError.isNotEmpty)
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, top: 5.0),
                            child: Text(
                              _phoneError,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            left: 10,
                          ),
                          child: Text(
                            'Password',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF6E7B7A),
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.1), // Shadow color

                                blurRadius: 15, // Blur effect

                                spreadRadius: 0, // Spread effect

                                offset: Offset(0, 3), // Position of shadow
                              ),
                            ],
                          ),
                          child: SizedBox(
                            width: 171,
                            child: TextField(
                              controller: passText,

                              obscureText:
                                  !_isPanVisible, // Toggle text visibility

                              decoration:
                                  _inputDecoration('**********').copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPanVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: const Color(0xFF648683),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPanVisible =
                                          !_isPanVisible; // Toggle visibility
                                    });
                                  },
                                ),
                              ),

                              style: const TextStyle(
                                  color: Color(0xFF648683), fontSize: 15),

                              autofillHints: const [AutofillHints.password],
                              onChanged: (value) {
                                setState(() {
                                  _passError = _validatePassword(value);
                                  _repassError =
                                      _validateRePassword(repassText.text);
                                });
                              },
                            ),
                          ),
                        ),
                        if (_passError.isNotEmpty)
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, top: 5.0),
                            child: Text(
                              _passError,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            left: 10,
                          ),
                          child: Text(
                            'Re-Password',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF6E7B7A),
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.1), // Shadow color

                                blurRadius: 15, // Blur effect

                                spreadRadius: 0, // Spread effect

                                offset: Offset(0, 3), // Position of shadow
                              ),
                            ],
                          ),
                          child: SizedBox(
                            width: 171,
                            child: TextField(
                              controller: repassText,

                              obscureText:
                                  !_isrePasVisible, // Toggle text visibility

                              decoration:
                                  _inputDecoration('**********').copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isrePasVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: const Color(0xFF648683),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isrePasVisible =
                                          !_isrePasVisible; // Toggle visibility
                                    });
                                  },
                                ),
                              ),

                              style: const TextStyle(
                                  color: Color(0xFF648683), fontSize: 15),

                              autofillHints: const [AutofillHints.password],
                              onChanged: (value) {
                                setState(() {
                                  _repassError = _validateRePassword(value);
                                });
                              },
                            ),
                          ),
                        ),
                        if (_repassError.isNotEmpty)
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, top: 5.0),
                            child: Text(
                              _repassError,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Run all validators and update the UI
                      setState(() {
                        _emailError = _validateEmail(emailText.text);
                        _phoneError = _validatePhone(phoneText.text);
                        _passError = _validatePassword(passText.text);
                        _repassError = _validateRePassword(repassText.text);
                      });

                      // Check if any validation failed
                      if (_emailError.isNotEmpty ||
                          _phoneError.isNotEmpty ||
                          _passError.isNotEmpty ||
                          _repassError.isNotEmpty) {
                        // Show the first available error using SnackBar
                        final firstError = _emailError.isNotEmpty
                            ? _emailError
                            : _phoneError.isNotEmpty
                            ? _phoneError
                            : _passError.isNotEmpty
                            ? _passError
                            : _repassError;

                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(content: Text(firstError)),
                        // );
                        return; // Prevent navigation
                      }

                      // Final checks (redundant safety for double protection)
                      final phone = phoneText.text.trim();
                      final pass = passText.text.trim();
                      final repass = repassText.text.trim();

                      if (phone.length != 10 || !RegExp(r'^\d{10}$').hasMatch(phone)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Phone number must be exactly 10 digits.')),
                        );
                        return;
                      }

                      if (pass != repass) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Passwords do not match.')),
                        );
                        return;
                      }

                      // ✅ All validations passed, move to next page
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 500),
                          pageBuilder: (context, animation, secondaryAnimation) =>
                          const SignupPdsPage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.easeInOut;
                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);
                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );

                      // (Optional) Print captured data for debug
                      print("Email: ${emailText.text.trim()}");
                      print("Phone: $phone");
                      print("Password: $pass");
                      print("Re-Password: $repass");
                      print("Others: ${othersController.text.trim()}");
                      print("Address: ${pdsAddressController.text.trim()}");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFfdd1a0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 35),
                    ),
                    child: Text(
                      'Next'.toUpperCase(),
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF222222),
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
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
                                    'Have an account?',
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFF0f625c),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      print('Sign In clicked');

                                      // Navigate with slide transition
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          transitionDuration: Duration(
                                              milliseconds:
                                                  500), // ✅ Smooth transition
                                          pageBuilder: (context, animation,
                                                  secondaryAnimation) =>
                                              const LoginPage(),
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
                                            const begin = Offset(-1.0,
                                                0.0); // ✅ Slide from right
                                            const end = Offset
                                                .zero; // ✅ End position (normal)
                                            const curve = Curves.easeInOut;

                                            var tween = Tween(
                                                    begin: begin, end: end)
                                                .chain(
                                                    CurveTween(curve: curve));
                                            var offsetAnimation =
                                                animation.drive(tween);

                                            return SlideTransition(
                                              position: offsetAnimation,
                                              child: child,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Sign In',
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
              SizedBox(
                height: 30,
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
        fontSize: 14,
      ),
    );
  }
}
