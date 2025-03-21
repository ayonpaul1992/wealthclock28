import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';

import 'individual_portfolio.dart';
import 'family_portfolio.dart';
import 'custom_bottom_nav_bar.dart';

class dashboardAfterLogin extends StatefulWidget {
  const dashboardAfterLogin({super.key, required String userId});

  @override
  State<dashboardAfterLogin> createState() => _dashboardAfterLoginState();
}

class _dashboardAfterLoginState extends State<dashboardAfterLogin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String activeTile = 'Home';
  String userName = "Loading...";
  String userCurrentValue = "Loading...";
  String userTotalGain = "Loading...";
  String absReturn = '0.00';
  String cumulativeXirrValue = '0.00';
  String absoluteReturnValue = '0.00';

  String equityPercentage = '0.00';
  String equityAmount = '0.00';

  String debtPercentage = '0.00';
  String debtAmount = '0.00';

  String hybridPercentage = '0.00';
  String hybridAmount = '0.00';

  String otherPercentage = '0.00';
  String otherAmount = '0.00';

  String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');
    const String apiUrl =
        'https://wealthclockadvisors.com/api/client/dashboard';

    if (authToken == null || authToken.isEmpty) {
      setState(() {
        userName = userCurrentValue = userTotalGain =
            cumulativeXirrValue = absoluteReturnValue = "Auth token not found!";
      });
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

        print(data['holdings']);

        if (data is Map<String, dynamic>) {
          final fetchedName = data["user_name"] ?? "No Name Found";
          final fetchedPan = data["pan"];
          final cumulativeXirr = (data["cumulativeXirr"] ?? 0).toString();
          final absoluteReturn = (data["absoluteReturn"] ?? 0).toString();
          final currentValue = (data["total_current_val"] ?? 0).toDouble();
          final totalGain = (data["totalGain"] ?? 0).toDouble();
          // ✅ Extract `equityPercentage` & `equityAmount`
          final equityData = data["holdings"]?["EQUITY"];
          double equityValue = (equityData?["currentValue"] ?? 0).toDouble();
          double equityPercent = (equityData?["percentage"] ?? 0).toDouble();
          // ✅ Extract `debtPercentage` & `debtAmount`
          final debtData = data["holdings"]?["DEBT"];
          double debtValue = (debtData?["currentValue"] ?? 0).toDouble();
          double debtPercent = (debtData?["percentage"] ?? 0).toDouble();
          // ✅ Extract `hybridPercentage` & `hybridAmount`
          final hybridData = data["holdings"]?["Hybrid"];
          double hybridValue = (hybridData?["currentValue"] ?? 0).toDouble();
          double hybridPercent = (hybridData?["percentage"] ?? 0).toDouble();
          // ✅ Extract `otherPercentage` & `otherAmount`
          final otherData = data["holdings"]?["OTHER"];
          double otherValue = (otherData?["currentValue"] ?? 0).toDouble();
          double otherPercent = (otherData?["percentage"] ?? 0).toDouble();
          if (fetchedPan == null || fetchedPan.isEmpty) {
            setState(() {
              userName = "";
              cumulativeXirrValue = "0.00";
              absoluteReturnValue = "0.00";
              userCurrentValue = userTotalGain = "0.00";
              equityPercentage = "0.00";
              equityAmount = "0.00";
              debtPercentage = "0.00";
              debtAmount = "0.00";
              otherPercentage = "0.00";
              otherAmount = "0.00";
              hybridPercentage = "0.00";
              hybridAmount = "0.00";
            });
            return;
          }

          setState(() {
            userName = fetchedName;
            cumulativeXirrValue = cumulativeXirr;
            absoluteReturnValue = absoluteReturn;
            userCurrentValue = NumberFormat.currency(
                    locale: 'en_IN',
                    symbol: '', // No currency symbol
                    decimalDigits: 2)
                .format(currentValue)
                .trim();

            userTotalGain = NumberFormat.currency(
                    locale: 'en_IN',
                    symbol: '', // No currency symbol
                    decimalDigits: 2)
                .format(totalGain);
            // ✅ Format & Assign `equityPercentage` & `equityAmount`
            equityPercentage = equityPercent.toStringAsFixed(2);
            equityAmount = NumberFormat.currency(
                    locale: 'en_IN', symbol: '₹', decimalDigits: 2)
                .format(equityValue);
            // ✅ Format & Assign `debtPercentage` & `debtAmount`
            debtPercentage = debtPercent.toStringAsFixed(2);
            debtAmount = NumberFormat.currency(
                    locale: 'en_IN', symbol: '₹', decimalDigits: 2)
                .format(debtValue);
            // ✅ Format & Assign `otherPercentage` & `otherAmount`
            otherPercentage = otherPercent.toStringAsFixed(2);
            otherAmount = NumberFormat.currency(
                    locale: 'en_IN', symbol: '₹', decimalDigits: 2)
                .format(otherValue);
            // ✅ Format & Assign `hybridPercentage` & `hybridAmount`
            hybridPercentage = hybridPercent.toStringAsFixed(2);
            hybridAmount = NumberFormat.currency(
                    locale: 'en_IN', symbol: '₹', decimalDigits: 2)
                .format(hybridValue);
          });
        } else {
          setState(() {
            userName = "Invalid data format";
            cumulativeXirrValue = "No Value";
            absoluteReturnValue = "No Value";
            userCurrentValue = userTotalGain = "0.00";
            equityPercentage = "0.00";
            equityAmount = "0.00";
            debtPercentage = "0.00";
            debtAmount = "0.00";
            otherPercentage = "0.00";
            otherAmount = "0.00";
            hybridPercentage = "0.00";
            hybridAmount = "0.00";
          });
        }
      } else {
        final errorMessage = response.statusCode == 400
            ? json.decode(response.body)["message"] ?? "Bad Request"
            : "Error ${response.statusCode}: Something went wrong!";
        setState(() {
          userName = userCurrentValue = userTotalGain =
              cumulativeXirrValue = absoluteReturnValue = errorMessage;
          equityPercentage = "0.00";
          equityAmount = "0.00";
          debtPercentage = "0.00";
          debtAmount = "0.00";
          otherPercentage = "0.00";
          otherAmount = "0.00";
          hybridPercentage = "0.00";
          hybridAmount = "0.00";
        });
      }
    } catch (e, stackTrace) {
      print('Error: $e');
      print('StackTrace: $stackTrace');
      setState(() {
        userName = "Error fetching data!";
        cumulativeXirrValue = "0.00";
        absoluteReturnValue = "0.00";
        userCurrentValue = userTotalGain = "0.00";
        equityPercentage = "0.00";
        equityAmount = "0.00";
        debtPercentage = "0.00";
        debtAmount = "0.00";
        otherPercentage = "0.00";
        otherAmount = "0.00";
        hybridPercentage = "0.00";
        hybridAmount = "0.00";
      });
    }
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve the dynamically stored API URL and auth token from SharedPreferences
    const String apiUrl =
        'https://wealthclockadvisors.com/api/client/logout'; // Replace with your actual API URL
    final String? authToken =
        prefs.getString('auth_token'); // Dynamically get the auth token

    // Check if the auth token is null
    if (authToken == null) {
      print('Auth token not found in SharedPreferences');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Unable to retrieve session data. Please log in again.'),
        ),
      );
      return;
    }

    try {
      print('Attempting to log out...');
      print('API URL: $apiUrl');
      print('Authorization Token: $authToken');

      // Sending the GET request to the logout API
      final response = await http.get(
        Uri.parse('$apiUrl?logout=true'),
        headers: {
          'Authorization': 'Bearer $authToken', // Use the dynamic auth token
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Successfully logged out
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logged out successfully!'),
          ),
        );

        // Clear all session data after logout
        await prefs.clear();

        // Navigate to the login screen after successful logout
        Navigator.pushReplacementNamed(context, '/login');
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unauthorized')),
        );
      } else {
        // Handle API error response
        print('Error during logout. Status code: ${response.statusCode}');
        print('Error body: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to logout. Please try again.')),
        );
      }
    } catch (e) {
      // Handle network or other errors
      print('Error during logout: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Unable to log out. $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const dashboardAfterLogin(
                  userId: '',
                ),
              ),
            );
          },
          child: Image.asset(
            'assets/images/dshb_logo.png',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Add your functionality here
            },
            style: TextButton.styleFrom(
              minimumSize:
                  Size(20, 20), // Adjust clickable area to match image size
              padding: EdgeInsets.zero, // Remove padding
              tapTargetSize:
                  MaterialTapTargetSize.shrinkWrap, // Shrink touch area
            ),
            child: Image.asset(
              'assets/images/bell-svgrepo-com.png',
              height: 20, // Adjust the height as needed
              width: 20, // Adjust the width as needed
            ),
          ),
          const SizedBox(width: 10),
          TextButton(
            onPressed: () {
              // Add your functionality here
              // Scaffold.of(context).openDrawer();
              _scaffoldKey.currentState?.openDrawer();
            },
            style: TextButton.styleFrom(
              minimumSize: Size(20, 20),
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Image.asset(
              'assets/images/user-svgrepo-com.png',
              height: 20,
              width: 20,
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Color(0xFFfdd1a0),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFFfdd1a0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/images/menu_ppl.png',
                        fit: BoxFit.cover,
                        width: 64,
                        height: 64,
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: Text(
                        userName,
                        style: GoogleFonts.poppins(
                          color: Color(0xFF0f625c),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      width: 43,
                      height: 43,
                      decoration: BoxDecoration(
                        color: Color(0xFFfee8d0),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: IconButton(
                          icon: Icon(Icons.clear, size: 19),
                          onPressed: () {
                            Navigator.pop(
                                context); // Close the drawer when the icon is pressed
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.grey.shade400, width: 1.0))),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero, // Remove extra padding
                    backgroundColor: activeTile == 'Home'
                        ? Color(0xFFfee0be)
                        : Colors
                            .transparent, // Change background color based on active state
                    elevation: activeTile == 'Home'
                        ? 5
                        : 0, // Optional: Adjust elevation
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.zero, // Set border radius to zero
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      activeTile = 'Home'; // Set this tile as active
                    });
                    Navigator.pop(context); // Close the drawer
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.home,
                      color: activeTile == 'Home'
                          ? Color(0xFF0f625c)
                          : Color(0xFF303131),
                      size: 20,
                    ),
                    title: Text(
                      'Home',
                      style: TextStyle(
                        color: activeTile == 'Home'
                            ? Color(0xFF0f625c)
                            : Color(0xFF303131),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.grey.shade400, width: 1.0))),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero, // Remove extra padding
                    backgroundColor: activeTile == 'My Orders'
                        ? Color(0xFFfee0be)
                        : Colors
                            .transparent, // Change background color based on active state
                    elevation: activeTile == 'My Orders'
                        ? 5
                        : 0, // Optional: Adjust elevation
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.zero, // Set border radius to zero
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      activeTile = 'My Orders'; // Set this tile as active
                    });
                    Navigator.pop(context); // Close the drawer
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.shopping_bag_outlined,
                      color: activeTile == 'My Orders'
                          ? Color(0xFF0f625c)
                          : Color(0xFF303131),
                      size: 20,
                    ),
                    title: Text(
                      'My Orders',
                      style: TextStyle(
                        color: activeTile == 'My Orders'
                            ? Color(0xFF0f625c)
                            : Color(0xFF303131),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.grey.shade400, width: 1.0))),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero, // Remove extra padding
                    backgroundColor: activeTile == 'My Profile'
                        ? Color(0xFFfee0be)
                        : Colors
                            .transparent, // Change background color based on active state
                    elevation: activeTile == 'My Profile'
                        ? 5
                        : 0, // Optional: Adjust elevation
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.zero, // Set border radius to zero
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      activeTile = 'My Profile'; // Set this tile as active
                    });
                    Navigator.pop(context); // Close the drawer
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.person_outline_sharp,
                      color: activeTile == 'My Profile'
                          ? Color(0xFF0f625c)
                          : Color(0xFF303131),
                      size: 20,
                    ),
                    title: Text(
                      'My Profile',
                      style: TextStyle(
                        color: activeTile == 'My Profile'
                            ? Color(0xFF0f625c)
                            : Color(0xFF303131),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.grey.shade400, width: 1.0))),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero, // Remove extra padding
                    backgroundColor: activeTile == 'Change Password'
                        ? Color(0xFFfee0be)
                        : Colors
                            .transparent, // Change background color based on active state
                    elevation: activeTile == 'Change Password'
                        ? 5
                        : 0, // Optional: Adjust elevation
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.zero, // Set border radius to zero
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      activeTile = 'Change Password'; // Set this tile as active
                    });
                    Navigator.pop(context); // Close the drawer
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.lock_outline,
                      color: activeTile == 'Change Password'
                          ? Color(0xFF0f625c)
                          : Color(0xFF303131),
                      size: 20,
                    ),
                    title: Text(
                      'Change Password',
                      style: TextStyle(
                        color: activeTile == 'Change Password'
                            ? Color(0xFF0f625c)
                            : Color(0xFF303131),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.grey.shade400, width: 1.0))),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero, // Remove extra padding
                    backgroundColor: activeTile == 'Request a Service'
                        ? Color(0xFFfee0be)
                        : Colors
                            .transparent, // Change background color based on active state
                    elevation: activeTile == 'Request a Service'
                        ? 5
                        : 0, // Optional: Adjust elevation
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.zero, // Set border radius to zero
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      activeTile =
                          'Request a Service'; // Set this tile as active
                    });
                    Navigator.pop(context); // Close the drawer
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.event_note_sharp,
                      color: activeTile == 'Request a Service'
                          ? Color(0xFF0f625c)
                          : Color(0xFF303131),
                      size: 20,
                    ),
                    title: Text(
                      'Request a Service',
                      style: TextStyle(
                        color: activeTile == 'Request a Service'
                            ? Color(0xFF0f625c)
                            : Color(0xFF303131),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero, // Remove extra padding
                    backgroundColor: activeTile == 'Contact Us'
                        ? Color(0xFFfee0be)
                        : Colors
                            .transparent, // Change background color based on active state
                    elevation: activeTile == 'Contact Us'
                        ? 5
                        : 0, // Optional: Adjust elevation
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.zero, // Set border radius to zero
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      activeTile = 'Contact Us'; // Set this tile as active
                    });
                    Navigator.pop(context); // Close the drawer
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.email_outlined,
                      color: activeTile == 'Contact Us'
                          ? Color(0xFF0f625c)
                          : Color(0xFF303131),
                      size: 20,
                    ),
                    title: Text(
                      'Contact Us',
                      style: TextStyle(
                        color: activeTile == 'Contact Us'
                            ? Color(0xFF0f625c)
                            : Color(0xFF303131),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          print('Logout button pressed');
                          _logout(context); // Call the logout function here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFfef1e2),
                        ),
                        child: Text(
                          'Log Out'.toUpperCase(),
                          style: GoogleFonts.poppins(
                            fontSize: 17, // Text size
                            fontWeight: FontWeight.w600, // Text weight
                            color: Color(
                                0xFF222222), // Text color (set to white for contrast)
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Header Row with Logo and Text

          // Main Content Area with Gradient Background
          Expanded(
            child: Container(
              width: double.infinity,
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
                    const SizedBox(height: 20),
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0f625c),
                      ),
                    ),
                    Text(
                      'Individual MF',
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF09a99d),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Portfolio Value',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF648683),
                                    ),
                                  ),
                                  Text(
                                    '₹ $userCurrentValue',
                                    style: GoogleFonts.poppins(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0f625c),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 23),
                            Container(
                              width: 1,
                              height: 56,
                              color: Color(0xFFd5d4d0),
                            ),
                            SizedBox(width: 23),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Overall Gain',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF648683),
                                    ),
                                  ),
                                  Text(
                                    '₹ $userTotalGain',
                                    style: GoogleFonts.poppins(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0f625c),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Text(
                                'Abs. Ret.: ',
                                style: GoogleFonts.poppins(
                                    color: Color(0xFF0f625c),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                '$absoluteReturnValue%',
                                style: GoogleFonts.poppins(
                                    color: Color(0xFF0f625c),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 15),
                        Container(
                          child: Row(
                            children: [
                              Text(
                                'XIRR: ',
                                style: GoogleFonts.poppins(
                                    color: Color(0xFF0f625c),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                '$cumulativeXirrValue%',
                                style: GoogleFonts.poppins(
                                    color: Color(0xFF0f625c),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 26,
                          bottom: 13,
                          left: 18,
                          right: 18,
                        ),
                        child: Column(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  // Left Section: Labels and Percentages
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        buildLegendItem(
                                            "Equity",
                                            equityPercentage,
                                            Color(0xFF2cbefc),
                                            equityAmount),
                                        SizedBox(height: 10),
                                        buildLegendItem(
                                            "Hybrid",
                                            hybridPercentage,
                                            Color(0xFFf79e3b),
                                            hybridAmount),
                                        SizedBox(height: 10),
                                        buildLegendItem("Debt", debtPercentage,
                                            Color(0xFFa6a8a7), debtAmount),
                                        SizedBox(height: 10),
                                        buildLegendItem(
                                            "Other",
                                            otherPercentage,
                                            Color(0xFFdac45e),
                                            otherAmount),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 20),

                                  // Right Section: Pie Chart
                                  SizedBox(
                                    height: 140, // Adjust as needed
                                    width: 140, // Adjust as needed
                                    child: PieChart(
                                      PieChartData(
                                        sections: [
                                          createPieSection(
                                              double.tryParse(
                                                      equityPercentage) ??
                                                  0,
                                              Color(0xFF2cbefc),
                                              "Equity"),
                                          createPieSection(
                                              double.tryParse(
                                                      hybridPercentage) ??
                                                  0,
                                              Color(0xFFf79e3b),
                                              "Hybrid"),
                                          createPieSection(
                                              double.tryParse(debtPercentage) ??
                                                  0,
                                              Color(0xFFa6a8a7),
                                              "Debt"),
                                          createPieSection(
                                              double.tryParse(
                                                      otherPercentage) ??
                                                  0,
                                              Color(0xFFdac45e),
                                              "Other"),
                                        ],
                                        borderData: FlBorderData(
                                            show: false), // Hide border
                                        sectionsSpace: 0,
                                        centerSpaceRadius:
                                            20, // Creates a donut effect
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 18, bottom: 18),
                              color: Color(0xFFd7d7d7),
                              height: 1,
                            ),
                            Wrap(
                              spacing: 10,
                              children: [
                                Text(
                                  'As on:',
                                  style: GoogleFonts.poppins(
                                      color: Color(0xFF648683),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                ),
                                Text(
                                  currentDate,
                                  style: GoogleFonts.poppins(
                                      color: Color(0xFF648683),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 3, // Adjust elevation as needed
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Match container's border radius
                        ),
                        backgroundColor:
                            Colors.white, // Match container's color
                      ),
                      onPressed: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupPage()));
                        // Define the action for the button here
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const individualPortfolioPage()));
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 10, bottom: 10, left: 10, right: 0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFb6dfdc),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child:
                                        Image.asset('assets/images/prtflo.png'),
                                  ),
                                ),
                                SizedBox(width: 15),
                                Text(
                                  'Individual Portfolio',
                                  style: GoogleFonts.poppins(
                                    color: Color(0xFF0f625c),
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  child: Icon(
                                    Icons.info_outline,
                                    color: Color(0xFF0d958b),
                                    size: 20,
                                  ),
                                ),
                                SizedBox(width: 30),
                                Container(
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Color(0xFF0d958b),
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 3, // Adjust elevation as needed
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Match container's border radius
                        ),
                        backgroundColor:
                            Colors.white, // Match container's color
                      ),
                      onPressed: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupPage()));
                        // Define the action for the button here
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    familyPortfolioPage(memberName: userName)));
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 10, bottom: 10, left: 10, right: 0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFb6dfdc),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child:
                                        Image.asset('assets/images/prtflo.png'),
                                  ),
                                ),
                                SizedBox(width: 15),
                                Text(
                                  'Family Portfolio',
                                  style: GoogleFonts.poppins(
                                    color: Color(0xFF0f625c),
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  child: Icon(
                                    Icons.info_outline,
                                    color: Color(0xFF0d958b),
                                    size: 20,
                                  ),
                                ),
                                SizedBox(width: 55),
                                Container(
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Color(0xFF0d958b),
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 30, bottom: 20),
                        child: Text(
                          'Explore Investment Opportunites'.toUpperCase(),
                          style: GoogleFonts.poppins(
                              color: Color(0xFF0f625c),
                              fontWeight: FontWeight.w600,
                              fontSize: 17),
                        )),
                    Container(
                      margin: EdgeInsets.only(bottom: 34),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 28,
                        children: [
                          InkWell(
                            onTap: () {
                              // Define your action here
                              print("New Fund Offer button pressed");
                            },
                            borderRadius: BorderRadius.circular(
                                8), // Add ripple effect matching the button shape
                            child: Container(
                              width: 100,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10), // Optional padding
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFb2daf4),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                          'assets/images/nw_fnd.png'),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'New Fund Offer',
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFF0f625c),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 100,
                            color: Color(0xFFc7d1d0),
                          ),
                          InkWell(
                            onTap: () {
                              // Define your action here
                              print("New Fund Offer button pressed");
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: 100,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFefecdb),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                          'assets/images/thm_invst.png'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Themed Investment',
                                    style: GoogleFonts.poppins(
                                      color: Color(0xFF0f625c),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 100,
                            color: Color(0xFFc7d1d0),
                          ),
                          InkWell(
                            onTap: () {
                              // Define your action here
                              print("New Fund Offer button pressed");
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: 100,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFa5d9d5),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                          'assets/images/int_mtfnd.png'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'International Mutual Funds',
                                    style: GoogleFonts.poppins(
                                      color: Color(0xFF0f625c),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // Define your action here
                              print("New Fund Offer button pressed");
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: 100,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFaadad5),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                          'assets/images/brs_amc.png'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Browse By AMCs',
                                    style: GoogleFonts.poppins(
                                      color: Color(0xFF0f625c),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 100,
                            color: Color(0xFFc7d1d0),
                          ),
                          InkWell(
                            onTap: () {
                              // Define your action here
                              print("New Fund Offer button pressed");
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: 100,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFabd9f4),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                          'assets/images/inv_tx.png'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Invest To Save tax',
                                    style: GoogleFonts.poppins(
                                      color: Color(0xFF0f625c),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 100,
                            color: Color(0xFFc7d1d0),
                          ),
                          InkWell(
                            onTap: () {
                              // Define your action here
                              print("New Fund Offer button pressed");
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: 100,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFedebdb),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                          'assets/images/ctg_tprs.png'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Category Toppers',
                                    style: GoogleFonts.poppins(
                                      color: Color(0xFF0f625c),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Add more widgets here
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 0),
    );
  }

  Widget buildLegendItem(
      String title, String percentage, Color color, String amount) {
    return Row(
      children: [
        Container(
          color: color,
          width: 4,
          height: 30,
        ),
        SizedBox(width: 10),
        SizedBox(
          width: 60,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                    color: Color(0xFF303131),
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                '$percentage%',
                style: GoogleFonts.poppins(
                    color: Color(0xFF8c8c8c),
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        SizedBox(width: 3),
        Text(
          amount,
          style: GoogleFonts.poppins(
              color: Color(0xFF0f625c),
              fontSize: 14,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  PieChartSectionData createPieSection(
      double value, Color color, String title) {
    return PieChartSectionData(
      color: color,
      value: value,
      title: value > 0 ? '$value%' : '',
      // Hide if 0
      titleStyle: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.transparent,
      ),
      radius: 50,
      borderSide: BorderSide(
        // 👈 Add a border (stroke) to each section
        color: Colors.white, // Adjust the border color
        width: 0, // Adjust the border thickness
      ), // Adjust pie slice size
    );
  }
}
