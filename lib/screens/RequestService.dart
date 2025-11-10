import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wealthclock28/components/custom_app_bar.dart';
import 'package:wealthclock28/components/custom_drawer.dart';
import 'package:wealthclock28/components/custom_bottom_nav_bar.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: camel_case_types
class RequestServicePage extends StatefulWidget {
  const RequestServicePage({super.key, required String rqsrvcId});

  @override
  State<RequestServicePage> createState() => RequestServicePageState();
}

// ignore: camel_case_types
class RequestServicePageState extends State<RequestServicePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String rmName = "";
  String rmEmail = "";
  String rmContact = "";

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
      // setState(() {
      //   userName = userCurrentValue = userTotalGain =
      //       cumulativeXirrValue = absoluteReturnValue = "Auth token not found!";
      // });
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

      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body.trim());
        if (data is Map<String, dynamic>) {
          final responseData = data['rm'];

          // print('RM Data: $responseData');

          setState(() {
            rmName = responseData['fullname'] ?? '';
            rmEmail = responseData['email'] ?? '';
            rmContact = responseData['mobileno'] ?? '';
          });
        }
      }
    } catch (e) {
      // setState(() {
      //   userName = "Error fetching data!";
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        scaffoldKey: _scaffoldKey,
        rqsrvcId: '',
        showLeading: true,
        userId: '',
        prflId: '',
      ),
      drawer: CustomDrawer(
        activeTile: 'Contact Us',
        onTileTap: (selectedTile) {},
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
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
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height -
                              kToolbarHeight -
                              kBottomNavigationBarHeight,
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Container(
                                width: 75,
                                height: 75,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Color(0xFF0DA99E), width: 3),
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

                              GestureDetector(
                                onTap: () async {
                                  final Uri emailUri = Uri(
                                    scheme: 'mailto',
                                    path: rmEmail,
                                    // Optional extras:
                                    // queryParameters: {
                                    //   'subject': 'Support Request',
                                    //   'body': 'Hello Pratap,'
                                    // },
                                  );
                                  if (await canLaunchUrl(emailUri)) {
                                    await launchUrl(emailUri);
                                  } else {
                                    debugPrint('Could not launch email client');
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.mail_outline,
                                        color: Color(0xFF1D1B20), size: 18),
                                    const SizedBox(width: 6),
                                    Text(
                                      rmEmail,
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1D1B20),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 14),

                              // Contact
                              GestureDetector(
                                onTap: () async {
                                  final Uri phoneUri =
                                      Uri.parse('tel:+91$rmContact');
                                  if (await canLaunchUrl(phoneUri)) {
                                    await launchUrl(phoneUri);
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.phone,
                                        color: Color(0xFF1D1B20), size: 18),
                                    const SizedBox(width: 6),
                                    Text(
                                      "+91 $rmContact",
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(selectedIndex: 4),
    );
  }
}
