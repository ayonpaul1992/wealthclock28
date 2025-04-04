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
  bool isLoading = false;
  bool _isPanVisible = false; // For showing a loading spinner
  bool _isrePasVisible = false; // For showing a loading spinner
  // Function to show the error or success messages

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
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
                                color: Colors.black.withOpacity(0.1), // Shadow color
                                blurRadius: 15, // Blur effect
                                spreadRadius: 0, // Spread effect
                                offset: Offset(0,3), // Position of shadow
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
                            ),
                          ),
                        )
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
                                FilteringTextInputFormatter.digitsOnly, // Allow only digits
                                LengthLimitingTextInputFormatter(10), // Limit to 10 characters
                              ],
                            ),
                          ),
                        )
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
                                color: Colors.black.withOpacity(0.1), // Shadow color
                                blurRadius: 15, // Blur effect
                                spreadRadius: 0, // Spread effect
                                offset: Offset(0,3), // Position of shadow
                              ),
                            ],
                          ),
                          child: SizedBox(
                            width: 171,
                            child: TextField(
                              controller: passText,
                              obscureText: !_isPanVisible, // Toggle text visibility
                              decoration: _inputDecoration('**********').copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPanVisible ? Icons.visibility : Icons.visibility_off,
                                    color: const Color(0xFF648683),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPanVisible = !_isPanVisible; // Toggle visibility
                                    });
                                  },
                                ),
                              ),
                              style: const TextStyle(color: Color(0xFF648683), fontSize: 15),
                              autofillHints: const [AutofillHints.password],
                            ),
                          ),
                        )
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
                                color: Colors.black.withOpacity(0.1), // Shadow color
                                blurRadius: 15, // Blur effect
                                spreadRadius: 0, // Spread effect
                                offset: Offset(0,3), // Position of shadow
                              ),
                            ],
                          ),
                          child: SizedBox(
                            width: 171,
                            child: TextField(
                              controller: repassText,
                              obscureText: !_isrePasVisible, // Toggle text visibility
                              decoration: _inputDecoration('**********').copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isrePasVisible ? Icons.visibility : Icons.visibility_off,
                                    color: const Color(0xFF648683),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isrePasVisible = !_isrePasVisible; // Toggle visibility
                                    });
                                  },
                                ),
                              ),
                              style: const TextStyle(color: Color(0xFF648683), fontSize: 15),
                              autofillHints: const [AutofillHints.password],
                            ),
                          ),
                        )
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
                      if (emailText.text.trim().isEmpty ||
                          phoneText.text.trim().isEmpty ||
                          passText.text.trim().isEmpty ||
                          repassText.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please fill in all the fields.')),
                        );
                        return; // Do not proceed if fields are empty
                      }

                      if (!emailText.text.trim().contains('@') || !emailText.text.trim().contains('.')) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter a valid email address.')),
                        );
                        return;
                      }

                      if (phoneText.text.trim().length != 10) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Phone number must be 10 digits.')),
                        );
                        return;
                      }

                      if (passText.text.trim() != repassText.text.trim()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Passwords do not match.')),
                        );
                        return; // Do not proceed if passwords don't match
                      }

                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 500),
                          pageBuilder: (context, animation, secondaryAnimation) => const SignupPdsPage(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.easeInOut;

                            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );

                      // Capture user input and print
                      String uemailText = emailText.text.trim();
                      String upassText = passText.text.trim();
                      String urepassText = repassText.text.trim();
                      String uphoneText = phoneText.text.trim();
                      String uPdsOthrContrl = othersController.text.trim();
                      String uPdsAddrsContrl = pdsAddressController.text.trim();

                      print("Others Controller: $uPdsOthrContrl, Address Controller: $uPdsAddrsContrl, Email Id: $uemailText, Password: $upassText, Re-Password: $urepassText, Phone: $uphoneText");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFfdd1a0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 35),
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
                                          transitionDuration: Duration(milliseconds: 500), // ✅ Smooth transition
                                          pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(),
                                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                            const begin = Offset(-1.0, 0.0); // ✅ Slide from right
                                            const end = Offset.zero; // ✅ End position (normal)
                                            const curve = Curves.easeInOut;

                                            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                            var offsetAnimation = animation.drive(tween);

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
