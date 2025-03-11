import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailText = TextEditingController();
  final passText = TextEditingController();
  final phoneText = TextEditingController();
  final repassText = TextEditingController();
  bool isLoading = false;
  bool _isPanVisible = false;// For showing a loading spinner
  // Function to show the error or success messages
  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                margin: const EdgeInsets.only(top: 80),
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
              const SizedBox(height: 20),
              TextField(
                controller: emailText,
                decoration: _inputDecoration('Your Email'),
                style: const TextStyle(
                  color: Color(0xFF648683),
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: phoneText,
                decoration: _inputDecoration('Your Phone No.'),
                style: const TextStyle(
                  color: Color(0xFF648683),
                  fontSize: 15,
                ),
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
                controller: repassText,
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
                style: const TextStyle(
                  color: Color(0xFF648683),
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 14),
              ElevatedButton(
                onPressed: () {
                  String uEmail = emailText.text.trim();
                  String urepass = repassText.text.trim();
                  String uPhone = phoneText.text.trim();
                  String uPass = passText.text.trim();
                  print(
                      "Email: $uEmail, Password: $uPass,Re-Password: $urepass,Phone: $uPhone");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFfdd1a0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 35),
                ),
                child: Text(
                  'SIGN UP'.toUpperCase(),
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF222222),
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
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
                                    'Have an account?',
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFF0f625c),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      // Handle the link click here
                                      print('Sign up clicked');
                                      // Navigate to the Terms and Conditions page if needed
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage()));
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
