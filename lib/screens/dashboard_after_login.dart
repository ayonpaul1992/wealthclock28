import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:wealthclock28/components/custom_app_bar.dart';
import 'package:wealthclock28/components/custom_drawer.dart';

import 'individual_portfolio.dart';
import 'family_portfolio.dart';
import '../components/custom_bottom_nav_bar.dart';

// ignore: camel_case_types
class dashboardAfterLogin extends StatefulWidget {
  const dashboardAfterLogin({super.key, required String userId});

  @override
  State<dashboardAfterLogin> createState() => _dashboardAfterLoginState();
}

// ignore: camel_case_types
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        scaffoldKey: _scaffoldKey,
        userId: '',
        showLeading: false,
      ),
      drawer: CustomDrawer(
        userName: userName,
        activeTile: 'Home',
        onTileTap: (selectedTile) {
          print("Navigating to $selectedTile");
          // Handle navigation logic
        },
      ),
      body: Column(
        children: [
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
