import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/login.dart';
import 'signupPds.dart';

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
  final nomineeNameText = TextEditingController();
  final nomineePanText = TextEditingController();
  final TextEditingController acTypeText = TextEditingController();
  final TextEditingController relationshipText = TextEditingController();
  final TextEditingController nomineeDobController = TextEditingController();
  TextEditingController nomineeShareText = TextEditingController(text: "100");
  bool isAcTypeDropdownOpen = false;
  bool isRelationshipDropdownOpen = false;
  OverlayEntry? actypeOverlay;
  OverlayEntry? relationshipOverlay;

   // Fixed incorrect class
  final LayerLink _layerAcTypeLink = LayerLink(); // Fixed incorrect class
  final LayerLink _layerRelationshipLink = LayerLink(); // Fixed incorrect class

  List<String> acTypeItems = ["Savings", "Current"];
  List<String> relationshipItems = ["Relation 1", "Relation 2"];


  String selectedAcType = "Select";
  String selectedRelationship = "Select";



  void toggleAcTypeDropdown() {
    if (isAcTypeDropdownOpen) {
      closeAcTypeDropdown();
    } else {
      openAcTypeDropdown();
    }
  }
  void toggleRelationshipDropdown() {
    if (isRelationshipDropdownOpen) {
      closeRelationshipDropdown();
    } else {
      openRelationshipDropdown();
    }
  }

  void openAcTypeDropdown() {
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
  void openRelationshipDropdown() {
    final overlay = Overlay.of(context);
    relationshipOverlay = OverlayEntry(
      builder: (context) => Positioned(
        width: 171, // Same width as text field
        child: CompositedTransformFollower(
          link: _layerRelationshipLink,
          offset: Offset(0, 45), // Adjust dropdown position
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: relationshipItems.map((item) {
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
                      selectedRelationship = item;
                      relationshipText.text = item;
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

    overlay.insert(relationshipOverlay!);
    setState(() {
      isRelationshipDropdownOpen = true;
    });
  }

  void closeAcTypeDropdown() {
    actypeOverlay?.remove();
    actypeOverlay = null;
    setState(() {
      isAcTypeDropdownOpen = false;
    });
  }
  void closeRelationshipDropdown() {
    relationshipOverlay?.remove();
    relationshipOverlay = null;
    setState(() {
      isRelationshipDropdownOpen = false;
    });
  }

  final panNoText = TextEditingController();
  final bankNameText = TextEditingController();
  // final passText = TextEditingController();
  // final repassText = TextEditingController();
  final othersController = TextEditingController();
  final pdsAddressController = TextEditingController();
  bool isLoading = false;
  final bool _isPanVisible = false; // For showing a loading spinner

  Future<void> _nomineeselectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1), // Default date
      firstDate: DateTime(1900, 1, 1), // Minimum date
      lastDate: DateTime.now(), // Maximum date (cannot select future dates)
    );

    if (picked != null) {
      setState(() {
        nomineeDobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

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
                              controller: acNoText,
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
                              controller: ifscCodeText,
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
                              controller: micrCodeText,
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
                              controller: bankNameText,
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
                        CompositedTransformTarget(
                          link: _layerAcTypeLink,
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
                                onTap: toggleAcTypeDropdown,
                                child: AbsorbPointer(
                                  child: TextField(
                                    controller: acTypeText,
                                    decoration: InputDecoration(
                                      hintText: 'Select',
                                      hintStyle: GoogleFonts.poppins(
                                        color: Color(0xFF648683),
                                        fontSize: 15,
                                      ),
                                      contentPadding:
                                      const EdgeInsets.only(top: 8, bottom: 8, left: 15, right: 15),
                                      suffixIcon: Icon(
                                        isAcTypeDropdownOpen
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
                              controller: branchNameText,
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
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
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
                                'Nominee Details',
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
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                left: 10,
                              ),),
                            Text(
                              'Nominee Applicable',
                              style: GoogleFonts.poppins(
                                color: Color(0xFF6E7B7A),
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Wrap(
                              spacing: 10, // Horizontal space between checkboxes
                              runSpacing: 10, // Vertical space if wrapped
                              children: nmAplyoptions
                                  .map((option) => nmAplyStateBoxOption(option))
                                  .toList(),
                            ),
                          ],
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
                            'Nominee Name',
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
                            width: double.infinity,
                            child: TextField(
                              controller: nomineeNameText,
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
                            'Relationship',
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
                          link: _layerRelationshipLink,
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
                                onTap: toggleRelationshipDropdown,
                                child: AbsorbPointer(
                                  child: TextField(
                                    controller: relationshipText,
                                    decoration: InputDecoration(
                                      hintText: 'Select',
                                      hintStyle: GoogleFonts.poppins(
                                        color: Color(0xFF648683),
                                        fontSize: 15,
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                          top: 8, bottom: 8, left: 15, right: 15),
                                      suffixIcon: Icon(
                                        isRelationshipDropdownOpen
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
                            'Nominee DOB',
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
                                onTap: _nomineeselectDate, // Opens the calendar when tapped anywhere
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 11), // Adjust padding
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Background color
                                    borderRadius: BorderRadius.circular(50), // Rounded corners
                                    border: Border.all(
                                      color: nomineeDobController.text.isEmpty ? Color(0xFFfff) : Color(0xFF0f625c), // Focused or enabled border
                                      width: 1,
                                    ), // Custom border
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1), // Shadow effect
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          nomineeDobController.text.isNotEmpty ? nomineeDobController.text : "Select Date",
                                          style: const TextStyle(
                                            color: Color(0xFF648683),
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.calendar_month_outlined,
                                        color: Color(0xFF648683),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )



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
                            'Nominee PAN No.',
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
                            width: double.infinity,
                            child: TextField(
                              controller: nomineePanText,
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
                            'Nominee Share %',
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
                              controller: nomineeShareText,
                              keyboardType: TextInputType.number, // ✅ Allows only numbers
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                      children: [
                        SizedBox(height: 30,),
                        Container(
                          width: 171,
                          child: TextButton(onPressed: () {
                              Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignupAdsPage()), // ✅ Corrected builder
                              );}, child: Text('+ Add New Nominee',style: GoogleFonts.poppins(
                            color: Color(0xFF0F625C),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 500), // ✅ Adjust duration
                      pageBuilder: (context, animation, secondaryAnimation) => SignupPdsPage(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        const begin = Offset(-1.0, 0.0); // ✅ Start position (left)
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFfdd1a0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 35),
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
                  String uifscCode = ifscCodeText.text.trim();
                  String umicrCode = micrCodeText.text.trim();
                  String uacNoText = acNoText.text.trim();
                  String ubranchNameText = branchNameText.text.trim();
                  String unomineeNameText = nomineeNameText.text.trim();
                  String unomineePan = nomineePanText.text.trim();
                  String unomineeShare = nomineeShareText.text.trim();
                  String ubankName = bankNameText.text.trim();

                  String uactype = acTypeText.text.trim();

                  String uAdsNomDob = nomineeDobController.text.trim();


                  // String urepass = repassText.text.trim();
                  // String uPass = passText.text.trim();
                  print(
                      "Ifsc code: $uifscCode,Micr code: $umicrCode,Account No.: $uacNoText,Branch Name: $ubranchNameText,Nominee Name: $unomineeNameText,Nominee Pan No.: $unomineePan,Nominee Share: $unomineeShare,Bank Name: $ubankName,Account type: $uactype,Nominee DOB: $uAdsNomDob");
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
          fillColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.selected)) {
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
}
