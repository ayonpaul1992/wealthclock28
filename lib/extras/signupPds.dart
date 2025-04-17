// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/login.dart';
import 'signupAds.dart';
import 'signupPdsfirst.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

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

  final TextEditingController _dateController = TextEditingController();
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
    closeDropdown();
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
    closeOcptnDropdown(); // Close the other dropdown if open
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
  final othersController = TextEditingController();
  final pdsAddressController = TextEditingController();
  bool isLoading = false;
  String? firstNameError;
  String? lastNameError;
  String? holdingNtrError;
  String? occupationError;
  String? dobError;
  String? panError;
  String? addressError;
  String? othersError;
  String? checkboxError;
  String? maritalStatusError;

  DateTime? _selectedDate;
  final bool _isPanVisible = false; // For showing a loading spinner
  // Function to show the error or success messages

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

  void _showDatePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 400,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white, // Background color
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(20)), // Rounded top corners
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Shadow color
                blurRadius: 10, // Blur effect
                spreadRadius: 2, // Spread effect
                offset: Offset(0, -2), // Shadow position
              ),
            ],
          ), // Set background color to green
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SfDateRangePicker(
                selectionMode: DateRangePickerSelectionMode.single,
                backgroundColor:
                    Colors.white, // Set DatePicker background color
                selectionColor:
                    Colors.cyan.shade900, // Active date selection color
                todayHighlightColor: Colors
                    .cyan.shade900, // Focused color (today's date highlight)
                startRangeSelectionColor:
                    Colors.white, // Start range selection color
                endRangeSelectionColor:
                    Colors.white, // End range selection color
                rangeSelectionColor: Colors.white, // Range selection overlay
                headerStyle: DateRangePickerHeaderStyle(
                  backgroundColor:
                      Colors.transparent, // Transparent header background
                  textStyle: GoogleFonts.poppins(
                      color: Color(0xFF3F4B4B),
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  setState(() {
                    _selectedDate = args.value; // Store selected date
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close modal
                    },
                    child: Text("Cancel",
                        style: GoogleFonts.poppins(
                            color: Colors.red, fontSize: 16)),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_selectedDate != null) {
                        setState(() {
                          _dateController.text =
                              "${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}";
                        });
                      }
                      Navigator.pop(context); // Close modal
                    },
                    child: Text("OK",
                        style: GoogleFonts.poppins(
                            color: Color(0xFF0DA99E), fontSize: 16)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
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
                              controller: firstNameText,
                              decoration: _inputDecoration(''),
                              style: const TextStyle(
                                color: Color(0xFF648683),
                                fontSize: 14,
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(
                                    25), // Limit to 25 characters
                              ],
                              onChanged: (value) {
                                if (value.isNotEmpty &&
                                    firstNameError != null) {
                                  setState(() {
                                    firstNameError =
                                        null; // clear error on user input
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        if (firstNameError != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0, top: 5),
                            child: Text(
                              firstNameError!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
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
                              controller: lastNameText,
                              decoration: _inputDecoration(''),
                              style: const TextStyle(
                                color: Color(0xFF648683),
                                fontSize: 14,
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(
                                    25), // Limit to 25 characters
                              ],
                              onChanged: (value) {
                                if (value.isNotEmpty && lastNameError != null) {
                                  setState(() {
                                    lastNameError = null;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        if (lastNameError != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 5),
                            child: Text(
                              lastNameError!,
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
                          margin: const EdgeInsets.only(left: 10),
                          child: Text(
                            'Holding Nature',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF6E7B7A),
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Dropdown with shadow & styling
                        CompositedTransformTarget(
                          link: _layerLink,
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
                                controller: holdingNtrText,
                                readOnly: true,
                                onTap: toggleDropdown,
                                decoration: InputDecoration(
                                  hintText: 'Select',
                                  hintStyle: GoogleFonts.poppins(
                                    color: Color(0xFF648683),
                                    fontSize: 14,
                                  ),
                                  contentPadding:
                                  const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                                  suffixIcon: Icon(
                                    isDropdownOpen
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    color: Color(0xFF648683),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: const BorderSide(color: Colors.white, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: const BorderSide(color: Color(0xFF0f625c), width: 1),
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

                        // ✅ Show error below the field — NOT inside Stack
                        if (holdingNtrError != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0, top: 6),
                            child: Text(
                              holdingNtrError!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
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
                              controller: panNoText,
                              decoration: _inputDecoration(''),
                              style: const TextStyle(
                                color: Color(0xFF648683),
                                fontSize: 14,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z0-9]')),
                                LengthLimitingTextInputFormatter(
                                    10), // Limit to 10 characters
                              ],
                              onChanged: (value) {
                                if (value.length == 10 && panError != null) {
                                  setState(() {
                                    panError = null;
                                  });
                                }
                              },
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
                        if (panError != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 5),
                            child: Text(
                              panError!,
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
                          margin: const EdgeInsets.only(left: 10),
                          child: Text(
                            'Occupation',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF6E7B7A),
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Dropdown field
                        CompositedTransformTarget(
                          link: _layerOcptnLink,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 15,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: SizedBox(
                              width: 171,
                              child: TextField(
                                controller: occupationText,
                                readOnly: true,
                                onTap: toggleOcptnDropdown,
                                decoration: InputDecoration(
                                  hintText: 'Select',
                                  hintStyle: GoogleFonts.poppins(
                                    color: Color(0xFF648683),
                                    fontSize: 14,
                                  ),
                                  contentPadding:
                                  const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                                  suffixIcon: Icon(
                                    isOcptnDropdownOpen
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    color: const Color(0xFF648683),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide:
                                    const BorderSide(color: Colors.white, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide:
                                    const BorderSide(color: Color(0xFF0f625c), width: 1),
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

                        // ✅ Error message below field
                        if (occupationError != null)
                          const SizedBox(height: 6),
                        if (occupationError != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text(
                              occupationError!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
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
                        Container(
                          width: 171,
                          decoration: BoxDecoration(
                            color: Colors.white, // Background color
                            borderRadius: BorderRadius.circular(
                                50), // Match border radius
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
                            child: GestureDetector(
                              onTap: () => _showDatePicker(context),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 12.8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                  border: isLoading
                                      ? Border.all(
                                          color: Color(0xFF0f625c),
                                          width: 1) // Show border when focused
                                      : Border.all(
                                          color: Colors.transparent,
                                          width:
                                              1), // Hide border when not focused
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 5)
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _dateController.text.isNotEmpty
                                          ? _dateController.text
                                          : "Select Date",
                                      style: TextStyle(
                                          color: Color(0xFF648683),
                                          fontSize: 14),
                                    ),
                                    Icon(
                                      Icons.calendar_month_outlined,
                                      color: Color(0xFF648683),
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (dobError != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0, top: 5),
                            child: Text(
                              dobError!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: options
                              .map((option) => checkboxOption(option))
                              .toList(),
                        ),
                        if (checkboxError != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0, top: 5),
                            child: Text(
                              checkboxError!,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: mrtOptions
                              .map((option) => maritalStateBoxOption(option))
                              .toList(),
                        ),
                        if (maritalStatusError != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0, top: 5),
                            child: Text(
                              maritalStatusError!,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12),
                            ),
                          ),

                        // Show TextField only if "Others" is selected
                        if (mrtSelectedOption == "Others") ...[
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 15,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: TextField(
                                controller: othersController,
                                decoration: _inputDecoration('Type here'),
                                style: const TextStyle(
                                  color: Color(0xFF648683),
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          if (othersError != null)
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 12.0, top: 5),
                              child: Text(
                                othersError!,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 12),
                              ),
                            ),
                        ]
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            'Address',
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
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 15,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: TextField(
                              controller: pdsAddressController,
                              maxLines: 4,
                              decoration: _inputDecoration('').copyWith(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 12),
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
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Color(0xFF0f625c), width: 1),
                                ),
                              ),
                              style: const TextStyle(
                                color: Color(0xFF648683),
                                fontSize: 14,
                              ),
                              onChanged: (value) {
                                if (value.length == 10 && addressError != null) {
                                  setState(() {
                                    addressError = null;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        if (addressError != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0, top: 5),
                            child: Text(
                              addressError!,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration:
                              Duration(milliseconds: 500), // ✅ Adjust duration
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  SignupPdsFirst(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin =
                                Offset(-1.0, 0.0); // ✅ Start position (right)
                            const end = Offset.zero; // ✅ End position (normal)
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
                      'Back'.toUpperCase(),
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF222222),
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      bool hasError = false;

                      setState(() {
                        // Reset error messages
                        firstNameError = lastNameError = holdingNtrError =
                            occupationError = dobError =
                                panError = addressError = othersError = null;

                        // Validations
                        if (firstNameText.text.trim().isEmpty) {
                          firstNameError = 'First name is required.';
                          hasError = true;
                        }
                        if (lastNameText.text.trim().isEmpty) {
                          lastNameError = 'Last name is required.';
                          hasError = true;
                        }
                        if (holdingNtrText.text.trim().isEmpty) {
                          holdingNtrError = 'Please select an option.';
                          hasError = true;
                        }
                        if (occupationText.text.trim().isEmpty) {
                          occupationError = 'Please select an option.';
                          hasError = true;
                        }
                        if (_dateController.text.trim().isEmpty) {
                          dobError = 'Date of Birth is required.';
                          hasError = true;
                        }
                        if (pdsAddressController.text.trim().isEmpty) {
                          addressError = 'Address is required.';
                          hasError = true;
                        }

                        String pan = panNoText.text.trim().toUpperCase();
                        RegExp panRegExp =
                            RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
                        if (pan.isEmpty) {
                          panError = 'PAN number is required.';
                          hasError = true;
                        } else if (!panRegExp.hasMatch(pan)) {
                          panError = 'Invalid PAN format.';
                          hasError = true;
                        }

                        if (mrtSelectedOption == "Others" &&
                            othersController.text.trim().isEmpty) {
                          othersError = 'Please fill in the "Others" field.';
                          hasError = true;
                        }
                      });

                      if (hasError)
                        return; // 🚫 Stop navigation if any error exists

                      // ✅ Safe to navigate
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 500),
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  SignupAdsPage(),
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
