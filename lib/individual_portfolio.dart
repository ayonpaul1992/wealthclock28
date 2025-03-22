import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'dashboard_after_login.dart';
import 'each_scheme_details.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dashboard_after_login.dart';

class individualPortfolioPage extends StatefulWidget {
  const individualPortfolioPage({super.key});

  @override
  State<individualPortfolioPage> createState() =>
      _individualPortfolioPageState();
}

class _individualPortfolioPageState extends State<individualPortfolioPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> schemes = []; // Store schemes dynamically
  List<Map<String, dynamic>> schemesArr = []; // Store schemes dynamically

  String activeTile = 'Home';
  String userName = "Loading...";
  String schemeName = "Loading...";
  String schemeCurrentValue = "Loading...";
  String schemeInvestedValue = "Loading...";
  String schemeFolioNumber = "Loading...";
  String userCurrentValue = "Loading...";
  String userTotalGain = "Loading...";
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
    // fetchUserName();
    // fetchUserCurrentValue();
    // fetchUserTotalGain();
    fetchUserData();
    // fetchUserDtlsPopUp();
  }

  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');
    const String apiUrl =
        'https://wealthclockadvisors.com/api/client/dashboard';

    if (authToken == null || authToken.isEmpty) {
      setState(() {
        userName = userCurrentValue = userTotalGain = cumulativeXirrValue = absoluteReturnValue = "Auth token not found!";
        schemeName = schemeCurrentValue =
            schemeInvestedValue = schemeFolioNumber = "Auth token not found!";
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
          schemesArr = List<Map<String, dynamic>>.from(data["schemes"] ?? []);
          final fetchedName = data["user_name"] ?? "No Name Found";
          final List<dynamic>? schemesList = data["schemes"];
          final fetchedSchemeName =
              (schemesList != null && schemesList.isNotEmpty)
                  ? schemesList[0]["scheme_name"] ?? "No Name Found"
                  : "No Name Found";
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
              schemeName = "";
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
            schemeName = fetchedSchemeName;
            userCurrentValue = NumberFormat.currency(
                    locale: 'en_IN',
                    symbol: '', // No currency symbol
                    decimalDigits: 2)
                .format(currentValue)
                .trim();
            schemes = schemesArr;

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
            schemeName = "Invalid data format";
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
          userName = userCurrentValue = userTotalGain = cumulativeXirrValue = absoluteReturnValue = errorMessage;
          schemeName = errorMessage;
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
        schemeName = "Error fetching data!";
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
                Text('Unable to retrieve session data. Please log in again.')),
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
          const SnackBar(content: Text('Logged out successfully!')),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // Back arrow
          onPressed: () {
            Navigator.pop(
                context); // You can replace this with any other back navigation
          },
        ),
        title: InkWell(
          onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                     dashboardAfterLogin(userId: '',)));
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
              minimumSize: Size(20,
                  20), // Adjust clickable area to match image size
              padding: EdgeInsets.zero, // Remove padding
              tapTargetSize: MaterialTapTargetSize
                  .shrinkWrap, // Shrink touch area
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
          SizedBox(width: 20,),
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
                          backgroundColor: Color(0xFFfef1e2),
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
                      'MF Details',
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        buildLegendItem("Equity", equityPercentage, Color(0xFF2cbefc), equityAmount),
                                        SizedBox(height: 10),
                                        buildLegendItem("Hybrid", hybridPercentage, Color(0xFFf79e3b), hybridAmount),
                                        SizedBox(height: 10),
                                        buildLegendItem("Debt", debtPercentage, Color(0xFFa6a8a7), debtAmount),
                                        SizedBox(height: 10),
                                        buildLegendItem("Other", otherPercentage, Color(0xFFdac45e), otherAmount),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 20),

                                  // Right Section: Pie Chart
                                  SizedBox(
                                    height: 140, // Adjust as needed
                                    width: 140,  // Adjust as needed
                                    child: PieChart(
                                      PieChartData(
                                        sections: [
                                          createPieSection(double.tryParse(equityPercentage) ?? 0, Color(0xFF2cbefc), "Equity"),
                                          createPieSection(double.tryParse(hybridPercentage) ?? 0, Color(0xFFf79e3b), "Hybrid"),
                                          createPieSection(double.tryParse(debtPercentage) ?? 0, Color(0xFFa6a8a7), "Debt"),
                                          createPieSection(double.tryParse(otherPercentage) ?? 0, Color(0xFFdac45e), "Other"),
                                        ],
                                        borderData: FlBorderData(show: false), // Hide border
                                        sectionsSpace: 0,
                                        centerSpaceRadius: 20, // Creates a donut effect
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

                    Container(

                      child: schemes.isNotEmpty
                          ? ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                              itemCount: schemes
                                  .where((scheme) =>
                                      (scheme['current_val'] ?? 0) != 0 ||
                                      (scheme['invested_val'] ?? 0) != 0)
                                  .length, // Count only schemes that have non-zero values
                              itemBuilder: (context, index) {
                                var validSchemes = schemes
                                    .where((scheme) =>
                                        (scheme['current_val'] ?? 0) != 0 ||
                                        (scheme['invested_val'] ?? 0) != 0)
                                    .toList();

                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          8), // Adds spacing between items
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      backgroundColor: Colors.white,
                                      padding: EdgeInsets
                                          .zero, // Ensure no unwanted padding
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                eachSchemeDetails(scheme: validSchemes[index])),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(15),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  validSchemes[index]
                                                              ['scheme_name']
                                                          ?.toString() ??
                                                      'N/A', // Dynamically display scheme name
                                                  style: GoogleFonts.poppins(
                                                    color: Color(0xFF0f625c),
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                color: Color(0xFF0d958b),
                                                size: 18,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            NumberFormat.currency(
                                              locale: 'en_IN', // Use 'en_US' for US format or 'en_IN' for Indian format
                                              symbol: '₹ ', // Change to '$', '€', etc., as needed
                                              decimalDigits: 2, // Ensures two decimal places
                                            ).format(double.tryParse(validSchemes[index]['current_val']?.toString().replaceAll(',', '') ?? '0') ?? 0.00),
                                            style: GoogleFonts.poppins(
                                              color: Color(0xFF0f625c),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    'Cost Amount',
                                                    style: GoogleFonts.poppins(
                                                      color: Color(0xFF8c8c8c),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text(
                                                    NumberFormat.currency(
                                                      locale: 'en_IN', // Use 'en_US' for US format or 'en_IN' for Indian format
                                                      symbol: '₹ ', // Change this as needed
                                                      decimalDigits: 2, // Ensures two decimal places
                                                    ).format(double.tryParse(validSchemes[index]['invested_val']?.toString().replaceAll(',', '') ?? '0') ?? 0.00),
                                                    style: GoogleFonts.poppins(
                                                      color: Color(0xFF303131),
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    'Folio No.',
                                                    style: GoogleFonts.poppins(
                                                      color: Color(0xFF8c8c8c),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text(
                                                    'XX${maskFolioNumber(validSchemes[index]['folio_number']?.toString() ?? 'N/A')}', // Dynamic folio number
                                                    style: GoogleFonts.poppins(
                                                      color: Color(0xFF303131),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    'Gain/Loss',
                                                    style: GoogleFonts.poppins(
                                                      color: Color(0xFF8c8c8c),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      // Parse gain/loss value from string to double
                                                      Builder(
                                                        builder: (context) {
                                                          double gainLoss = double.tryParse(
                                                              calculateGainLoss(
                                                                  validSchemes[index]['current_val'],
                                                                  validSchemes[index]['invested_val'])
                                                          ) ?? 0.0; // Default to 0.0 if parsing fails

                                                          return Row(
                                                            children: [
                                                              Icon(
                                                                gainLoss >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                                                                color: gainLoss >= 0 ? Color(0xFF09a99d) : Color(0xFFD32F2F),
                                                                size: 15,
                                                              ),
                                                              Text(
                                                                NumberFormat.currency(
                                                                  locale: 'en_IN', // Use 'en_US' for US format or 'en_IN' for Indian format
                                                                  symbol: '₹ ', // Change symbol as needed
                                                                  decimalDigits: 2, // Ensures two decimal places
                                                                ).format(gainLoss),
                                                                style: GoogleFonts.poppins(
                                                                  color: gainLoss >= 0 ? Color(0xFF09a99d) : Color(0xFFD32F2F),
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w600,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 18, bottom: 18),
                                            width: double.infinity,
                                            color: Color(0xFFd7d7d7),
                                            height: 1,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Abs. Ret.: ',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color: Color(
                                                                  0xFF0f625c),
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                    ),
                                                    Text(
                                                      '${((double.tryParse(
                                                          calculateGainLoss(validSchemes[index]['current_val'],
                                                              validSchemes[index]['invested_val'])
                                                      ) ?? 0.0) /
                                                          (double.tryParse(validSchemes[index]['current_val']?.toString() ?? '0') ?? 1.0)
                                                          * 100).toStringAsFixed(2)}%', // 🔥 Dynamic Absolute Return
                                                      style: GoogleFonts.poppins(
                                                        color: Color(0xFF0f625c),
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 15),
                                              Container(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'XIRR:',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color: Color(
                                                                  0xFF0f625c),
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                    ),
                                                    Text(
                                                      ' ${validSchemes[index]['xirr']?.toString() ?? '0'}%', // Dynamic XIRR
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color: Color(
                                                                  0xFF0f625c),
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF0f625c),
                              ),
                            ),
                    ),

                    // Add more widgets here
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 25, right: 25),
            color: Colors.white,
            child: Wrap(
              spacing: 15,
              runSpacing: 15,
              children: [
                InkWell(
                  onTap: () {},
                  child: SizedBox(
                    width: 60,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/ftr_hmm.png',
                          // Adjust as needed
                          fit: BoxFit.contain, // Adjust as needed
                        ),
                        Text(
                          'Home',
                          style: GoogleFonts.poppins(
                            color: Color(0xFF648683),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: SizedBox(
                    width: 60,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/ftr_prtflo.png',
                          // Adjust as needed
                          fit: BoxFit.contain, // Adjust as needed
                        ),
                        Text(
                          'Portfolio',
                          style: GoogleFonts.poppins(
                            color: Color(0xFF648683),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: SizedBox(
                    width: 50,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/ftr_invst.png',
                          // Adjust as needed
                          fit: BoxFit.contain, // Adjust as needed
                        ),
                        Text(
                          'Invest',
                          style: GoogleFonts.poppins(
                            color: Color(0xFF648683),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: SizedBox(
                    width: 50,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/rptt.png',
                          // Adjust as needed
                          fit: BoxFit.contain, // Adjust as needed
                        ),
                        Text(
                          'Report',
                          style: GoogleFonts.poppins(
                            color: Color(0xFF648683),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: SizedBox(
                    width: 60,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/stng.png',
                          // Adjust as needed
                          fit: BoxFit.contain, // Adjust as needed
                        ),
                        Text(
                          'Settings',
                          style: GoogleFonts.poppins(
                            color: Color(0xFF648683),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String maskFolioNumber(String folioNumber) {
    if (folioNumber.length > 4) {
      return '' * (folioNumber.length - 4) +
          folioNumber.substring(folioNumber.length - 4);
    }
    return folioNumber; // If it's less than or equal to 4, show as is
  }

  String calculateGainLoss(dynamic currentVal, dynamic investedVal) {
    double current = double.tryParse(currentVal?.toString() ?? '0') ?? 0.0;
    double invested = double.tryParse(investedVal?.toString() ?? '0') ?? 0.0;
    double difference = current - invested; // Calculate gain/loss

    return difference.toStringAsFixed(2); // Format to 2 decimal places
  }
  Widget buildLegendItem(String title, String percentage, Color color, String amount) {
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
  PieChartSectionData createPieSection(double value, Color color, String title) {
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
      borderSide: BorderSide( // 👈 Add a border (stroke) to each section
        color: Colors.white, // Adjust the border color
        width: 0, // Adjust the border thickness
      ),// Adjust pie slice size
    );
  }
}
