// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/login.dart';

class SignupPdsPage extends StatefulWidget {
  const SignupPdsPage({super.key});

  @override
  State<SignupPdsPage> createState() => _SignupPdsPageState();
}

class _SignupPdsPageState extends State<SignupPdsPage> {
  final firstNameText = TextEditingController();
  final lastNameText = TextEditingController();
  final TextEditingController holdingNtrText = TextEditingController();
  final TextEditingController occupationText =
      TextEditingController(); // Added for occupation
  final TextEditingController dobController = TextEditingController();
  bool isDropdownOpen = false;
  bool isOcptnDropdownOpen = false;
  OverlayEntry? dropdownOverlay;
  OverlayEntry? occupationOverlay;
  final LayerLink _layerLink = LayerLink();
  final LayerLink _layerOcptnLink = LayerLink(); // Fixed incorrect class
  List<String> dropdownItems = ["Option 1", "Option 2", "Option 3"];
  List<String> occupationItems = [
    "Business",
    "Service",
    "Self Employed",
    "Student"
  ];
  String selectedItem = "Select";
  String selectedOccupation = "Select";

  void toggleDropdown() {
    if (isDropdownOpen) {
      closeDropdown();
    } else {
      openDropdown();
    }
  }

  void toggleOcptnDropdown() {
    if (isOcptnDropdownOpen) {
      closeOcptnDropdown();
    } else {
      openOcptnDropdown();
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

  void openOcptnDropdown() {
    closeDropdown(); // Close the other dropdown if open
    final overlay = Overlay.of(context);

    occupationOverlay = OverlayEntry(
      builder: (context) => Positioned(
        width: 171,
        child: CompositedTransformFollower(
          link: _layerOcptnLink,
          offset: const Offset(0, 45),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: occupationItems.map((item) {
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
                      selectedOccupation = item;
                      occupationText.text = item;
                      closeOcptnDropdown();
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );

    overlay.insert(occupationOverlay!);
    setState(() {
      isOcptnDropdownOpen = true;
    });
  }

  void closeDropdown() {
    dropdownOverlay?.remove();
    dropdownOverlay = null;
    setState(() {
      isDropdownOpen = false;
    });
  }

  void closeOcptnDropdown() {
    occupationOverlay?.remove();
    occupationOverlay = null;
    setState(() {
      isOcptnDropdownOpen = false;
    });
  }

  final panNoText = TextEditingController();
  final passText = TextEditingController();
  final repassText = TextEditingController();
  final othersController = TextEditingController();
  final pdsAddressController = TextEditingController();
  bool isLoading = false;
  final bool _isPanVisible = false; // For showing a loading spinner
  // Function to show the error or success messages
  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1), // Default date
      firstDate: DateTime(1900, 1, 1), // Minimum date
      lastDate: DateTime.now(), // Maximum date (cannot select future dates)
    );

    if (picked != null) {
      setState(() {
        dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  // check button gender purpose start
  List<String> options = ['Male', 'Female'];
  String selectedOption = "Male";
  // check button gender purpose end

  // check button Marital Status purpose start
  List<String> mrtOptions = ['Single', 'Married', 'Others'];
  String mrtSelectedOption = "Single";
  // check button Marital Status purpose end

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
                        SizedBox(
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
                        SizedBox(
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
                          child: SizedBox(
                            width: 171,
                            child: GestureDetector(
                              onTap: toggleDropdown,
                              child: AbsorbPointer(
                                child: TextField(
                                  controller: holdingNtrText,
                                  decoration: InputDecoration(
                                    hintText: 'Select',
                                    hintStyle: GoogleFonts.poppins(
                                      color: Color(0xFF648683),
                                      fontSize: 15,
                                    ),
                                    contentPadding: const EdgeInsets.only(
                                        top: 8, bottom: 8, left: 15, right: 15),
                                    suffixIcon: Icon(
                                      isDropdownOpen
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: Color(0xFF648683),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      borderSide: BorderSide(
                                          color: Color(0xFF648683), width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      borderSide: BorderSide(
                                          color: Color(0xFF0f625c), width: 1),
                                    ),
                                  ),
                                  style: const TextStyle(
                                    color: Color(0xFF3F4B4B),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
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
                        SizedBox(
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            left: 10,
                          ),
                          child: Text(
                            'Occupation',
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
                          link: _layerOcptnLink,
                          child: SizedBox(
                            width: 171,
                            child: GestureDetector(
                              onTap: toggleOcptnDropdown,
                              child: AbsorbPointer(
                                child: TextField(
                                  controller: occupationText,
                                  decoration: InputDecoration(
                                    hintText: 'Select',
                                    hintStyle: GoogleFonts.poppins(
                                      color: Color(0xFF648683),
                                      fontSize: 15,
                                    ),
                                    contentPadding: const EdgeInsets.only(
                                        top: 8, bottom: 8, left: 15, right: 15),
                                    suffixIcon: Icon(
                                      isDropdownOpen
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: Color(0xFF648683),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      borderSide: BorderSide(
                                          color: Color(0xFF648683), width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      borderSide: BorderSide(
                                          color: Color(0xFF0f625c), width: 1),
                                    ),
                                  ),
                                  style: const TextStyle(
                                    color: Color(0xFF3F4B4B),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
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
                            'DOB',
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
                        SizedBox(
                          width: 171,
                          child: TextField(
                            controller: dobController,
                            readOnly: true, // Prevent manual typing
                            decoration: _inputDecoration('').copyWith(
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.calendar_month_outlined,
                                    color: Color(0xFF648683)),
                                onPressed: _selectDate, // Open DatePicker
                              ),
                            ),
                            style: const TextStyle(
                              color: Color(0xFF648683),
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: 10, // Horizontal space between checkboxes
                      runSpacing: 10, // Vertical space if wrapped
                      children: options
                          .map((option) => checkboxOption(option))
                          .toList(),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 10, // Horizontal space between checkboxes
                          runSpacing: 10, // Vertical space if wrapped
                          children: mrtOptions
                              .map((option) => maritalStateBoxOption(option))
                              .toList(),
                        ),

                        // Show TextField only if "Others" is selected
                        if (mrtSelectedOption == "Others") ...[
                          const SizedBox(
                              height: 10), // Spacing before TextField
                          SizedBox(
                            width: double.infinity, // Adjust width as needed
                            child: TextField(
                              controller: othersController,
                              decoration: _inputDecoration('Type here'),
                              style: const TextStyle(
                                color: Color(0xFF648683),
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ]
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
                            'Address',
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
                        SizedBox(
                          width: double.infinity,
                          child: TextField(
                            controller: pdsAddressController,
                            maxLines: 4,
                            decoration: _inputDecoration('').copyWith(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 12), // Padding inside the box
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Colors.white, width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Colors.white, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    10), // Same border radius when focused
                                borderSide: BorderSide(
                                    color: Color(0xFF0f625c), width: 1),
                              ),
                            ),
                            style: const TextStyle(
                              color: Color(0xFF648683),
                              fontSize: 15,
                            ),
                          ),
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
                  String uOcptn = occupationText.text.trim();
                  String uPdsDob = dobController.text.trim();
                  String uPdsOthrContrl = othersController.text.trim();
                  String uPdsAddrsContrl = pdsAddressController.text.trim();
                  String uPanNo = panNoText.text.trim();
                  String urepass = repassText.text.trim();
                  String uPass = passText.text.trim();
                  print(
                      "First Name: $ufName, Password: $uPass,Re-Password: $urepass,Last Name: $ulName,Pan No.: $uPanNo,Holding nature: $uHdNtr,Occupation: $uOcptn,DOB: $uPdsDob,Others Controller: $uPdsOthrContrl,Address Controller: $uPdsAddrsContrl");
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
                  'Save'.toUpperCase(),
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

  Widget checkboxOption(String option) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Keeps row content compact
      children: [
        Checkbox(
          value: selectedOption == option, // Only one can be active
          activeColor: const Color(0xFF0DA99E), // Active checkbox color
          fillColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.selected)) {
              return const Color(0xFF0DA99E); // Background when checked
            }
            return Colors.white; // Background when unchecked
          }),
          side: BorderSide(
            color: selectedOption == option
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
                selectedOption = option; // Only one option stays selected
              }
            });
          },
        ),
        Text(
          option,
          style: GoogleFonts.poppins(
            color: selectedOption == option
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

  Widget maritalStateBoxOption(String option) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Keeps row content compact
      children: [
        Checkbox(
          value: mrtSelectedOption == option, // Only one can be active
          activeColor: const Color(0xFF0DA99E), // Active checkbox color
          fillColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.selected)) {
              return const Color(0xFF0DA99E); // Background when checked
            }
            return Colors.white; // Background when unchecked
          }),
          side: BorderSide(
            color: mrtSelectedOption == option
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
                mrtSelectedOption = option; // Only one option stays selected
              }
            });
          },
        ),
        Text(
          option,
          style: GoogleFonts.poppins(
            color: mrtSelectedOption == option
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
}
