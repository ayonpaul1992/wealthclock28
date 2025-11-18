// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wealthclock28/components/custom_app_bar.dart';
import 'package:wealthclock28/components/custom_drawer.dart';
import 'package:wealthclock28/components/custom_bottom_nav_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wealthclock28/screens/login.dart';

// ignore: camel_case_types
class ProfileAfterLogin extends StatefulWidget {
  const ProfileAfterLogin(
      {super.key, required String prflId, required String userId});

  @override
  State<ProfileAfterLogin> createState() => ProfileAfterLoginState();
}

// ignore: camel_case_types
class ProfileAfterLoginState extends State<ProfileAfterLogin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<bool> _isExpanded = [false, false, false, false, false];

  final List<String> titles = [
    "Personal Details",
    "Address Details",
    "Nominee Details",
    "Joint Holder Details",
    "Bank Details",
  ];

  String clientCode = '';
  String investorName = '';
  String investorPan = '';
  String mobileNumber = '';
  String emailId = '';
  String gender = '';
  String dob = '';
  String maritalStatus = '';

  String investorAddress = '';
  String state = '';
  String city = '';
  String pinCode = '';

  String nomineeName = '';
  String relationshipWithNominee = '';
  String modeOfHolding = '';
  String jointHolderName = '';
  String jointHolderPan = '';

  String bankName = '';
  String accountNumber = '';
  String micrNumber = '';
  String bankType = '';
  String ifscCode = '';
  String branchAddress = '';

  String rmName = '';
  String rmPhone = '';

  bool isObscure = true; // 👈 ADD THIS ABOVE IN YOUR STATE

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');
    const String apiUrl = 'https://wealthclockadvisors.com/api/client/details';

    if (authToken == null || authToken.isEmpty) {
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body.trim());
        if (data is Map<String, dynamic>) {
          final responseData = data["data"];

          setState(() {
            clientCode = responseData["client_code"] ?? '';
            investorName =
                '${responseData["primary_holder_first_name"] ?? ''} ${responseData['primary_holder_middle_name'] ?? ''} ${responseData['primary_holder_last_name'] ?? ''}';

            investorPan = responseData["primary_holder_pan"] ?? '';
            mobileNumber = responseData["indian_mobile_no"] ?? '';
            emailId = responseData["email"] ?? '';
            gender = responseData["gender"] ?? '';
            dob = responseData["primary_holder_dobincorporation"] ?? '';
            maritalStatus = responseData["marital_status"] ?? '';
            investorAddress = responseData["address_1"] ?? '';
            state = responseData["state"] ?? '';
            city = responseData["city"] ?? '';
            pinCode = responseData["pincode"] ?? '';
            nomineeName = responseData["nominee_1_name"] ?? '';
            relationshipWithNominee =
                responseData["nominee_1_relationship"] ?? '';
            modeOfHolding = responseData["holding_nature"] ?? '';
            jointHolderName =
                '${responseData["second_holder_first_name"] ?? ''} ${responseData['second_holder_middle_name'] ?? ''} ${responseData['second_holder_last_name'] ?? ''}';

            jointHolderPan = responseData["second_holder_pan"] ?? '';

            bankName = responseData["bank_name_1"] ?? '';
            accountNumber = responseData["account_no_1"] ?? '';
            micrNumber = responseData["micr_no_1"] ?? '';
            bankType = responseData["account_type_1"] ?? '';
            ifscCode = responseData["ifsc_code_1"] ?? '';
            branchAddress = responseData["bank_branch_1"] ?? '';

            final rmData = data["rm"];

            rmName = rmData["fullname"] ?? '';
            rmPhone = rmData["mobileno"] ?? '';
          });
        }
      }
    } catch (e) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Session expired. Please login again.'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
          (route) => false,
        );
      }
      // setState(() {
      //   userName = "Error fetching data!";
      // });
    }
  }

  /// ✅ Separate widget function to return content for each ExpansionTile
  Widget _buildDetailRow(String label, String value, {Widget? trailingIcon}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  color: const Color(0xFF6E7B7A),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF003430),
                ),
              ),
            ],
          ),
        ),
        if (trailingIcon != null) trailingIcon!,
      ],
    );
  }

  Widget buildTileContent(int index, bool isOpen) {
    final borderColor = isOpen ? const Color(0xFF0DA99E) : Colors.transparent;

    switch (index) {
      case 0: // Personal Details
        return Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: borderColor, width: 1.1)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(
                "Unique Client Code",
                clientCode,
                trailingIcon: IconButton(
                  icon: const Icon(
                    Icons.copy,
                    color: Color(0xFF09A99D),
                    size: 18,
                  ),
                  onPressed: () {
                    // Copy logic here
                    Clipboard.setData(ClipboardData(text: clientCode))
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Client code copied to clipboard')),
                      );
                    });
                  },
                ),
              ),
              Divider(
                color: Color(0xFFB2C1C0),
              ),
              _buildDetailRow(
                "Investor Name",
                investorName,
                trailingIcon: IconButton(
                  icon: const Icon(
                    Icons.copy,
                    color: Color(0xFF09A99D),
                    size: 18,
                  ),
                  onPressed: () {
                    // Copy logic here

                    Clipboard.setData(ClipboardData(text: investorName))
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Investor Name copied to clipboard')),
                      );
                    });
                  },
                ),
              ),
              Divider(
                color: Color(0xFFB2C1C0),
              ),
              _buildDetailRow(
                "Investor Pan",
                investorPan,
                trailingIcon: IconButton(
                  icon: const Icon(
                    Icons.copy,
                    color: Color(0xFF09A99D),
                    size: 18,
                  ),
                  onPressed: () {
                    // Copy logic here
                    Clipboard.setData(ClipboardData(text: investorPan))
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Investor Pan copied to clipboard')),
                      );
                    });
                  },
                ),
              ),
              Divider(
                color: Color(0xFFB2C1C0),
              ),
              _buildDetailRow(
                "Mobile No.",
                mobileNumber,
                trailingIcon: IconButton(
                  icon: const Icon(
                    Icons.copy,
                    color: Color(0xFF09A99D),
                    size: 18,
                  ),
                  onPressed: () {
                    // Copy logic here
                    Clipboard.setData(ClipboardData(text: mobileNumber))
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Mobile No. copied to clipboard')),
                      );
                    });
                  },
                ),
              ),
              Divider(
                color: Color(0xFFB2C1C0),
              ),
              _buildDetailRow(
                "Email ID",
                emailId,
                trailingIcon: IconButton(
                  icon: const Icon(
                    Icons.copy,
                    color: Color(0xFF09A99D),
                    size: 18,
                  ),
                  onPressed: () {
                    // Copy logic here
                    Clipboard.setData(ClipboardData(text: emailId)).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Email ID copied to clipboard')),
                      );
                    });
                  },
                ),
              ),
              Divider(
                color: Color(0xFFB2C1C0),
              ),
              _buildDetailRow(
                "Gender",
                gender,
                trailingIcon: IconButton(
                  icon: const Icon(
                    Icons.copy,
                    color: Color(0xFF09A99D),
                    size: 18,
                  ),
                  onPressed: () {
                    // Copy logic here
                    Clipboard.setData(ClipboardData(text: gender)).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Gender copied to clipboard')),
                      );
                    });
                  },
                ),
              ),
              Divider(
                color: Color(0xFFB2C1C0),
              ),
              _buildDetailRow(
                "DOB (DD/MM/YYYY)",
                dob,
                trailingIcon: IconButton(
                  icon: const Icon(
                    Icons.copy,
                    color: Color(0xFF09A99D),
                    size: 18,
                  ),
                  onPressed: () {
                    // Copy logic here
                    Clipboard.setData(ClipboardData(text: dob)).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('DOB copied to clipboard')),
                      );
                    });
                  },
                ),
              ),
              Divider(
                color: Color(0xFFB2C1C0),
              ),
              _buildDetailRow(
                "Marital Status",
                maritalStatus,
                trailingIcon: IconButton(
                  icon: const Icon(
                    Icons.copy,
                    color: Color(0xFF09A99D),
                    size: 18,
                  ),
                  onPressed: () {
                    // Copy logic here
                    Clipboard.setData(ClipboardData(text: maritalStatus))
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Marital Status copied to clipboard'),
                        ),
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        );

      case 1: // Address Details
        return Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: borderColor, width: 1.1)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(
                "Investor Address",
                investorAddress,
                trailingIcon: IconButton(
                  icon: const Icon(
                    Icons.copy,
                    color: Color(0xFF09A99D),
                    size: 18,
                  ),
                  onPressed: () {
                    // Copy logic here
                    Clipboard.setData(ClipboardData(text: investorAddress))
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Inverstor address copied to clipboard'),
                        ),
                      );
                    });
                  },
                ),
              ),
              Divider(
                color: Color(0xFFB2C1C0),
              ),
              _buildDetailRow(
                "State",
                state,
                trailingIcon: IconButton(
                  icon: const Icon(
                    Icons.copy,
                    color: Color(0xFF09A99D),
                    size: 18,
                  ),
                  onPressed: () {
                    // Copy logic here
                    Clipboard.setData(ClipboardData(text: state)).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('State copied to clipboard'),
                        ),
                      );
                    });
                  },
                ),
              ),
              Divider(
                color: Color(0xFFB2C1C0),
              ),
              _buildDetailRow(
                "City",
                city,
                trailingIcon: IconButton(
                  icon: const Icon(
                    Icons.copy,
                    color: Color(0xFF09A99D),
                    size: 18,
                  ),
                  onPressed: () {
                    // Copy logic here
                    Clipboard.setData(ClipboardData(text: city)).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('City copied to clipboard')),
                      );
                    });
                  },
                ),
              ),
              Divider(
                color: Color(0xFFB2C1C0),
              ),
              _buildDetailRow("Pin Code", pinCode,
                  trailingIcon: IconButton(
                    icon: const Icon(
                      Icons.copy,
                      color: Color(0xFF09A99D),
                      size: 18,
                    ),
                    onPressed: () {
                      // Copy logic here
                      Clipboard.setData(ClipboardData(text: pinCode)).then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Pin Code copied to clipboard')),
                        );
                      });
                    },
                  )),
            ],
          ),
        );

      case 2: // Nominee Details
        return Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: borderColor, width: 1.1)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow("Nominee Name", nomineeName,
                  trailingIcon: IconButton(
                    icon: const Icon(
                      Icons.copy,
                      color: Color(0xFF09A99D),
                      size: 18,
                    ),
                    onPressed: () {
                      // Copy logic here
                      Clipboard.setData(ClipboardData(text: nomineeName))
                          .then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Nominee Name copied to clipboard')),
                        );
                      });
                    },
                  )),
              Divider(
                color: Color(0xFFB2C1C0),
              ),
              _buildDetailRow(
                  "Relationship with Nominee", relationshipWithNominee,
                  trailingIcon: IconButton(
                    icon: const Icon(
                      Icons.copy,
                      color: Color(0xFF09A99D),
                      size: 18,
                    ),
                    onPressed: () {
                      // Copy logic here
                      Clipboard.setData(
                              ClipboardData(text: relationshipWithNominee))
                          .then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Relationship with Nominee copied to clipboard')),
                        );
                      });
                    },
                  )),
            ],
          ),
        );

      case 3: // Joint Holder Details
        return Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: borderColor, width: 1.1)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(
                "Mode of Holding",
                modeOfHolding,
                trailingIcon: IconButton(
                  icon: const Icon(
                    Icons.copy,
                    color: Color(0xFF09A99D),
                    size: 18,
                  ),
                  onPressed: () {
                    // Copy logic here
                    Clipboard.setData(ClipboardData(text: modeOfHolding))
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Mode of Holding copied to clipboard')),
                      );
                    });
                  },
                ),
              ),
              Divider(
                color: Color(0xFFB2C1C0),
              ),
              _buildDetailRow(
                "Joint Holder Name",
                jointHolderName,
                trailingIcon: IconButton(
                  icon: const Icon(
                    Icons.copy,
                    color: Color(0xFF09A99D),
                    size: 18,
                  ),
                  onPressed: () {
                    // Copy logic here
                    Clipboard.setData(ClipboardData(text: jointHolderName))
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Joint Holder Name copied to clipboard')),
                      );
                    });
                  },
                ),
              ),
              Divider(
                color: Color(0xFFB2C1C0),
              ),
              _buildDetailRow(
                "Joint Holder Pan",
                jointHolderPan,
                trailingIcon: IconButton(
                  icon: const Icon(
                    Icons.copy,
                    color: Color(0xFF09A99D),
                    size: 18,
                  ),
                  onPressed: () {
                    // Copy logic here
                    Clipboard.setData(ClipboardData(text: jointHolderPan))
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Joint Holder Pan copied to clipboard')),
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        );

      case 4: // Bank Details
        return Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: borderColor, width: 1.1)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow("Bank Name", bankName,
                  trailingIcon: IconButton(
                    icon: const Icon(
                      Icons.copy,
                      color: Color(0xFF09A99D),
                      size: 18,
                    ),
                    onPressed: () {
                      // Copy logic here
                      Clipboard.setData(ClipboardData(text: bankName))
                          .then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Bank Name copied to clipboard')),
                        );
                      });
                    },
                  )),
              Divider(
                color: Color(0xFFB2C1C0),
              ),
              _buildDetailRow("Account No.", accountNumber,
                  trailingIcon: IconButton(
                    icon: const Icon(
                      Icons.copy,
                      color: Color(0xFF09A99D),
                      size: 18,
                    ),
                    onPressed: () {
                      // Copy logic here
                      Clipboard.setData(ClipboardData(text: accountNumber))
                          .then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Account No. copied to clipboard')),
                        );
                      });
                    },
                  )),
              Divider(
                color: Color(0xFFB2C1C0),
              ),
              _buildDetailRow("MICR No.", micrNumber,
                  trailingIcon: IconButton(
                    icon: const Icon(
                      Icons.copy,
                      color: Color(0xFF09A99D),
                      size: 18,
                    ),
                    onPressed: () {
                      // Copy logic here
                      Clipboard.setData(ClipboardData(text: micrNumber))
                          .then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('MICR No. copied to clipboard')),
                        );
                      });
                    },
                  )),
              Divider(
                color: Color(0xFFB2C1C0),
              ),
              _buildDetailRow("Bank Type", bankType,
                  trailingIcon: IconButton(
                    icon: const Icon(
                      Icons.copy,
                      color: Color(0xFF09A99D),
                      size: 18,
                    ),
                    onPressed: () {
                      // Copy logic here
                      Clipboard.setData(ClipboardData(text: bankType))
                          .then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Bank Type copied to clipboard')),
                        );
                      });
                    },
                  )),
              Divider(
                color: Color(0xFFB2C1C0),
              ),
              _buildDetailRow("IFSC Code", ifscCode,
                  trailingIcon: IconButton(
                    icon: const Icon(
                      Icons.copy,
                      color: Color(0xFF09A99D),
                      size: 18,
                    ),
                    onPressed: () {
                      // Copy logic here
                      Clipboard.setData(ClipboardData(text: ifscCode))
                          .then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('IFSC Code copied to clipboard')),
                        );
                      });
                    },
                  )),
              Divider(
                color: Color(0xFFB2C1C0),
              ),
              _buildDetailRow(
                "Branch Address",
                branchAddress,
                trailingIcon: IconButton(
                  icon: const Icon(
                    Icons.copy,
                    color: Color(0xFF09A99D),
                    size: 18,
                  ),
                  onPressed: () {
                    // Copy logic here
                    Clipboard.setData(ClipboardData(text: branchAddress))
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Branch Address copied to clipboard'),
                        ),
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        scaffoldKey: _scaffoldKey,
        prflId: '',
        showLeading: true,
        userId: '',
        rqsrvcId: '',
      ),
      drawer: CustomDrawer(
        activeTile: 'Profile Details',
        onTileTap: (selectedTile) {},
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFfffaf5), Color(0xFFe7f6f5)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 18),
                      color: const Color(0xFF0DA99E),
                      width: double.infinity,
                      child: Text(
                        'Profile Details',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // ✅ ExpansionTiles section
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              left: 18, right: 18, top: 18),
                          child: Column(
                            children: List.generate(titles.length, (index) {
                              final bool isOpen = _isExpanded[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isOpen
                                        ? const Color(0xFF0DA99E)
                                        : Colors.transparent,
                                    width: 1.1,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                    key: Key(
                                        'tile_$index-${_isExpanded[index]}'),
                                    initiallyExpanded: isOpen,
                                    tilePadding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    title: Text(
                                      titles[index],
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF3F4B4B),
                                      ),
                                    ),
                                    trailing: Icon(
                                      isOpen
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: const Color(0xFF2A4768),
                                    ),
                                    onExpansionChanged: (expanded) {
                                      setState(() {
                                        for (int i = 0;
                                            i < _isExpanded.length;
                                            i++) {
                                          _isExpanded[i] = false;
                                        }
                                        _isExpanded[index] = expanded;
                                      });
                                    },
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                              color: Color(0xFF0DA99E),
                                              width: 0.8,
                                            ),
                                          ),
                                        ),
                                        child: buildTileContent(index, isOpen),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),

                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 17),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                20, 10, 20, 10),
                                        title: Text(
                                          "Delete Account?",
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        content: Form(
                                          // ✅ REQUIRED FOR VALIDATION
                                          key: formKey,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Enter your password to confirm deletion.",
                                                style: GoogleFonts.poppins(
                                                    fontSize: 13),
                                              ),

                                              const SizedBox(height: 10),

                                              // PASSWORD FIELD
                                              TextFormField(
                                                controller: passwordController,
                                                obscureText: isObscure,

                                                // 🔥 Re-validate on user typing
                                                onChanged: (value) {
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    setState(
                                                        () {}); // rebuild to remove error immediately
                                                  }
                                                },

                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Please enter your password";
                                                  }
                                                  return null;
                                                },

                                                decoration: InputDecoration(
                                                  hintText: "Enter Password",
                                                  hintStyle:
                                                      GoogleFonts.poppins(
                                                          fontSize: 13),
                                                  border: InputBorder.none,
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.black,
                                                            width: 1),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.black,
                                                            width: 1),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.red,
                                                            width: 1),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.red,
                                                            width: 1),
                                                  ),
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      isObscure
                                                          ? Icons.visibility_off
                                                          : Icons.visibility,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        isObscure = !isObscure;
                                                      });
                                                    },
                                                  ),
                                                  errorStyle: const TextStyle(
                                                      fontSize: 12,
                                                      height: 1.2),
                                                ),
                                              ),

                                              const SizedBox(height: 5),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => {
                                              passwordController.clear(),
                                              Navigator.pop(context),
                                            },
                                            child: Text(
                                              "Cancel",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.grey[700]),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              if (!formKey.currentState!
                                                  .validate()) {
                                                return; // ⬅️ shows the error
                                              }

                                              Navigator.pop(context);

                                              print(
                                                  "Deleting account with password: ${passwordController.text}");

                                              deleteAccount(
                                                  passwordController.text);

                                              // TODO: Delete logic
                                              // deleteAccount(passwordController.text);
                                            },
                                            child: Text(
                                              "Delete",
                                              style: GoogleFonts.poppins(
                                                color: Colors.red,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Delete Account",
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFF3F4B4B),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.delete_forever,
                                    size: 17,
                                    color: Color(0xFF6B7280),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                            height: 20), // spacing before CRM section

                        // ✅ Fixed bottom CRM section
                        SingleChildScrollView(
                          padding: EdgeInsets.only(
                              bottom: 188), // Reserve space for bottom section
                          child: Column(
                            children: [
                              // ... All your ExpansionTiles go here ...
                            ],
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 0),
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.topCenter,
                              children: [
                                // Background semicircle
                                Container(
                                  width: double.infinity,
                                  height: 188,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFE2E9DD),
                                        Color(0xFFB8E3DC)
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(400),
                                    ),
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.white,
                                        width: 3,
                                      ),
                                    ),
                                  ),
                                ),

                                // Foreground content (profile and text)
                                Positioned(
                                  top: -40,
                                  bottom: 0,
                                  child: Column(
                                    children: [
                                      // Profile Image
                                      Container(
                                        width: 75,
                                        height: 75,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Color(0xFF0DA99E),
                                              width: 3),
                                          image: const DecorationImage(
                                            image: AssetImage(
                                                'assets/images/dash_user.png'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),

                                      // Name
                                      Text(
                                        rmName,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF292929),
                                        ),
                                      ),
                                      const SizedBox(height: 4),

                                      // Role
                                      Text(
                                        "Customer Relationship Manager",
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          color: Color(0xFF6E7B7A),
                                        ),
                                      ),
                                      const SizedBox(height: 14),

                                      // Contact
                                      GestureDetector(
                                        onTap: () async {
                                          final Uri phoneUri =
                                              Uri.parse('tel:+91$rmPhone');
                                          if (await canLaunchUrl(phoneUri)) {
                                            await launchUrl(phoneUri);
                                          }
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.phone,
                                                color: Color(0xFF1D1B20),
                                                size: 18),
                                            const SizedBox(width: 6),
                                            Text(
                                              "+91 ${rmPhone.length > 5 ? '${rmPhone.substring(0, 5)} ${rmPhone.substring(5)}' : rmPhone}",
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF1D1B20),
                                              ),
                                            ),
                                          ],
                                        ),
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(selectedIndex: 2),
    );
  }

  void deleteAccount(String text) async {
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');
    const String apiUrl = 'https://wealthclockadvisors.com/api/client/delete';

    if (authToken == null || authToken.isEmpty) {
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String message = responseData['message'] ?? 'Account deleted';

        // SnackBar(content: Text(message));

        // Clear auth token and other user data
        await prefs.remove('auth_token');
        // You can clear other user-related data here if needed

        // Clear auth token and navigate to the LoginPage (replace entire navigation stack)
        // await prefs.remove('auth_token');

        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
            (route) => false,
          );
        }
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } else {}
    } catch (e) {
      // print('Exception caught: $e');
    }
  }
}
