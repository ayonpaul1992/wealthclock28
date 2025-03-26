// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/login.dart';
import 'signupAds.dart';
import 'package:intl/intl.dart';

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
  final othersController = TextEditingController();
  final pdsAddressController = TextEditingController();
  bool isLoading = false;
  DateTime selectedDate = DateTime(2000, 12, 31);
  final bool _isPanVisible = false; // For showing a loading spinner
  // Function to show the error or success messages
  Future<void> _selectDate() async {
    DateTime? pickedDate = await showMonthYearPicker(context);
    if (pickedDate != null) {
      DateTime lastAllowedDate = DateTime(pickedDate.year, 12, 31); // Allow all months in the year

      DateTime? finalPicked = await showDatePicker(
        context: context,
        initialDate: pickedDate,
        firstDate: DateTime(1900),
        lastDate: lastAllowedDate.isAfter(DateTime.now()) ? DateTime.now() : lastAllowedDate, // Prevent future dates beyond today
      );

      if (finalPicked != null) {
        setState(() {
          selectedDate = finalPicked;
          dobController.text = DateFormat("dd/MM/yyyy").format(finalPicked);
        });
      }
    }
  }

  Future<DateTime?> showMonthYearPicker(BuildContext context) async {
    DateTime tempSelected = selectedDate;
    return await showModalBottomSheet<DateTime>(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          height: 350,
          child: Column(
            children: [
              Text(
                "Select Month & Year",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Divider(),
              // Expanded(
              //   child: ListWheelScrollView.useDelegate(
              //     itemExtent: 50,
              //     physics: FixedExtentScrollPhysics(),
              //     childDelegate: ListWheelChildBuilderDelegate(
              //       builder: (context, index) {
              //         final year = 1900 + index;
              //         return GestureDetector(
              //           onTap: () => setState(() => tempSelected = DateTime(year, tempSelected.month, 1)),
              //           child: Text(
              //             "$year",
              //             style: TextStyle(fontSize: 16, color: year == tempSelected.year ? Colors.blue : Colors.black),
              //           ),
              //         );
              //       },
              //       childCount: DateTime.now().year - 1900 + 1,
              //     ),
              //   ),
              // ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 2,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context, DateTime(tempSelected.year, index + 1, 1));
                      },
                      child: Card(
                        color: (index + 1) == tempSelected.month ? Colors.blue.shade100 : Colors.white,
                        child: Center(
                          child: Text(
                            DateFormat.MMMM().format(DateTime(2000, index + 1, 1)),
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
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
                        Container(
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
                              controller: firstNameText,
                              decoration: _inputDecoration(''),
                              style: const TextStyle(
                                color: Color(0xFF648683),
                                fontSize: 15,
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
                              controller: lastNameText,
                              decoration: _inputDecoration(''),
                              style: const TextStyle(
                                color: Color(0xFF648683),
                                fontSize: 15,
                              ),
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
                            decoration: BoxDecoration(
                              color: Colors.white, // Background color
                              borderRadius: BorderRadius.circular(50), // Match border radius
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
                                      contentPadding:
                                      const EdgeInsets.only(top: 8, bottom: 8, left: 15, right: 15),
                                      suffixIcon: Icon(
                                        isDropdownOpen
                                            ? Icons.keyboard_arrow_up
                                            : Icons.keyboard_arrow_down,
                                        color: Color(0xFF648683),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: BorderSide(color: Color(0xFF0f625c), width: 1),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: BorderSide(color: Color(0xFF0f625c), width: 1),
                                      ),
                                    ),
                                    style: const TextStyle(
                                      color: Color(0xFF648683),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
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
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white, // Background color
                              borderRadius: BorderRadius.circular(50), // Match border radius
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
                                        isOcptnDropdownOpen
                                            ? Icons.keyboard_arrow_up
                                            : Icons.keyboard_arrow_down,
                                        color: Color(0xFF648683),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: BorderSide(
                                            color: Color(0xFF0f625c), width: 1),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: BorderSide(
                                            color: Color(0xFF0f625c), width: 1),
                                      ),
                                    ),
                                    style: const TextStyle(
                                      color: Color(0xFF648683),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
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
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white, // Background color
                            borderRadius: BorderRadius.circular(50), // Match border radius
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
                              child: GestureDetector(
                                onTap: _selectDate,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 11),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(color: Color(0xFF0f625c), width: 1),
                                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        dobController.text.isNotEmpty ? dobController.text : "Select Date",
                                        style: TextStyle(color: Color(0xFF648683), fontSize: 15),
                                      ),
                                      Icon(Icons.calendar_month_outlined, color: Color(0xFF648683)),
                                    ],
                                  ),
                                ),
                              ),
                            )

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
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white, // Background color
                              borderRadius: BorderRadius.circular(50), // Match border radius
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
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white, // Background color
                            borderRadius: BorderRadius.circular(50), // Match border radius
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
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 500), // ✅ Adjust duration
                      pageBuilder: (context, animation, secondaryAnimation) => SignupAdsPage(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0); // ✅ Start position (right)
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

                  // Capture user input and print
                  String ufName = firstNameText.text.trim();
                  String ulName = lastNameText.text.trim();
                  String uHdNtr = holdingNtrText.text.trim();
                  String uOcptn = occupationText.text.trim();
                  String uPdsDob = dobController.text.trim();
                  String uPdsOthrContrl = othersController.text.trim();
                  String uPdsAddrsContrl = pdsAddressController.text.trim();
                  String uPanNo = panNoText.text.trim();

                  print("First Name: $ufName, Last Name: $ulName, Pan No.: $uPanNo, Holding nature: $uHdNtr, Occupation: $uOcptn, DOB: $uPdsDob, Others Controller: $uPdsOthrContrl, Address Controller: $uPdsAddrsContrl");
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
