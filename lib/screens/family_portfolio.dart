// ignore_for_file: camel_case_types

import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wealthclock28/components/custom_app_bar.dart';
import 'package:wealthclock28/components/custom_bottom_nav_bar.dart';
import 'package:wealthclock28/components/custom_drawer.dart';
import 'package:wealthclock28/components/legend_item.dart';
import 'package:wealthclock28/components/pie_chart_section.dart';
import '../extras/family_scheme_details.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';

class familyPortfolioPage extends StatefulWidget {
  final String memberName; // Store the memberName

  const familyPortfolioPage({super.key, required this.memberName});

  @override
  State<familyPortfolioPage> createState() => _familyPortfolioPageState();
}

class _familyPortfolioPageState extends State<familyPortfolioPage> {
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
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');
    const String apiUrl =
        'https://wealthclockadvisors.com/api/client/familyPortfolio';

    if (authToken == null || authToken.isEmpty) {
      setState(() {
        userName = userCurrentValue = userTotalGain =
            cumulativeXirrValue = absoluteReturnValue = "Auth token not found!";
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

        //print(data['holdings']);

        if (data is Map<String, dynamic>) {
          schemesArr = List<Map<String, dynamic>>.from(data["allMember"] ?? []);
          final fetchedName =
              data["allMember"][0]["member_name"] ?? "No Name Found";
          final List<dynamic>? schemesList = data["allMember"];
          final fetchedSchemeName =
              (schemesList != null && schemesList.isNotEmpty)
                  ? schemesList[0]["member_name"] ?? "No Name Found"
                  : "No Name Found";
          final fetchedPan = data["allMember"][0]['member_pan'];
          final cumulativeXirr = data["allMember"][0]["xirr"];
          final absoluteReturn =
              (data["familyAbsReturn"] ?? 0.0).toStringAsFixed(2);
          final currentValue = (data["familyCrntAmt"] ?? 0).toDouble();
          final totalGain = (data["familyTotalGain"] ?? 0).toDouble();
          // ✅ Extract `equityPercentage` & `equityAmount`
          final equityData = data["holdings"]?["EQUITY"];
          double equityValue = (equityData?["currentValue"] ?? 0).toDouble();
          double equityPercent = (equityData?["percentage"] ?? 0).toDouble();
          // ✅ Extract `debtPercentage` & `debtAmount`
          final debtData = data["holdings"]?["DEBT"];
          double debtValue = (debtData?["currentValue"] ?? 0).toDouble();
          double debtPercent = (debtData?["percentage"] ?? 0).toDouble();
          // ✅ Extract `hybridPercentage` & `hybridAmount`
          final hybridData = data["holdings"]?["HYBRID"];
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
          userName = userCurrentValue = userTotalGain =
              cumulativeXirrValue = absoluteReturnValue = errorMessage;
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
    } catch (e) {
      //print('Error: $e');
      //print('StackTrace: $stackTrace');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(scaffoldKey: _scaffoldKey, userId: ''),
      drawer: CustomDrawer(
        userName: userName,
        activeTile: '',
        onTileTap: (selectedTile) {
          // //print("Navigating to $selectedTile");
          // Handle navigation logic
        },
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
                      widget.memberName.isNotEmpty
                          ? widget.memberName
                          : "No Name Found", // Ensure non-null value
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0f625c),
                      ),
                    ),
                    Text(
                      'Family Portfolio',
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
                            Column(
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
                        Row(
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
                        SizedBox(width: 15),
                        Row(
                          children: [
                            Text(
                              'Avg. Xirr: ',
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
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      LegendItem(
                                        title: "Equity",
                                        percentage: equityPercentage,
                                        color: Color(0xFF2cbefc),
                                        amount: equityAmount,
                                      ),
                                      SizedBox(height: 10),
                                      LegendItem(
                                        title: "Hybrid",
                                        percentage: hybridPercentage,
                                        color: Color(0xFFf79e3b),
                                        amount: hybridAmount,
                                      ),
                                      SizedBox(height: 10),
                                      LegendItem(
                                        title: "Debt",
                                        percentage: debtPercentage,
                                        color: Color(0xFFa6a8a7),
                                        amount: debtAmount,
                                      ),
                                      SizedBox(height: 10),
                                      LegendItem(
                                        title: "Other",
                                        percentage: otherPercentage,
                                        color: Color(0xFFdac45e),
                                        amount: otherAmount,
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 20),

                                  // Right Section: Pie Chart
                                  SizedBox(
                                    height: 140, // Adjust as needed
                                    width: 140, // Adjust as needed
                                    child: PieChart(
                                      PieChartData(
                                        sections: [
                                          PieChartSection.create(
                                            value: double.tryParse(
                                                    equityPercentage) ??
                                                0,
                                            color: const Color(0xFF2cbefc),
                                            title: "Equity",
                                          ),
                                          PieChartSection.create(
                                            value: double.tryParse(
                                                    hybridPercentage) ??
                                                0,
                                            color: const Color(0xFFf79e3b),
                                            title: "Hybrid",
                                          ),
                                          PieChartSection.create(
                                            value: double.tryParse(
                                                    debtPercentage) ??
                                                0,
                                            color: const Color(0xFFa6a8a7),
                                            title: "Debt",
                                          ),
                                          PieChartSection.create(
                                            value: double.tryParse(
                                                    otherPercentage) ??
                                                0,
                                            color: const Color(0xFFdac45e),
                                            title: "Other",
                                          ),
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

                    Container(
                      child: schemes.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemCount: schemes
                                  .where((scheme) =>
                                      (scheme['current_val'] ?? 0) != 0 ||
                                      (scheme['Invested_val'] ?? 0) != 0)
                                  .length, // Count only schemes that have non-zero values
                              itemBuilder: (context, index) {
                                var validSchemes = schemes
                                    .where((scheme) =>
                                        (scheme['current_val'] ?? 0) != 0 ||
                                        (scheme['Invested_val'] ?? 0) != 0)
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
                                              familySchemeDetails(
                                                  scheme: validSchemes[index]),
                                        ),
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
                                                              ['member_name']
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
                                              locale:
                                                  'en_IN', // Use 'en_US' for US format or 'en_IN' for Indian format
                                              symbol:
                                                  '₹ ', // Change to '$', '€', etc., as needed
                                              decimalDigits:
                                                  2, // Ensures two decimal places
                                            ).format(double.tryParse(
                                                    validSchemes[index]
                                                                ['current_val']
                                                            ?.toString()
                                                            .replaceAll(
                                                                ',', '') ??
                                                        '0') ??
                                                0.00),
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
                                                      locale:
                                                          'en_IN', // Use 'en_US' for US format or 'en_IN' for Indian format
                                                      symbol:
                                                          '₹ ', // Change this as needed
                                                      decimalDigits:
                                                          2, // Ensures two decimal places
                                                    ).format(double.tryParse(
                                                            validSchemes[index][
                                                                        'Invested_val']
                                                                    ?.toString()
                                                                    .replaceAll(
                                                                        ',',
                                                                        '') ??
                                                                '0') ??
                                                        0.00),
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
                                                          double gainLoss = double.tryParse(calculateGainLoss(
                                                                  validSchemes[
                                                                          index]
                                                                      [
                                                                      'current_val'],
                                                                  validSchemes[
                                                                          index]
                                                                      [
                                                                      'Invested_val'])) ??
                                                              0.0; // Default to 0.0 if parsing fails

                                                          return Row(
                                                            children: [
                                                              Icon(
                                                                gainLoss >= 0
                                                                    ? Icons
                                                                        .arrow_upward
                                                                    : Icons
                                                                        .arrow_downward,
                                                                color: gainLoss >=
                                                                        0
                                                                    ? Color(
                                                                        0xFF09a99d)
                                                                    : Color(
                                                                        0xFFD32F2F),
                                                                size: 15,
                                                              ),
                                                              Text(
                                                                NumberFormat
                                                                    .currency(
                                                                  locale:
                                                                      'en_IN', // Use 'en_US' for US format or 'en_IN' for Indian format
                                                                  symbol:
                                                                      '₹ ', // Change symbol as needed
                                                                  decimalDigits:
                                                                      2, // Ensures two decimal places
                                                                ).format(
                                                                    gainLoss),
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  color: gainLoss >=
                                                                          0
                                                                      ? Color(
                                                                          0xFF09a99d)
                                                                      : Color(
                                                                          0xFFD32F2F),
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
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
                                              top: 18,
                                              bottom: 18,
                                            ),
                                            width: double.infinity,
                                            color: Color(0xFFd7d7d7),
                                            height: 1,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'Abs. Ret.: ',
                                                    style: GoogleFonts.poppins(
                                                      color: Color(0xFF0f625c),
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  Text(
                                                    ' ${validSchemes[index]['abs_return']?.toString() ?? '0'}%', // Dynamic XIRR
                                                    style: GoogleFonts.poppins(
                                                      color: Color(0xFF0f625c),
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 15),
                                              Row(
                                                children: [
                                                  Text(
                                                    'XIRR:',
                                                    style: GoogleFonts.poppins(
                                                      color: Color(0xFF0f625c),
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  Text(
                                                    ' ${validSchemes[index]['xirr']?.toString() ?? '0'}%', // Dynamic XIRR
                                                    style: GoogleFonts.poppins(
                                                      color: Color(0xFF0f625c),
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
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
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 0),
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
}
