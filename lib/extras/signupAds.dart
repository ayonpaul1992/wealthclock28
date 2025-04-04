import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../screens/login.dart';
import 'signupPds.dart';
import 'signupNds.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SignupAdsPage extends StatefulWidget {
  const SignupAdsPage({super.key});

  @override
  State<StatefulWidget> createState() => _SignupAdsPageState();
}

class _SignupAdsPageState extends State<SignupAdsPage> {
  final ifscCodeText = TextEditingController();
  final micrCodeText = TextEditingController();
  final acNoText = TextEditingController();
  final branchNameText = TextEditingController();
  final TextEditingController acTypeText = TextEditingController();

  bool isAcTypeDropdownOpen = false;
  OverlayEntry? actypeOverlay;

  // Fixed incorrect class
  final LayerLink _layerAcTypeLink = LayerLink(); // Fixed incorrect class

  List<String> acTypeItems = ["Savings", "Current"];

  String selectedAcType = "Select";

  void toggleAcTypeDropdown() {
    if (isAcTypeDropdownOpen) {
      closeAcTypeDropdown();
    } else {
      openAcTypeDropdown();
    }
  }

  void openAcTypeDropdown() {
    closeAcTypeDropdown();
    final overlay = Overlay.of(context);
    actypeOverlay = OverlayEntry(
      builder: (context) => Positioned(
        width: 171, // Same width as text field
        child: CompositedTransformFollower(
          link: _layerAcTypeLink,
          offset: Offset(0, 45), // Adjust dropdown position
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: acTypeItems.map((item) {
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
                      selectedAcType = item;
                      acTypeText.text = item;
                      closeAcTypeDropdown();
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );

    overlay.insert(actypeOverlay!);
    setState(() {
      isAcTypeDropdownOpen = true;
    });
  }

  void closeAcTypeDropdown() {
    actypeOverlay?.remove();
    actypeOverlay = null;
    setState(() {
      isAcTypeDropdownOpen = false;
    });
  }

  final panNoText = TextEditingController();
  final bankNameText = TextEditingController();
  // final passText = TextEditingController();
  // final repassText = TextEditingController();
  final othersController = TextEditingController();
  final pdsAddressController = TextEditingController();
  bool isLoading = false;
  bool isNomineeBox = false;

  // check button nominee applicable purpose start
  List<String> nmAplyoptions = ['YES', 'NO'];
  String nmAplyselectedOption = "YES";
  // check button nominee applicable purpose end

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
              const SizedBox(height: 10),
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
                        'Bank Details',
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
                            'Account No',
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
                            width: double.infinity,
                            child: TextField(
                              controller: acNoText,
                              decoration: _inputDecoration(''),
                              style: const TextStyle(
                                color: Color(0xFF648683),
                                fontSize: 14,
                              ),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(
                                      20), // Limit to 25 characters
                                ]
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
                            'IFSC Code',
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
                              controller: ifscCodeText,
                              decoration: _inputDecoration(''),
                              style: const TextStyle(
                                color: Color(0xFF648683),
                                fontSize: 14,
                              ),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(
                                      12), // Limit to 25 characters
                                ]
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
                            'MICR Code',
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
                              controller: micrCodeText,
                              decoration: _inputDecoration(''),
                              style: const TextStyle(
                                color: Color(0xFF648683),
                                fontSize: 14,
                              ),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(
                                      9), // Limit to 25 characters
                                ]
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
                            'Bank Name',
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
                              controller: bankNameText,
                              decoration: _inputDecoration(''),
                              style: const TextStyle(
                                color: Color(0xFF648683),
                                fontSize: 14,
                              ),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(
                                      50), // Limit to 25 characters
                                ]
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
                            'Account Type',
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
                        Stack(
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior
                                  .translucent, // ✅ Detects taps outside
                              onTap: () {
                                if (isAcTypeDropdownOpen) {
                                  closeAcTypeDropdown(); // ✅ Close dropdown when clicking outside
                                }
                                FocusManager.instance.primaryFocus
                                    ?.unfocus(); // Remove focus
                              },
                              child: Container(
                                width: 171,
                              ), // Empty container to detect taps outside
                            ),
                            CompositedTransformTarget(
                              link: _layerAcTypeLink,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
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
                                    controller: acTypeText,
                                    readOnly:
                                        true, // ✅ Allows focus but prevents keyboard popup
                                    onTap:
                                        toggleAcTypeDropdown, // ✅ Opens dropdown on tap
                                    decoration: InputDecoration(
                                      hintText: 'Select',
                                      hintStyle: GoogleFonts.poppins(
                                        color: Color(0xFF648683),
                                        fontSize: 14,
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                          top: 8,
                                          bottom: 8,
                                          left: 15,
                                          right: 15),
                                      suffixIcon: Icon(
                                        isAcTypeDropdownOpen
                                            ? Icons.keyboard_arrow_up
                                            : Icons.keyboard_arrow_down,
                                        color: Color(0xFF648683),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 1),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: BorderSide(
                                            color: Color(0xFF0f625c), width: 1),
                                      ),
                                    ),
                                    style: const TextStyle(
                                      color: Color(0xFF648683),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                            'Branch Name',
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
                            width: double.infinity,
                            child: TextField(
                              controller: branchNameText,
                              decoration: _inputDecoration(''),
                              style: const TextStyle(
                                color: Color(0xFF648683),
                                fontSize: 14,
                              ),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(
                                      50), // Limit to 25 characters
                                ]
                            ),
                          ),
                        )
                      ],
                    ),
                SizedBox(height: 2,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignupPdsPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFfdd1a0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 35),
                      ),
                      child: Text(
                        'Back'.toUpperCase(),
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF222222),
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    ElevatedButton(
                      onPressed: () {
                        if (ifscCodeText.text.trim().isEmpty ||
                            micrCodeText.text.trim().isEmpty ||
                            acNoText.text.trim().isEmpty ||
                            branchNameText.text.trim().isEmpty ||
                            acTypeText.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill in all the fields.')),
                          );
                          return; // Do not proceed if fields are empty
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignupNdsPage()),
                        );
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

                  ],
                ),
              ),
              const SizedBox(height: 14),
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
        fontSize: 15,
      ),
    );
  }

  Widget nmAplyStateBoxOption(String option) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Keeps row content compact
      children: [
        Checkbox(
          value: nmAplyselectedOption == option, // Only one can be active
          activeColor: const Color(0xFF0DA99E), // Active checkbox color
          fillColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.selected)) {
              return const Color(0xFF0DA99E); // Background when checked
            }
            return Colors.white; // Background when unchecked
          }),
          side: BorderSide(
            color: nmAplyselectedOption == option
                ? const Color(0xFF0DA99E) // Green border when selected
                : const Color(0xFF0DA99E), // Grey border when not selected
            width: 1, // Border thickness
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4), // Rounded corners
          ),
          onChanged: (bool? value) {
            setState(() {
              if (value == true) {
                nmAplyselectedOption = option; // Only one option stays selected
              }
            });
          },
        ),
        Text(
          option,
          style: GoogleFonts.poppins(
            color: nmAplyselectedOption == option
                ? const Color(0xFF0f625c)
                : const Color(0xFF3F4B4B),
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
        // Space between checkboxes
      ],
    );
  }

  Widget buildInputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: Color(0xFF6E7B7A),
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
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
            width: double.infinity,
            child: TextField(
              controller: controller,
              decoration: _inputDecoration(''),
              style: const TextStyle(
                color: Color(0xFF648683),
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildNumericField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: Color(0xFF6E7B7A),
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
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
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: _inputDecoration(''),
              style: const TextStyle(
                color: Color(0xFF648683),
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Box Decoration
  BoxDecoration boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(50),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 3))
      ],
    );
  }

}
