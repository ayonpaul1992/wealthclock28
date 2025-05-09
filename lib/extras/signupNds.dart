import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../screens/login.dart';
import 'signupAds.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SignupNdsPage extends StatefulWidget {
  const SignupNdsPage({super.key});

  @override
  State<StatefulWidget> createState() => _SignupNdsPageState();
}

class _SignupNdsPageState extends State<SignupNdsPage> {
  final nomineeNameText = TextEditingController();
  final nomineePanText = TextEditingController();
  final TextEditingController relationshipText = TextEditingController();
  final TextEditingController acTypeText = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  TextEditingController nomineeShareText = TextEditingController(text: "100");
  bool isRelationshipDropdownOpen = false;
  OverlayEntry? relationshipOverlay;
  final LayerLink _layerRelationshipLink = LayerLink(); // Fixed incorrect class
  List<String> relationshipItems = ["Relation 1", "Relation 2"];
  String selectedRelationship = "Select";
  void toggleRelationshipDropdown() {
    if (isRelationshipDropdownOpen) {
      closeRelationshipDropdown();
    } else {
      openRelationshipDropdown();
    }
  }
  void openRelationshipDropdown() {
    closeRelationshipDropdown();
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
                      closeRelationshipDropdown();
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
  void closeRelationshipDropdown() {
    relationshipOverlay?.remove();
    relationshipOverlay = null;
    setState(() {
      isRelationshipDropdownOpen = false;
    });
  }
  bool isLoading = false;
  bool isNomineeBox = false;
  String? nomineeError;
  String? nomineePanError;
  String? relationshipError;
  String? nomineedobError;
  String? nomineeShareError;
  String? panError;
  DateTime? _selectedDate;
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
  // check button nominee applicable purpose start
  List<String> nmAplyoptions = ['YES', 'NO'];
  String nmAplyselectedOption = "YES";
  // check button nominee applicable purpose end

  List<bool> showNomineeForms = [false, false];
  int openFormCount = 0; // Track the number of open forms
  List<Map<String, String>> savedNominees = [];
  void toggleNomineeForm() {
    if (openFormCount < 2) {
      setState(() {
        if (showNomineeForms[0] == false) {
          showNomineeForms[0] = true;
          openFormCount++;
        } else if (showNomineeForms[1] == false) {
          showNomineeForms[1] = true;
          openFormCount++;
        }
      });
    }
  }

  void deleteNomineeForm(int index) {
    setState(() {
      showNomineeForms[index] = false;
      openFormCount--;
      if (index == 0) {
        nomineeNameText.clear();
        nomineePanText.clear();
        relationshipText.clear();
        _dateController.clear();
        nomineeShareText.clear();
      } else if (index == 1) {
        nomineeNameText.clear();
        nomineePanText.clear();
        relationshipText.clear();
        _dateController.clear();
        nomineeShareText.clear();
      }
    });
  }

  void saveNominee() {
    if (nomineeNameText.text.isEmpty ||
        nomineePanText.text.isEmpty ||
        relationshipText.text.isEmpty ||
        _dateController.text.isEmpty ||
        nomineeShareText.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all nominee details.")),
      );
      return; // Prevent saving if fields are empty
    }
    if (editingIndex != null) {
      // Editing an existing nominee:

      int newShare = int.tryParse(nomineeShareText.text) ?? 0;
      int oldShare = int.tryParse(savedNominees[editingIndex!]['share'] ?? '0') ?? 0;
      if ((totalShare - oldShare + newShare) > 100) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Total share cannot exceed 100%.")),
        );
        return;
      }

      setState(() {
        savedNominees[editingIndex!] = {
          'name': nomineeNameText.text,
          'pan': nomineePanText.text,
          'relationship': relationshipText.text,
          'dob': _dateController.text,
          'share': nomineeShareText.text,
        };
        totalShare = totalShare - oldShare + newShare;
        editingIndex = null; // Clear editing state
        // Clear form fields after update:
        nomineeNameText.clear();
        nomineePanText.clear();
        relationshipText.clear();
        _dateController.clear();
        nomineeShareText.clear();
      });

    } else {
      // Adding a new nominee:

      if (savedNominees.length >= 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Cannot add more than 3 nominees.")),
        );
        return;
      }

      int newShare = int.tryParse(nomineeShareText.text) ?? 0;
      if (totalShare + newShare > 100) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Total share cannot exceed 100%.")),
        );
        return;
      }

      setState(() {
        savedNominees.add({
          'name': nomineeNameText.text,
          'pan': nomineePanText.text,
          'relationship': relationshipText.text,
          'dob': _dateController.text,
          'share': nomineeShareText.text,
        });

        totalShare += newShare;
        isNomineeBoxList.add(false);

        nomineeNameText.clear();
        nomineePanText.clear();
        relationshipText.clear();
        _dateController.clear();
        nomineeShareText.clear();

        showNomineeForms = [false, false];
        openFormCount = 0;
      });
    }
  }

  // void saveNominee() {
  //   bool hasError = false;
  //   setState(() {
  //     // Reset error messages
  //     nomineeError = nomineePanError = nomineedobError =
  //         nomineeShareError = relationshipError = null;
  //
  //     // Validations
  //     if (nomineeNameText.text.trim().isEmpty) {
  //       nomineeError = 'Nominee name is required.';
  //       hasError = true;
  //     }
  //     if (relationshipText.text.trim().isEmpty) {
  //       relationshipError = 'Please select an option.';
  //       hasError = true;
  //     }
  //     if (_dateController.text.trim().isEmpty) {
  //       nomineedobError = 'Date of Birth is required.';
  //       hasError = true;
  //     }
  //     if (nomineeShareText.text.trim().isEmpty) {
  //       nomineeShareError = 'Nominee share is required.';
  //       hasError = true;
  //     }
  //     // PAN Number Validation
  //     String pan = nomineePanText.text.trim().toUpperCase();
  //     RegExp panRegExp = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
  //     if (pan.isEmpty) {
  //       nomineePanError = 'PAN number is required.';
  //       hasError = true;
  //     } else if (!panRegExp.hasMatch(pan)) {
  //       nomineePanError = 'Invalid PAN format.';
  //       hasError = true;
  //     }
  //
  //     if (!hasError) {
  //       if (editingIndex != null) {
  //         // Editing an existing nominee:
  //
  //         int newShare = int.tryParse(nomineeShareText.text) ?? 0;
  //         int oldShare =
  //             int.tryParse(savedNominees[editingIndex!]['share'] ?? '0') ?? 0;
  //         if ((totalShare - oldShare + newShare) > 100) {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(content: Text("Total share cannot exceed 100%.")),
  //           );
  //           return;
  //         }
  //
  //         setState(() {
  //           savedNominees[editingIndex!] = {
  //             'name': nomineeNameText.text,
  //             'pan': nomineePanText.text,
  //             'relationship': relationshipText.text,
  //             'dob': _dateController.text,
  //             'share': nomineeShareText.text,
  //           };
  //           totalShare = totalShare - oldShare + newShare;
  //           editingIndex = null; // Clear editing state
  //           // Clear form fields after update:
  //           nomineeNameText.clear();
  //           nomineePanText.clear();
  //           relationshipText.clear();
  //           _dateController.clear();
  //           nomineeShareText.clear();
  //         });
  //       } else {
  //         // Adding a new nominee:
  //
  //         if (savedNominees.length >= 3) {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(content: Text("Cannot add more than 3 nominees.")),
  //           );
  //           return;
  //         }
  //
  //         int newShare = int.tryParse(nomineeShareText.text) ?? 0;
  //         if (totalShare + newShare > 100) {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(content: Text("Total share cannot exceed 100%.")),
  //           );
  //           return;
  //         }
  //
  //         setState(() {
  //           savedNominees.add({
  //             'name': nomineeNameText.text,
  //             'pan': nomineePanText.text,
  //             'relationship': relationshipText.text,
  //             'dob': _dateController.text,
  //             'share': nomineeShareText.text,
  //           });
  //
  //           totalShare += newShare;
  //           isNomineeBoxList.add(false);
  //
  //           nomineeNameText.clear();
  //           nomineePanText.clear();
  //           relationshipText.clear();
  //           _dateController.clear();
  //           nomineeShareText.clear();
  //
  //           showNomineeForms = [false, false];
  //           openFormCount = 0;
  //         });
  //       }
  //     }
  //   });
  //   if (hasError) return; // 🚫 Stop if any validation error exists
  // }

  void deleteSavedNominee(int index) {
    setState(() {
      if (index >= 0 && index < savedNominees.length) {
        int removedShare = int.tryParse(savedNominees[index]['share'] ?? '0') ?? 0;
        totalShare -= removedShare;
        savedNominees.removeAt(index);
        isNomineeBoxList.removeAt(index);

        // Check if the deleted nominee was the one being edited:
        if (editingIndex == index) {
          editingIndex = null; // Reset editing index
          // Clear form fields:
          nomineeNameText.clear();
          nomineePanText.clear();
          relationshipText.clear();
          _dateController.clear();
          nomineeShareText.clear();
        }
      }
    });
  }

  List<bool> isNomineeBoxList = [];
  void initState() {
    super.initState();
    isNomineeBoxList = List.generate(savedNominees.length, (index) => false);
  }
  int totalShare = 0;
  int? editingIndex;
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

              Container(
                child: Wrap(
                  spacing: 10, // Space between text fields
                  runSpacing: 15,
                  children: [
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
                              ),
                            ),
                            Text(
                              'Nominee Applicable',
                              style: GoogleFonts.poppins(
                                color: Color(0xFF6E7B7A),
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Wrap(
                              spacing:
                              10, // Horizontal space between checkboxes
                              runSpacing: 10, // Vertical space if wrapped
                              children: nmAplyoptions
                                  .map((option) => nmAplyStateBoxOption(option))
                                  .toList(),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.only(),
                        child: Column(
                          children: [
                            Wrap(
                              runSpacing: 10,
                              children: [
                                for (int i = 0; i < savedNominees.length && i < 3; i++) // Limit to 3 boxes
                                  Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.1),
                                          blurRadius: 5,
                                          spreadRadius: 1,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 8, left: 8, right: 0, bottom: 8),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 8.0, right: 0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        (savedNominees[i]['name'] ?? "").toUpperCase(),
                                                        style: GoogleFonts.poppins(
                                                          color: Color(0xFF0f625c),
                                                          fontSize: 17,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                      SizedBox(height: 8),
                                                      _buildNomineeDetail("SHARE", (savedNominees[i]['share'] ?? "") + "%"),
                                                    ],
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        isNomineeBoxList[i] = !isNomineeBoxList[i];
                                                      });
                                                    },
                                                    icon: Icon(
                                                      isNomineeBoxList[i] ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                                      size: 26,
                                                      color: Color(0xFF0f625c),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          if (isNomineeBoxList[i])
                                            Padding(
                                              padding: EdgeInsets.only(left: 8),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(height: 8),
                                                  _buildNomineeDetail("PAN", savedNominees[i]['pan'] ?? ""),
                                                  SizedBox(height: 8),
                                                  _buildNomineeDetail("Relationship", savedNominees[i]['relationship'] ?? ""),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      _buildNomineeDetail("DOB", savedNominees[i]['dob'] ?? ""),
                                                      Container(
                                                        child: Row(
                                                          children: [
                                                            IconButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  editingIndex = i; // Set the index of the nominee being edited

                                                                  // Populate form fields with the nominee's data:
                                                                  nomineeNameText.text = savedNominees[i]['name'] ?? '';
                                                                  nomineePanText.text = savedNominees[i]['pan'] ?? '';
                                                                  relationshipText.text = savedNominees[i]['relationship'] ?? '';
                                                                  _dateController.text = savedNominees[i]['dob'] ?? '';
                                                                  nomineeShareText.text = savedNominees[i]['share'] ?? '';
                                                                });
                                                              },
                                                              icon: Icon(Icons.edit, color: Color(0xFF09a99d)),
                                                              tooltip: 'Edit Nominee',
                                                            ),
                                                            IconButton(
                                                              onPressed: () {
                                                                deleteSavedNominee(i); // Delete nominee
                                                              },
                                                              icon: Icon(Icons.delete, color: Colors.red),
                                                              tooltip: 'Delete Nominee',
                                                            ),
                                                          ],
                                                        ),
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
                              ],
                            ),
                            // Conditionally show the form
                            if (savedNominees.length < 3 && totalShare < 100 || editingIndex != null)
                              Column(
                                children: [
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 15,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              'Nominee Name',
                                              style: GoogleFonts.poppins(
                                                color: Color(0xFF6E7B7A),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10,),
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
                                                controller: nomineeNameText,
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
                                                  if (value.isNotEmpty && nomineeError != null) {
                                                    setState(() {
                                                      nomineeError = null;
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                          if (nomineeError != null)
                                            Padding(
                                              padding: const EdgeInsets.only(left: 8.0, top: 5),
                                              child: Text(
                                                nomineeError!,
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
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              'Relationship',
                                              style: GoogleFonts.poppins(
                                                color: Color(0xFF6E7B7A),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Stack(
                                            children: [
                                              GestureDetector(
                                                behavior: HitTestBehavior.translucent,
                                                onTap: () {
                                                  if (isRelationshipDropdownOpen) {
                                                    closeRelationshipDropdown();
                                                  }
                                                  FocusManager.instance.primaryFocus?.unfocus();
                                                },
                                                child: Container(width: 171),
                                              ),
                                              CompositedTransformTarget(
                                                link: _layerRelationshipLink,
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
                                                      controller: relationshipText,
                                                      readOnly: editingIndex == null, // Enable editing only when editing
                                                      onTap: editingIndex == null ? toggleRelationshipDropdown : null,
                                                      decoration: InputDecoration(
                                                        hintText: 'Select',
                                                        hintStyle: GoogleFonts.poppins(
                                                          color: Color(0xFF648683),
                                                          fontSize: 14,
                                                        ),
                                                        contentPadding: const EdgeInsets.only(top: 8, bottom: 8, left: 15, right: 15),
                                                        suffixIcon: Icon(
                                                          isRelationshipDropdownOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                                          color: Color(0xFF648683),
                                                        ),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(50),
                                                          borderSide: BorderSide(color: Colors.white, width: 1),
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(50),
                                                          borderSide: BorderSide(color: Color(0xFF0f625c), width: 1),
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
                                          ),
                                          if (relationshipError != null)
                                            const SizedBox(height: 6),
                                          if (relationshipError != null)
                                            Padding(
                                              padding: const EdgeInsets.only(left: 12.0),
                                              child: Text(
                                                relationshipError!,
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
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              'Nominee DOB',
                                              style: GoogleFonts.poppins(
                                                color: Color(0xFF6E7B7A),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                            width: 171,
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
                                              child: GestureDetector(
                                                onTap: editingIndex == null ? () => _showDatePicker(context) : null,
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12.8),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(50),
                                                    border: isLoading
                                                        ? Border.all(color: Color(0xFF0f625c), width: 1)
                                                        : Border.all(color: Colors.transparent, width: 1),
                                                    boxShadow: [
                                                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        _dateController.text.isNotEmpty ? _dateController.text : "Select Date",
                                                        style: TextStyle(color: Color(0xFF648683), fontSize: 14),
                                                      ),
                                                      Icon(Icons.calendar_month_outlined, color: Color(0xFF648683), size: 20),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          if (nomineedobError != null)
                                            Padding(
                                              padding: const EdgeInsets.only(left: 12.0, top: 5),
                                              child: Text(
                                                nomineedobError!,
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
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              'Nominee PAN No.',
                                              style: GoogleFonts.poppins(
                                                color: Color(0xFF6E7B7A),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10,),
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
                                                controller: nomineePanText,
                                                decoration: _inputDecoration(''),
                                                style: const TextStyle(
                                                  color: Color(0xFF648683),
                                                  fontSize: 14,
                                                ),
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                                                  LengthLimitingTextInputFormatter(10),
                                                ],
                                                onChanged: (value) {
                                                  if (value.length == 10 && nomineePanError != null) {
                                                    setState(() {
                                                      nomineePanError = null;
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                          if (nomineePanError != null)
                                            Padding(
                                              padding: const EdgeInsets.only(left: 8.0, top: 5),
                                              child: Text(
                                                nomineePanError!,
                                                style: const TextStyle(
                                                    color: Colors.red, fontSize: 12),
                                              ),
                                            ),
                                        ],
                                      ),
                                      buildNomineeShareField(),
                                      // ... (Other form fields)
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      if (editingIndex != null)
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              editingIndex = null; // Clear editing state
                                              // Clear form fields:
                                              nomineeNameText.clear();
                                              nomineePanText.clear();
                                              relationshipText.clear();
                                              _dateController.clear();
                                              nomineeShareText.clear();
                                            });
                                          },
                                          child: Text('Cancel',style: GoogleFonts.poppins(
                                              color: Colors.red, fontSize: 14)),
                                        ),
                                      if(editingIndex != null) TextButton(
                                        onPressed: saveNominee,
                                        child: Text(editingIndex != null ? 'Update' : 'Save',style: GoogleFonts.poppins(
                                            color: Color(0xFF0DA99E), fontSize: 14)),
                                      ),
                                    ],
                                  )
                                  // ... (Other form related widgets)
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          if (savedNominees.length < 3 && totalShare < 100) // Add this condition
                            Column(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    bool hasError = false;
                                    setState(() {


                                    // Reset error messages
                                    nomineeError = nomineePanError= nomineedobError = nomineeShareError = relationshipError = null;

                                    // Validations
                                    if (nomineeNameText.text.trim().isEmpty) {
                                      nomineeError = 'Nominee name is required.';
                                      hasError = true;
                                    }
                                    if (relationshipText.text.trim().isEmpty) {
                                      relationshipError = 'Please select an option.';
                                      hasError = true;
                                    }
                                    if (_dateController.text.trim().isEmpty) {
                                      nomineedobError = 'Date of Birth is required.';
                                      hasError = true;
                                    }
                                    if (nomineeShareText.text.trim().isEmpty) {
                                      nomineeShareError = 'Nominee share is required.';
                                      hasError = true;
                                    }
                                    // PAN Number Validation
                                    String pan = nomineePanText.text.trim().toUpperCase();
                                    RegExp panRegExp =
                                    RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
                                    if (pan.isEmpty) {
                                      nomineePanError = 'PAN number is required.';
                                      hasError = true;
                                    } else if (!panRegExp.hasMatch(pan)) {
                                      nomineePanError = 'Invalid PAN format.';
                                      hasError = true;
                                    }
                                    saveNominee();
                                    });
                                    if (hasError)
                                      return; // 🚫 Stop navigation if any error exists
                                  },
                                  child: Text(
                                    '+ Add New Nominee',
                                    style: GoogleFonts.poppins(
                                      color: Color(0xFF0F625C),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                for (int i = 0; i < 2; i++)
                                  if (showNomineeForms[i])
                                    Column(
                                      children: [
                                        Wrap(
                                          spacing: 10,
                                          runSpacing: 15,
                                          children: [
                                            buildInputField("Nominee Name", nomineeNameText),
                                            TextButton(
                                              onPressed: () {
                                                deleteNomineeForm(i);
                                              },
                                              child: Text("Delete Nominee Form"),
                                            ),
                                          ],
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
              const SizedBox(height: 14),
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
                              SignupAdsPage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin =
                            Offset(-1.0, 0.0); // ✅ Start position (left)
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
                      String unomineeNameText = nomineeNameText.text.trim();
                      String unomineePan = nomineePanText.text.trim();
                      String unomineeShare = nomineeShareText.text.trim();
                      String uactype = acTypeText.text.trim();
                      String urelationshiptext = relationshipText.text.trim();
                      String uAdsNomDob = _dateController.text.trim();
                      // String urepass = repassText.text.trim();
                      // String uPass = passText.text.trim();
                      print(
                          "Nominee Name: $unomineeNameText,Nominee Pan No.: $unomineePan,Nominee Share: $unomineeShare,Account type: $uactype,Relationship status: $urelationshiptext,Nominee DOB: $uAdsNomDob");
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

  Widget buildDeleteNomineeButton(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            print('Delete Nominee button pressed');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Nominee deleted (example)')),
            );
          },
          child: Text(
            'Delete Nominee',
            style: GoogleFonts.poppins(
              color: Colors.red,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  // Helper function for nominee details
  Widget _buildNomineeDetail(String label, String value) {
    return Row(
      children: [
        Text(
          "$label: ".toUpperCase(),
          style: GoogleFonts.poppins(
            color: Color(0xFF303131),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: Color(0xFF09a99d),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
  Widget buildNomineeShareField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10),
          child: Text(
            'Nominee Share %',
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
              controller: nomineeShareText,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                TextInputFormatter.withFunction((oldValue, newValue) {
                  if (newValue.text.isEmpty) {
                    return newValue;
                  }
                  final value = int.parse(newValue.text);
                  if (value >= 0 && value <= 100) {
                    return newValue;
                  }
                  return oldValue;
                }),
              ],
              decoration: _inputDecoration(''),
              style: const TextStyle(
                color: Color(0xFF648683),
                fontSize: 14,
              ),
              onChanged: (value) {
                setState(() {
                  if (value.isNotEmpty) {
                    int share = int.parse(value);
                    if (share >= 0 && share <= 100) {
                      nomineeShareText.text = value;
                    }
                  }
                });
              },
            ),
          ),
        ),
        if (nomineeShareError != null)
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 5),
            child: Text(
              nomineeShareError!,
              style: const TextStyle(
                  color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

