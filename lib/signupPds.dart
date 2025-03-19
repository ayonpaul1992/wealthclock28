import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login.dart';

class SignupPdsPage extends StatefulWidget {
  const SignupPdsPage({super.key});

  @override
  State<SignupPdsPage> createState() => _SignupPdsPageState();
}

class _SignupPdsPageState extends State<SignupPdsPage> {
  final firstNameText = TextEditingController();
  final lastNameText = TextEditingController();
  final TextEditingController holdingNtrText = TextEditingController();
  bool isDropdownOpen = false;
  OverlayEntry? dropdownOverlay;
  final LayerLink _layerLink = LayerLink();

  List<String> dropdownItems = ["Option 1", "Option 2", "Option 3"];
  String selectedItem = "Select";

  void toggleDropdown() {
    if (isDropdownOpen) {
      closeDropdown();
    } else {
      openDropdown();
    }
  }
  void openDropdown() {
    final overlay = Overlay.of(context);
    dropdownOverlay = OverlayEntry(
      builder: (context) => Positioned(
        width: 171, // Same width as text field
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(0, 45), // Adjust dropdown position
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: dropdownItems.map((item) {
                return ListTile(
                  title: Text(
                    item,
                    style: const TextStyle(
                      color: Color(0xFF648683),
                      fontSize: 15,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      selectedItem = item;
                      holdingNtrText.text = item;
                      closeDropdown();
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );

    overlay.insert(dropdownOverlay!);
    setState(() {
      isDropdownOpen = true;
    });
  }

  void closeDropdown() {
    dropdownOverlay?.remove();
    dropdownOverlay = null;
    setState(() {
      isDropdownOpen = false;
    });
  }
  final panNoText = TextEditingController();
  final passText = TextEditingController();
  final repassText = TextEditingController();
  bool isLoading = false;
  bool _isPanVisible = false; // For showing a loading spinner
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
              SingleChildScrollView(
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
                            'First Name',
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
                          width: 171,
                          child: TextField(
                            controller: firstNameText,
                            decoration: _inputDecoration(''),
                            style: const TextStyle(
                              color: Color(0xFF648683),
                              fontSize: 15,
                            ),
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
                            'Last Name',
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
                          width: 171,
                          child: TextField(
                            controller: lastNameText,
                            decoration: _inputDecoration(''),
                            style: const TextStyle(
                              color: Color(0xFF648683),
                              fontSize: 15,
                            ),
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
                            'Holding Nature',
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
                        CompositedTransformTarget(
                          link: _layerLink,
                          child: Container(
                            width: 171,
                            child: GestureDetector(
                              onTap: toggleDropdown,
                              child: AbsorbPointer(
                                child: TextField(
                                  controller: holdingNtrText,
                                  decoration: InputDecoration(
                                    hintText: 'Select',
                                    suffixIcon: Icon(
                                      isDropdownOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                      color: Color(0xFF648683),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      borderSide: BorderSide(color: Color(0xFF648683), width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      borderSide: BorderSide(color: Color(0xFF0f625c), width: 1),
                                    ),
                                  ),
                                  style: const TextStyle(
                                    color: Color(0xFF648683),
                                    fontSize: 15,
                                  ),
                                ),
                              ),
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
                            'PAN No.',
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
                          width: 171,
                          child: TextField(
                            controller: panNoText,
                            decoration: _inputDecoration(''),
                            style: const TextStyle(
                              color: Color(0xFF648683),
                              fontSize: 15,
                            ),
                          ),
                          // child: TextField(
                          //   controller: repassText,
                          //   obscureText: !_isPanVisible, // Toggle text visibility
                          //   decoration: _inputDecoration('').copyWith(
                          //     suffixIcon: IconButton(
                          //       icon: Icon(
                          //         _isPanVisible ? Icons.visibility : Icons.visibility_off,
                          //         color: Color(0xFF648683),
                          //       ),
                          //       onPressed: () {
                          //         setState(() {
                          //           _isPanVisible = !_isPanVisible; // Toggle visibility
                          //         });
                          //       },
                          //     ),
                          //   ),
                          //   style: const TextStyle(
                          //     color: Color(0xFF648683),
                          //     fontSize: 15,
                          //   ),
                          // ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              ElevatedButton(
                onPressed: () {
                  String ufName = firstNameText.text.trim();
                  String ulName = lastNameText.text.trim();
                  String uHdNtr = holdingNtrText.text.trim();
                  String uPanNo = panNoText.text.trim();
                  String urepass = repassText.text.trim();
                  String uPass = passText.text.trim();
                  print(
                      "First Name: $ufName, Password: $uPass,Re-Password: $urepass,Last Name: $ulName,Pan No.: $uPanNo,Holding nature: $uHdNtr");
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
