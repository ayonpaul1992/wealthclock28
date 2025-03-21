import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'each_fund_investment_detils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_after_login.dart';

class eachSchemeDetails extends StatefulWidget {
  final Map<String, dynamic> scheme; // ✅ Define scheme as a property

  const eachSchemeDetails(
      {super.key, required this.scheme}); // ✅ Store it in the class

  @override
  State<eachSchemeDetails> createState() => _eachSchemeDetailsState();
}

class _eachSchemeDetailsState extends State<eachSchemeDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> schemes = []; // Store schemes dynamically
  List<Map<String, dynamic>> schemesArr = []; // Store schemes dynamically
  List<Map<String, dynamic>> apiData = [];

  String activeTile = 'Home';
  String userName = "Loading...";
  String schemeName = "Loading...";
  String schemeCurrentValue = "Loading...";
  String schemeInvestedValue = "Loading...";
  String schemeFolioNumber = "Loading...";
  String schemeCategory = "Loading...";
  String schemeSubCategory = "Loading...";
  String userCurrentValue = "Loading...";
  String userTotalGain = "Loading...";
  String absReturn = '0.00';
  String xirr = '0.00';

  String equityPercentage = '0.00';
  String equityAmount = '0.00';

  String debtPercentage = '0.00';
  String debtAmount = '0.00';

  String hybridPercentage = '0.00';
  String hybridAmount = '0.00';

  String otherPercentage = '0.00';
  String otherAmount = '0.00';
  // added on start 20.03.2025
  bool isLoading = false;
  bool hasTransactions = false; // ✅ Declare it here
  String schemeTransactionDataTdAmnt = "";
  List<double> tdAmounts = [];
  String schemeTransactionDataTdUnits = "";
  List<double> tdUnits = [];
  String schemeTransactionDataTdDate = "";
  List<String> tdDate = [];
  String schemeTransactionDataTdPurred = "";
  List<String> tdPurred = [];
  String schemeTransactionDataBalancedUnits = "";
  List<String> transBalancedUnits = [];
  String schemeTransactionDataTottal = "";
  List<Map<String, dynamic>> transactionDataBox = [];
  // added on end 20.03.2025
  String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    // added on start 20.03.2025

    userName = widget.scheme["user_name"] ?? "No Name Found";
    schemeName = widget.scheme["scheme_name"] ?? "No Scheme Name";
    schemeCurrentValue = widget.scheme["current_val"].toString();
    schemeInvestedValue = widget.scheme["invested_val"].toString();
    schemeFolioNumber = widget.scheme["folio_number"].toString();
    schemeCategory = widget.scheme["scheme_category"] ?? "N/A";
    schemeSubCategory = widget.scheme["scheme_subcategory"] ?? "N/A";
    fetchInvestmentBreakup(
        schemeFolioNumber,
        widget.scheme["inf_no"] ?? "", // Ensure this is correct
         // Ensure this is correct
        );
    isLoading = false;
    hasTransactions = true;
    schemeTransactionDataTdAmnt = tdAmounts
        .map((amt) =>
            NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(amt))
        .join(", ");
    schemeTransactionDataTdUnits = tdUnits
        .map((amt) =>
            NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(amt))
        .join(", ");

    schemeTransactionDataTdPurred = tdPurred.join(", ");
    schemeTransactionDataBalancedUnits = transBalancedUnits.join(", ");
    schemeTransactionDataTdDate = tdDate.map((date) {
      // ✅ Ensure the date is parsed and formatted correctly
      if (date is String) {
        try {
          DateTime parsedDate = DateTime.parse(date as String);
          return DateFormat('dd/MM/yyyy')
              .format(parsedDate); // ✅ Format to DD/MM/YYYY
        } catch (e) {
          return "Invalid Date"; // Handle parsing errors
        }
      }
      return "Invalid Date";
    }).join(", ");
    schemeTransactionDataTottal = transactionDataBox
        .map((item) =>
            item.toString()) // Convert each transaction object to a string
        .join(", ");
    print("Updated schemeTransactionDataTdAmnt: $schemeTransactionDataTdAmnt");

    // added on end 20.03.2025
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');
    const String apiUrl =
        'https://wealthclockadvisors.com/api/client/dashboard';

    if (authToken == null || authToken.isEmpty) {
      setState(() {
        userName = userCurrentValue = userTotalGain = "Auth token not found!";
        schemeName = schemeCurrentValue = schemeInvestedValue =
            schemeFolioNumber =
                schemeCategory = schemeSubCategory = "Auth token not found!";
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
          userName = userCurrentValue = userTotalGain = errorMessage;
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

  Future<void> fetchInvestmentBreakup(
      String folioNumber, String infNo) async {
    setState(() {
      isLoading = true;
      hasTransactions = false;
      schemeTransactionDataTdAmnt = "Loading...";
      schemeTransactionDataTottal = "Loading...";
      schemeTransactionDataTdUnits = "Loading...";
      schemeTransactionDataTdDate = "Loading...";
      schemeTransactionDataTdPurred = "Loading...";
      schemeTransactionDataBalancedUnits = "Loading...";
      widget.scheme['balancedUnits'] = "0.00";
    });

    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');

    if (authToken == null || authToken.isEmpty) {
      setState(() {
        isLoading = false;
        schemeTransactionDataTdAmnt = "Auth token missing!";
        schemeTransactionDataTottal = "Auth token missing!";
        schemeTransactionDataTdUnits = "Auth token missing!";
        schemeTransactionDataTdDate = "Auth token missing!";
        schemeTransactionDataTdPurred = "Auth token missing!";
        schemeTransactionDataBalancedUnits = "Auth token missing!";
        hasTransactions = false;
        widget.scheme['balancedUnits'] = "0.00";
      });
      return;
    }

    final String apiUrl =
        'https://wealthclockadvisors.com/api/client/clientInvestmentBreakup'
        '?folio_number=$folioNumber&inf_no=$infNo';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}"); // ✅ Print full response
      print("Requesting API with: folio_number=$folioNumber, inf_no=$infNo");

      if (response.statusCode == 200) {
        final data = json.decode(response.body.trim());

        if (data is Map<String, dynamic>) {
          print("Parsed Data: $data"); // ✅ Check parsed data

          if (data.containsKey('transaction_data') &&
              data["transaction_data"] is List &&
              data["transaction_data"].isNotEmpty) {
            List<Map<String, dynamic>> transactions =
                List<Map<String, dynamic>>.from(data["transaction_data"]);
            print(transactions);
            if (transactions.isNotEmpty) {
              String latestBalancedUnits =
                  transactions[0]["balancedUnits"];

              setState(() {
                hasTransactions = true;
                widget.scheme['balancedUnits'] = latestBalancedUnits;
                isLoading = false;
              });

              print("✅ Updated Balanced Units: $latestBalancedUnits");
            } else {
              print("⚠️ No transactions found!");
              setState(() {
                hasTransactions = false;
                widget.scheme['balancedUnits'] = "0.00";
                isLoading = false;
              });
            }
            setState(() {
              // ✅ Extract numerical values
              tdAmounts = transactions
                  .map<double>(
                      (item) => (item["amount"] as num?)?.toDouble() ?? 0.0)
                  .toList();

              tdUnits = transactions
                  .map<double>(
                      (item) => (item["units"] as num?)?.toDouble() ?? 0.0)
                  .toList();
              tdPurred = transactions
                  .map<String>((item) => (item["transactionType"] != null)
                      ? item["transactionType"].toString()
                      : "0.0")
                  .toList();
              transBalancedUnits = transactions
                  .map<String>((item) => (item["balancedUnits"] != null)
                  ? item["balancedUnits"].toString()
                  : "0.0")
                  .toList();

              // ✅ Extract & format transaction dates
              tdDate = transactions.map<String>((item) {
                var rawDate = item["transactionDate"];

                if (rawDate != null) {
                  try {
                    // ✅ Ensure rawDate is always a String before parsing
                    String dateStr = rawDate.toString();
                    DateTime parsedDate = DateTime.parse(dateStr);
                    return DateFormat('dd/MM/yyyy').format(parsedDate);
                  } catch (e) {
                    return "Invalid Date";
                  }
                }
                return "Invalid Date";
              }).toList();

              // ✅ Store full transaction objects
              transactionDataBox = transactions;

              isLoading = false;
              hasTransactions = true;

              // ✅ Format amounts as currency
              schemeTransactionDataTdAmnt = tdAmounts
                  .map((amt) =>
                      NumberFormat.currency(locale: 'en_IN', symbol: '₹')
                          .format(amt))
                  .join(", ");

              // ✅ Format units as plain numbers
              schemeTransactionDataTdUnits = tdUnits
                  .map((unit) =>
                      unit.toStringAsFixed(2)) // Keep two decimal places
                  .join(", ");
              schemeTransactionDataTdPurred = tdPurred.join(", ");
              schemeTransactionDataBalancedUnits = transBalancedUnits.join(", ");

              // ✅ Format transaction dates
              schemeTransactionDataTdDate = tdDate.join(", ");

              // ✅ Summarize transactions instead of full JSON
              schemeTransactionDataTottal = transactions
                  .map((item) =>
                      "Amt: ₹${item["amount"]}, Units: ${item["units"]}, Date: ${item["transactionDate"]}")
                  .join("\n");
            });

            print(
                "Updated schemeTransactionDataTdAmnt: $schemeTransactionDataTdAmnt");
            print(
                "Updated schemeTransactionDataTottal: $schemeTransactionDataTottal");
          } else {
            print("⚠️ No transaction_data found or list is empty");
            setState(() {
              isLoading = false;
              hasTransactions = false;
              widget.scheme['balancedUnits'] = "0.00";
              schemeTransactionDataTdAmnt = "No transactions available";
              schemeTransactionDataTottal = "No transactions available";
              schemeTransactionDataTdUnits = "No transactions available";
              schemeTransactionDataTdDate = "No transactions available";
              schemeTransactionDataTdPurred = "No transactions available";
              schemeTransactionDataBalancedUnits = "No transactions available";
            });
          }
        } else {
          print("❌ API response is not a valid JSON object");
          setState(() {
            isLoading = false;
            hasTransactions = false;
            schemeTransactionDataTdAmnt = "Invalid response format";
            schemeTransactionDataTottal = "Invalid response format";
            schemeTransactionDataTdUnits = "Invalid response format";
            schemeTransactionDataTdDate = "Invalid response format";
            schemeTransactionDataTdPurred = "Invalid response format";
            schemeTransactionDataBalancedUnits = "Invalid response format";
            widget.scheme['balancedUnits'] = "0.00";
          });
        }
      } else {
        print("❌ API Error: ${response.statusCode}, Body: ${response.body}");
        setState(() {
          isLoading = false;
          hasTransactions = false;
          schemeTransactionDataTdAmnt =
              "❌ Error ${response.statusCode}: ${response.body}";
          schemeTransactionDataTottal =
              "❌ Error ${response.statusCode}: ${response.body}";
          schemeTransactionDataTdUnits =
              "❌ Error ${response.statusCode}: ${response.body}";
          schemeTransactionDataTdDate =
              "❌ Error ${response.statusCode}: ${response.body}";
          schemeTransactionDataTdPurred =
              "❌ Error ${response.statusCode}: ${response.body}";
          schemeTransactionDataBalancedUnits =
          "❌ Error ${response.statusCode}: ${response.body}";
          widget.scheme['balancedUnits'] = "0.00";
        });
      }
    } catch (e) {
      print("❌ Exception: $e");
      setState(() {
        isLoading = false;
        hasTransactions = false;
        schemeTransactionDataTdAmnt = "Error fetching data!";
        schemeTransactionDataTottal = "Error fetching data!";
        schemeTransactionDataTdUnits = "Error fetching data!";
        schemeTransactionDataTdDate = "Error fetching data!";
        schemeTransactionDataTdPurred = "Error fetching data!";
        schemeTransactionDataBalancedUnits = "Error fetching data!";
        widget.scheme['balancedUnits'] = "0.00";
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
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => dashboardAfterLogin(
                          userId: '',
                        )));
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
                    Container(
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
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 0, bottom: 20, left: 15, right: 15),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              userName,
                              style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF09a99d),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              child: Text(
                                '${widget.scheme['scheme_name']?.toString() ?? 'N/A'}',
                                textAlign: TextAlign
                                    .center, // Apply text alignment here
                                style: GoogleFonts.poppins(
                                  color: Color(0xFF0f625c),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      if (widget.scheme['scheme_category'] !=
                                              null &&
                                          widget.scheme['scheme_category']
                                              .toString()
                                              .isNotEmpty)
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors
                                                .white, // Background color
                                            borderRadius: BorderRadius.circular(
                                                50), // Rounded corners
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                    0.2), // Shadow color with opacity
                                                spreadRadius:
                                                    2, // How much the shadow spreads
                                                blurRadius:
                                                    5, // How soft the shadow is
                                                offset: Offset(0,
                                                    3), // Shadow position (x, y)
                                              ),
                                            ],
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical:
                                                  10), // Padding for better appearance
                                          child: Text(
                                            widget.scheme['scheme_category']
                                                .toString(),
                                            style: GoogleFonts.poppins(
                                              color: Color(0xFF8c8c8c),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      SizedBox(width: 10),
                                      if (widget.scheme['scheme_subcategory'] !=
                                              null &&
                                          widget.scheme['scheme_subcategory']
                                              .toString()
                                              .isNotEmpty)
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors
                                                .white, // Background color
                                            borderRadius: BorderRadius.circular(
                                                50), // Rounded corners
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                    0.2), // Shadow color with opacity
                                                spreadRadius:
                                                    2, // How much the shadow spreads
                                                blurRadius:
                                                    5, // How soft the shadow is
                                                offset: Offset(0,
                                                    3), // Shadow position (x, y)
                                              ),
                                            ],
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical:
                                                  10), // Padding for better appearance
                                          child: Text(
                                            widget.scheme['scheme_subcategory']
                                                .toString(), // Directly use the value
                                            style: GoogleFonts.poppins(
                                              color: Color(0xFF8c8c8c),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  // Container(
                                  //   margin: EdgeInsets.only(left: 0),
                                  //   child: Column(
                                  //     children: [
                                  //       Text(
                                  //         'Gain/Loss',
                                  //         style: GoogleFonts.poppins(
                                  //           color: Color(0xFF8c8c8c),
                                  //           fontSize: 14,
                                  //           fontWeight: FontWeight.w500,
                                  //         ),
                                  //       ),
                                  //       SingleChildScrollView(
                                  //         scrollDirection: Axis.horizontal,
                                  //         child: Builder(
                                  //           builder: (context) {
                                  //             // Convert gain/loss value from String to double
                                  //             double gainLoss = double.tryParse(
                                  //                     calculateGainLoss(
                                  //                         widget.scheme[
                                  //                             'current_val'],
                                  //                         widget.scheme[
                                  //                             'invested_val'])) ??
                                  //                 0.0;
                                  //
                                  //             return Row(
                                  //               children: [
                                  //                 Icon(
                                  //                   gainLoss >= 0
                                  //                       ? Icons.arrow_upward
                                  //                       : Icons.arrow_downward,
                                  //                   color: gainLoss >= 0
                                  //                       ? Color(0xFF09a99d)
                                  //                       : Color(0xFFD32F2F),
                                  //                   size: 15,
                                  //                 ),
                                  //                 Text(
                                  //                   '₹ ${gainLoss.toStringAsFixed(2)}', // Format to 2 decimal places
                                  //                   style: GoogleFonts.poppins(
                                  //                     color: gainLoss >= 0
                                  //                         ? Color(0xFF09a99d)
                                  //                         : Color(0xFFD32F2F),
                                  //                     fontSize: 14,
                                  //                     fontWeight: FontWeight.w600,
                                  //                   ),
                                  //                 ),
                                  //               ],
                                  //             );
                                  //           },
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Folio No.',
                                        style: GoogleFonts.poppins(
                                          color: Color(0xFF8c8c8c),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '${widget.scheme['folio_number']?.toString() ?? 'N/A'}',
                                        style: GoogleFonts.poppins(
                                          color: Color(0xFF303131),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Holding Pattern',
                                        style: GoogleFonts.poppins(
                                          color: Color(0xFF8c8c8c),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        'Single',
                                        style: GoogleFonts.poppins(
                                          color: Color(0xFF303131),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Joint Holder',
                                        style: GoogleFonts.poppins(
                                          color: Color(0xFF8c8c8c),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '',
                                        style: GoogleFonts.poppins(
                                          color: Color(0xFF303131),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                            NumberFormat.currency(
                                              locale: 'en_IN', // Indian number format
                                              symbol: '₹ ', // Currency symbol
                                              decimalDigits: 2, // Two decimal places
                                            ).format(double.tryParse(widget.scheme['current_val']?.toString() ?? '') ?? 0.0),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Overall Gain',
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF648683),
                                            ),
                                          ),
                                          Builder(
                                            builder: (context) {
                                              // Convert gain/loss value from String to double
                                              double gainLoss = double.tryParse(
                                                      calculateGainLoss(
                                                          widget.scheme[
                                                              'current_val'],
                                                          widget.scheme[
                                                              'invested_val'])) ??
                                                  0.0;

                                              // Format with comma as thousands separator
                                              final formattedGainLoss =
                                                  NumberFormat.currency(
                                                locale:
                                                    'en_IN', // Indian format
                                                symbol: '₹ ', // Currency symbol
                                                decimalDigits:
                                                    2, // Keep two decimal places
                                              ).format(gainLoss);

                                              return Row(
                                                children: [
                                                  Text(
                                                    formattedGainLoss, // Apply formatted text
                                                    style: GoogleFonts.poppins(
                                                      color: Color(0xFF0f625c),
                                                      fontSize: 19,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              color: Color(0xFFd7d7d7),
                              height: 1,
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
                                        (((double.tryParse(
                                            calculateGainLoss(widget.scheme['current_val'], widget.scheme['invested_val'])) ??
                                            0.0) /
                                            (double.tryParse(widget.scheme['invested_val']?.toString() ?? '0') ?? 1))
                                            * 100) // Multiply by 100
                                            .toStringAsFixed(2) + " %", // Append percentage symbol
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF0f625c),
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
                                        'XIRR: ',
                                        style: GoogleFonts.poppins(
                                            color: Color(0xFF0f625c),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        ' ${widget.scheme['xirr']?.toString() ?? '0'}%',
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
                    // each fund investment details start

                    // each fund investment details start 20.03.2025

                    // click here for more details button start 20.03.2025
                    // Container(
                    //   margin: EdgeInsets.only(top: 15),
                    //   child: ElevatedButton(
                    //     style: ElevatedButton.styleFrom(
                    //       // Adjust elevation as needed
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(
                    //             50), // Match container's border radius
                    //       ),
                    //       backgroundColor: Colors.white,
                    //       // Match container's color
                    //     ),
                    //     onPressed: () {
                    //       var validSchemes = schemes
                    //           .where((scheme) =>
                    //               (scheme['current_val'] ?? 0) != 0 ||
                    //               (scheme['invested_val'] ?? 0) != 0)
                    //           .toList();
                    //
                    //       if (validSchemes.isNotEmpty) {
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //             builder: (context) =>
                    //                 eachFundInvstDtls(scheme: widget.scheme),
                    //           ),
                    //         );
                    //       } else {
                    //         ScaffoldMessenger.of(context).showSnackBar(
                    //           SnackBar(
                    //               content: Text("No valid schemes available")),
                    //         );
                    //       }
                    //     },
                    //     child: Text(
                    //       'Click Here For More Details',
                    //       style: GoogleFonts.poppins(
                    //           color: Color(0xFF09a99d),
                    //           fontWeight: FontWeight.w500,
                    //           fontSize: 14),
                    //     ),
                    //   ),
                    // ),
                    // click here for more details button end 20.03.2025
                    Container(
                        margin: EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        // margin: EdgeInsets.only(top: 25,bottom: 14,left: 11,right: 11),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 20, left: 10, right: 10, bottom: 20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Balance Units',
                                        style: GoogleFonts.poppins(
                                          color: Color(0xFF8c8c8c),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        NumberFormat.currency(
                                          locale: 'en_IN', // Use 'en_US' for US format or 'en_IN' for Indian format
                                          symbol: '', // Change to '$', '€', etc., as needed
                                          decimalDigits: 2, // Ensures two decimal places
                                        ).format(double.tryParse(widget.scheme['balancedUnits'].toString().replaceAll(',', '')) ?? 0.00),
                                        style: GoogleFonts.poppins(
                                          color: Color(0xFF303131),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'NAV',
                                        style: GoogleFonts.poppins(
                                          color: Color(0xFF8c8c8c),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '₹ ${double.tryParse(widget.scheme['nav']?.toString() ?? '0')?.toStringAsFixed(2) ?? '0.00'}',
                                        style: GoogleFonts.poppins(
                                          color: Color(0xFF303131),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Market Value',
                                        style: GoogleFonts.poppins(
                                          color: Color(0xFF8c8c8c),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        NumberFormat.currency(
                                          locale: 'en_IN', // Indian number format
                                          symbol: '₹ ', // Currency symbol
                                          decimalDigits: 2, // Two decimal places
                                        ).format(double.tryParse(widget.scheme['current_val']?.toString() ?? '') ?? 0.0),
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF303131),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                    SizedBox(height: 20,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // dynamic work start on 20.03.2025

                        Container(

                          child: isLoading
                              ? Center(child: CircularProgressIndicator())
                              : hasTransactions && transactionDataBox.isNotEmpty
                              ? Flexible(
                                child: ListView.builder(
                                                            shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                                            itemCount: transactionDataBox.length,
                                                            itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      top: 0,
                                      right: 0,
                                      left: 0,
                                      bottom: 12),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.only(right: 15),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Padding(
                                                padding: EdgeInsets
                                                    .symmetric(
                                                    horizontal: 11,
                                                    vertical: 8),
                                                child: Container(
                                                  decoration:
                                                  BoxDecoration(
                                                    color: Color(
                                                        0xFFdceffc), // Background color
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors
                                                            .black
                                                            .withOpacity(
                                                            0.2), // Shadow color with opacity
                                                        spreadRadius:
                                                        2, // How much the shadow spreads
                                                        blurRadius:
                                                        5, // How soft the shadow is
                                                        offset: Offset(
                                                            0,
                                                            3), // Shadow position (x, y)
                                                      ),
                                                    ],
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        20), // Optional: Add rounded corners
                                                  ),
                                                  padding: EdgeInsets.only(
                                                      left: 15,
                                                      right: 15,
                                                      top: 2,
                                                      bottom:
                                                      2), // Add padding for better appearance
                                                  child: Text(
                                                    tdPurred[index].toUpperCase(),
                                                    style: GoogleFonts
                                                        .poppins(
                                                      color: Color(
                                                          0xFF0f625c),
                                                      fontSize: 14,
                                                      fontWeight:
                                                      FontWeight
                                                          .w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: 20),
                                                child: Icon(
                                                  Icons
                                                      .calendar_month_outlined, // Calendar Icon
                                                  color: Color(
                                                      0xFF09a99d), // Change color as needed
                                                  size:
                                                  20, // Adjust size as needed
                                                ),
                                              ),
                                              SizedBox(
                                                height: 9,
                                              ),
                                              Container(
                                                  margin:
                                                  EdgeInsets.only(
                                                      left: 20),
                                                  child: Text(
                                                      tdDate[index],
                                                      style: GoogleFonts.poppins(
                                                          color: Color(
                                                              0xFF303131),
                                                          fontSize: 13,
                                                          fontWeight:
                                                          FontWeight
                                                              .w500))),
                                              SizedBox(
                                                height: 18,
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: SizedBox(
                                              height:
                                              130, // Adjust as needed
                                              child: VerticalDivider(
                                                color:
                                                Color(0xFFe5e5e5),
                                                thickness: 1,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Text(
                                                    'Amount',
                                                    style: GoogleFonts.poppins(
                                                        color: Color(
                                                            0xFF0f625c),
                                                        fontSize: 13,
                                                        fontWeight:
                                                        FontWeight
                                                            .w500),
                                                  ),
                                                  Text(
                                                    NumberFormat.currency(
                                                        locale:
                                                        'en_IN',
                                                        symbol: '₹ ')
                                                        .format(tdAmounts[
                                                    index]), // ✅ Using `index` to show the correct value
                                                    style: GoogleFonts
                                                        .poppins(
                                                      color: Color(
                                                          0xFF303131),
                                                      fontSize: 13,
                                                      fontWeight:
                                                      FontWeight
                                                          .w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Text(
                                                    'Units',
                                                    style: GoogleFonts.poppins(
                                                        color: Color(
                                                            0xFF0f625c),
                                                        fontSize: 13,
                                                        fontWeight:
                                                        FontWeight
                                                            .w500),
                                                  ),
                                                  Text(
                                                    NumberFormat.currency(
                                                        locale:
                                                        'en_IN',
                                                        symbol: '')
                                                        .format(tdUnits[
                                                    index]),
                                                    style: GoogleFonts.poppins(
                                                        color: Color(
                                                            0xFF303131),
                                                        fontSize: 13,
                                                        fontWeight:
                                                        FontWeight
                                                            .w500),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: SizedBox(
                                              height:
                                              130, // Adjust as needed
                                              child: VerticalDivider(
                                                color:
                                                Color(0xFFe5e5e5),
                                                thickness: 1,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .center,
                                                children: [
                                                  SizedBox(
                                                    height: 54,
                                                  ),
                                                  Text(
                                                    'Balance',
                                                    style: GoogleFonts.poppins(
                                                        color: Color(
                                                            0xFF0f625c),
                                                        fontSize: 13,
                                                        fontWeight:
                                                        FontWeight
                                                            .w500),
                                                  ),
                                                  Text(
                                                    NumberFormat.currency(
                                                      locale: 'en_IN', // Use 'en_US' for US format or 'en_IN' for Indian format
                                                      symbol: '', // Change the symbol as needed
                                                      decimalDigits: 2, // Number of decimal places
                                                    ).format(double.tryParse(transBalancedUnits[index].replaceAll(',', '')) ?? 0.00),
                                                    style: GoogleFonts.poppins(
                                                      color: Color(0xFF0f625c),
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                                                            },
                                                          ),
                              )
                              : Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF0f625c),
                            ),
                          ),
                        ),

                        // dynamic work end on 20.03.2025

                        // static work start on 20.03.2025

                        // Container(
                        //   margin: EdgeInsets.only(bottom: 15),
                        //   child: Padding(
                        //     padding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
                        //     child: Container(
                        //       decoration: BoxDecoration(
                        //         color: Colors.white,
                        //         borderRadius: BorderRadius.circular(10),
                        //         boxShadow: [
                        //           BoxShadow(
                        //             color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                        //             spreadRadius: 2,
                        //             blurRadius: 5,
                        //             offset: Offset(0, 3), // Shadow position (x, y)
                        //           ),
                        //         ],
                        //       ),
                        //       padding: EdgeInsets.only(right: 15),
                        //       child: SingleChildScrollView(
                        //         scrollDirection: Axis.horizontal,
                        //         child: Row(
                        //           mainAxisAlignment: MainAxisAlignment.start,
                        //           crossAxisAlignment: CrossAxisAlignment.center,
                        //           children: [
                        //             Column(
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 SizedBox(
                        //                   height: 8,
                        //                 ),
                        //                 Padding(
                        //                   padding: EdgeInsets.symmetric(horizontal: 11, vertical: 8),
                        //                   child: Container(
                        //                     decoration: BoxDecoration(
                        //                       color: Color(
                        //                           0xFFdceffc), // Background color
                        //                       boxShadow: [
                        //                         BoxShadow(
                        //                           color: Colors.black.withOpacity(
                        //                               0.2), // Shadow color with opacity
                        //                           spreadRadius:
                        //                           2, // How much the shadow spreads
                        //                           blurRadius:
                        //                           5, // How soft the shadow is
                        //                           offset: Offset(0,
                        //                               3), // Shadow position (x, y)
                        //                         ),
                        //                       ],
                        //                       borderRadius: BorderRadius.circular(
                        //                           20), // Optional: Add rounded corners
                        //                     ),
                        //                     padding: EdgeInsets.only(
                        //                         left: 12,
                        //                         right: 12,
                        //                         top: 2,
                        //                         bottom:
                        //                         2), // Add padding for better appearance
                        //                     child: Text(
                        //                       'PUR'.toUpperCase(),
                        //                       style: GoogleFonts.poppins(
                        //                         color: Color(0xFF0f625c),
                        //                         fontSize: 14,
                        //                         fontWeight: FontWeight.w500,
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ),
                        //                 SizedBox(
                        //                   height: 15,
                        //                 ),
                        //                 Container(
                        //                   margin: EdgeInsets.only(left: 20),
                        //                   child: Icon(
                        //                     Icons
                        //                         .calendar_month_outlined, // Calendar Icon
                        //                     color: Color(
                        //                         0xFF09a99d), // Change color as needed
                        //                     size: 20, // Adjust size as needed
                        //                   ),
                        //                 ),
                        //                 SizedBox(
                        //                   height: 9,
                        //                 ),
                        //                 Container(
                        //                     margin: EdgeInsets.only(left: 20),
                        //                     child: Text('27/05/25',
                        //                         style: GoogleFonts.poppins(
                        //                             color: Color(0xFF303131),
                        //                             fontSize: 13,
                        //                             fontWeight: FontWeight.w500))),
                        //                 SizedBox(
                        //                   height: 18,
                        //                 ),
                        //               ],
                        //             ),
                        //             Padding(
                        //               padding: EdgeInsets.only(left: 10,right: 10),
                        //               child: SizedBox(
                        //                 height: 130, // Adjust as needed
                        //                 child: VerticalDivider(
                        //                   color: Color(0xFFe5e5e5),
                        //                   thickness: 1,
                        //                 ),
                        //               ),
                        //             ),
                        //             Column(
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 Column(
                        //                   crossAxisAlignment: CrossAxisAlignment.start,
                        //                   children: [
                        //                     Text('Amount',style: GoogleFonts.poppins(color: Color(0xFF0f625c),fontSize: 13,fontWeight: FontWeight.w500),),
                        //                     Text('1,11,49,999.01',style: GoogleFonts.poppins(color: Color(0xFF303131),fontSize: 13,fontWeight: FontWeight.w500),),
                        //                   ],
                        //                 ),
                        //                 SizedBox(
                        //                   height: 15,
                        //                 ),
                        //                 Column(
                        //                   crossAxisAlignment: CrossAxisAlignment.start,
                        //                   children: [
                        //                     Text('Units',style: GoogleFonts.poppins(color: Color(0xFF0f625c),fontSize: 13,fontWeight: FontWeight.w500),),
                        //                     Text('1807.139',style: GoogleFonts.poppins(color: Color(0xFF303131),fontSize: 13,fontWeight: FontWeight.w500),),
                        //                   ],
                        //                 ),
                        //                 SizedBox(
                        //                   height: 10,
                        //                 ),
                        //               ],
                        //             ),
                        //             Padding(
                        //               padding: EdgeInsets.only(left: 10,right: 10),
                        //               child: SizedBox(
                        //                 height: 130, // Adjust as needed
                        //                 child: VerticalDivider(
                        //                   color: Color(0xFFe5e5e5),
                        //                   thickness: 1,
                        //                 ),
                        //               ),
                        //             ),
                        //             Column(
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 Column(
                        //                   crossAxisAlignment: CrossAxisAlignment.center,
                        //                   children: [
                        //                     Text('Balance',style: GoogleFonts.poppins(color: Color(0xFF0f625c),fontSize: 13,fontWeight: FontWeight.w500),),
                        //                     Text('15,11,49,999.05',style: GoogleFonts.poppins(color: Color(0xFF303131),fontSize: 13,fontWeight: FontWeight.w500),),
                        //                   ],
                        //                 ),
                        //                 SizedBox(
                        //                   height: 10,
                        //                 ),
                        //               ],
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),

                        // static work end on 20.03.2025

                        // Container(
                        //   margin: EdgeInsets.only(bottom: 15),
                        //   child: Padding(
                        //     padding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
                        //     child: Container(
                        //       decoration: BoxDecoration(
                        //         color: Colors.white,
                        //         borderRadius: BorderRadius.circular(10),
                        //         boxShadow: [
                        //           BoxShadow(
                        //             color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                        //             spreadRadius: 2,
                        //             blurRadius: 5,
                        //             offset: Offset(0, 3), // Shadow position (x, y)
                        //           ),
                        //         ],
                        //       ),
                        //       padding: EdgeInsets.only(right: 15),
                        //       child: SingleChildScrollView(
                        //         scrollDirection: Axis.horizontal,
                        //         child: Row(
                        //           mainAxisAlignment: MainAxisAlignment.start,
                        //           crossAxisAlignment: CrossAxisAlignment.center,
                        //           children: [
                        //             Column(
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 SizedBox(
                        //                   height: 8,
                        //                 ),
                        //                 Padding(
                        //                   padding: EdgeInsets.symmetric(horizontal: 11, vertical: 8),
                        //                   child: Container(
                        //                     decoration: BoxDecoration(
                        //                       color: Color(
                        //                           0xFFdceffc), // Background color
                        //                       boxShadow: [
                        //                         BoxShadow(
                        //                           color: Colors.black.withOpacity(
                        //                               0.2), // Shadow color with opacity
                        //                           spreadRadius:
                        //                           2, // How much the shadow spreads
                        //                           blurRadius:
                        //                           5, // How soft the shadow is
                        //                           offset: Offset(0,
                        //                               3), // Shadow position (x, y)
                        //                         ),
                        //                       ],
                        //                       borderRadius: BorderRadius.circular(
                        //                           20), // Optional: Add rounded corners
                        //                     ),
                        //                     padding: EdgeInsets.only(
                        //                         left: 12,
                        //                         right: 12,
                        //                         top: 2,
                        //                         bottom:
                        //                         2), // Add padding for better appearance
                        //                     child: Text(
                        //                       'PUR'.toUpperCase(),
                        //                       style: GoogleFonts.poppins(
                        //                         color: Color(0xFF0f625c),
                        //                         fontSize: 14,
                        //                         fontWeight: FontWeight.w500,
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ),
                        //                 SizedBox(
                        //                   height: 15,
                        //                 ),
                        //                 Container(
                        //                   margin: EdgeInsets.only(left: 20),
                        //                   child: Icon(
                        //                     Icons
                        //                         .calendar_month_outlined, // Calendar Icon
                        //                     color: Color(
                        //                         0xFF09a99d), // Change color as needed
                        //                     size: 20, // Adjust size as needed
                        //                   ),
                        //                 ),
                        //                 SizedBox(
                        //                   height: 9,
                        //                 ),
                        //                 Container(
                        //                     margin: EdgeInsets.only(left: 20),
                        //                     child: Text('27/05/25',
                        //                         style: GoogleFonts.poppins(
                        //                             color: Color(0xFF303131),
                        //                             fontSize: 13,
                        //                             fontWeight: FontWeight.w500))),
                        //                 SizedBox(
                        //                   height: 18,
                        //                 ),
                        //               ],
                        //             ),
                        //             Padding(
                        //               padding: EdgeInsets.only(left: 10,right: 10),
                        //               child: SizedBox(
                        //                 height: 130, // Adjust as needed
                        //                 child: VerticalDivider(
                        //                   color: Color(0xFFe5e5e5),
                        //                   thickness: 1,
                        //                 ),
                        //               ),
                        //             ),
                        //             Column(
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 Column(
                        //                   crossAxisAlignment: CrossAxisAlignment.start,
                        //                   children: [
                        //                     Text('Amount',style: GoogleFonts.poppins(color: Color(0xFF0f625c),fontSize: 13,fontWeight: FontWeight.w500),),
                        //                     Text('1,11,49,999.01',style: GoogleFonts.poppins(color: Color(0xFF303131),fontSize: 13,fontWeight: FontWeight.w500),),
                        //                   ],
                        //                 ),
                        //                 SizedBox(
                        //                   height: 15,
                        //                 ),
                        //                 Column(
                        //                   crossAxisAlignment: CrossAxisAlignment.start,
                        //                   children: [
                        //                     Text('Units',style: GoogleFonts.poppins(color: Color(0xFF0f625c),fontSize: 13,fontWeight: FontWeight.w500),),
                        //                     Text('1807.139',style: GoogleFonts.poppins(color: Color(0xFF303131),fontSize: 13,fontWeight: FontWeight.w500),),
                        //                   ],
                        //                 ),
                        //                 SizedBox(
                        //                   height: 10,
                        //                 ),
                        //               ],
                        //             ),
                        //             Padding(
                        //               padding: EdgeInsets.only(left: 10,right: 10),
                        //               child: SizedBox(
                        //                 height: 130, // Adjust as needed
                        //                 child: VerticalDivider(
                        //                   color: Color(0xFFe5e5e5),
                        //                   thickness: 1,
                        //                 ),
                        //               ),
                        //             ),
                        //             Column(
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 Column(
                        //                   crossAxisAlignment: CrossAxisAlignment.center,
                        //                   children: [
                        //                     Text('Balance',style: GoogleFonts.poppins(color: Color(0xFF0f625c),fontSize: 13,fontWeight: FontWeight.w500),),
                        //                     Text('15,11,49,999.05',style: GoogleFonts.poppins(color: Color(0xFF303131),fontSize: 13,fontWeight: FontWeight.w500),),
                        //                   ],
                        //                 ),
                        //                 SizedBox(
                        //                   height: 10,
                        //                 ),
                        //               ],
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // Container(
                        //   margin: EdgeInsets.only(bottom: 15),
                        //   child: Padding(
                        //     padding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
                        //     child: Container(
                        //       decoration: BoxDecoration(
                        //         color: Colors.white,
                        //         borderRadius: BorderRadius.circular(10),
                        //         boxShadow: [
                        //           BoxShadow(
                        //             color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                        //             spreadRadius: 2,
                        //             blurRadius: 5,
                        //             offset: Offset(0, 3), // Shadow position (x, y)
                        //           ),
                        //         ],
                        //       ),
                        //       padding: EdgeInsets.only(right: 15),
                        //       child: SingleChildScrollView(
                        //         scrollDirection: Axis.horizontal,
                        //         child: Row(
                        //           mainAxisAlignment: MainAxisAlignment.start,
                        //           crossAxisAlignment: CrossAxisAlignment.center,
                        //           children: [
                        //             Column(
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 SizedBox(
                        //                   height: 8,
                        //                 ),
                        //                 Padding(
                        //                   padding: EdgeInsets.symmetric(horizontal: 11, vertical: 8),
                        //                   child: Container(
                        //                     decoration: BoxDecoration(
                        //                       color: Color(
                        //                           0xFFdceffc), // Background color
                        //                       boxShadow: [
                        //                         BoxShadow(
                        //                           color: Colors.black.withOpacity(
                        //                               0.2), // Shadow color with opacity
                        //                           spreadRadius:
                        //                           2, // How much the shadow spreads
                        //                           blurRadius:
                        //                           5, // How soft the shadow is
                        //                           offset: Offset(0,
                        //                               3), // Shadow position (x, y)
                        //                         ),
                        //                       ],
                        //                       borderRadius: BorderRadius.circular(
                        //                           20), // Optional: Add rounded corners
                        //                     ),
                        //                     padding: EdgeInsets.only(
                        //                         left: 12,
                        //                         right: 12,
                        //                         top: 2,
                        //                         bottom:
                        //                         2), // Add padding for better appearance
                        //                     child: Text(
                        //                       'PUR'.toUpperCase(),
                        //                       style: GoogleFonts.poppins(
                        //                         color: Color(0xFF0f625c),
                        //                         fontSize: 14,
                        //                         fontWeight: FontWeight.w500,
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ),
                        //                 SizedBox(
                        //                   height: 15,
                        //                 ),
                        //                 Container(
                        //                   margin: EdgeInsets.only(left: 20),
                        //                   child: Icon(
                        //                     Icons
                        //                         .calendar_month_outlined, // Calendar Icon
                        //                     color: Color(
                        //                         0xFF09a99d), // Change color as needed
                        //                     size: 20, // Adjust size as needed
                        //                   ),
                        //                 ),
                        //                 SizedBox(
                        //                   height: 9,
                        //                 ),
                        //                 Container(
                        //                     margin: EdgeInsets.only(left: 20),
                        //                     child: Text('27/05/25',
                        //                         style: GoogleFonts.poppins(
                        //                             color: Color(0xFF303131),
                        //                             fontSize: 13,
                        //                             fontWeight: FontWeight.w500))),
                        //                 SizedBox(
                        //                   height: 18,
                        //                 ),
                        //               ],
                        //             ),
                        //             Padding(
                        //               padding: EdgeInsets.only(left: 10,right: 10),
                        //               child: SizedBox(
                        //                 height: 130, // Adjust as needed
                        //                 child: VerticalDivider(
                        //                   color: Color(0xFFe5e5e5),
                        //                   thickness: 1,
                        //                 ),
                        //               ),
                        //             ),
                        //             Column(
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 Column(
                        //                   crossAxisAlignment: CrossAxisAlignment.start,
                        //                   children: [
                        //                     Text('Amount',style: GoogleFonts.poppins(color: Color(0xFF0f625c),fontSize: 13,fontWeight: FontWeight.w500),),
                        //                     Text('1,11,49,999.01',style: GoogleFonts.poppins(color: Color(0xFF303131),fontSize: 13,fontWeight: FontWeight.w500),),
                        //                   ],
                        //                 ),
                        //                 SizedBox(
                        //                   height: 15,
                        //                 ),
                        //                 Column(
                        //                   crossAxisAlignment: CrossAxisAlignment.start,
                        //                   children: [
                        //                     Text('Units',style: GoogleFonts.poppins(color: Color(0xFF0f625c),fontSize: 13,fontWeight: FontWeight.w500),),
                        //                     Text('1807.139',style: GoogleFonts.poppins(color: Color(0xFF303131),fontSize: 13,fontWeight: FontWeight.w500),),
                        //                   ],
                        //                 ),
                        //                 SizedBox(
                        //                   height: 10,
                        //                 ),
                        //               ],
                        //             ),
                        //             Padding(
                        //               padding: EdgeInsets.only(left: 10,right: 10),
                        //               child: SizedBox(
                        //                 height: 130, // Adjust as needed
                        //                 child: VerticalDivider(
                        //                   color: Color(0xFFe5e5e5),
                        //                   thickness: 1,
                        //                 ),
                        //               ),
                        //             ),
                        //             Column(
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 Column(
                        //                   crossAxisAlignment: CrossAxisAlignment.center,
                        //                   children: [
                        //                     Text('Balance',style: GoogleFonts.poppins(color: Color(0xFF0f625c),fontSize: 13,fontWeight: FontWeight.w500),),
                        //                     Text('15,11,49,999.05',style: GoogleFonts.poppins(color: Color(0xFF303131),fontSize: 13,fontWeight: FontWeight.w500),),
                        //                   ],
                        //                 ),
                        //                 SizedBox(
                        //                   height: 10,
                        //                 ),
                        //               ],
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    // Container(
                    //   margin: EdgeInsets.only(top: 20),
                    //   child: Row(
                    //     spacing: 10,
                    //     children: [
                    //       SizedBox(
                    //         width: 165,
                    //         child: Column(
                    //           children: [
                    //             Row(
                    //               spacing: 10,
                    //               children: [
                    //                 SizedBox(
                    //                   width: 48,
                    //                   height: 48,
                    //                   child: Container(
                    //                     decoration: BoxDecoration(
                    //                       borderRadius:
                    //                           BorderRadius.circular(8),
                    //                       color: Color(0xFFf9eddb),
                    //                     ),
                    //                     child: Center(
                    //                         child: Image.asset(
                    //                             'assets/images/ech_dlr.png')), // Replace 'Colors.red' with your desired color
                    //                   ),
                    //                 ),
                    //                 Text(
                    //                   'Invested',
                    //                   style: GoogleFonts.poppins(
                    //                       color: Color(0xFF0f625c),
                    //                       fontSize: 16,
                    //                       fontWeight: FontWeight.w500),
                    //                 ),
                    //               ],
                    //             ),
                    //             SizedBox(
                    //               height: 10,
                    //             ),
                    //             Row(
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceBetween,
                    //               children: [
                    //                 Text(
                    //                   'Lumsum',
                    //                   style: GoogleFonts.poppins(
                    //                       color: Color(0xFF8c8c8c),
                    //                       fontWeight: FontWeight.w500,
                    //                       fontSize: 14),
                    //                 ),
                    //                 Text(
                    //                   '5,00,000',
                    //                   style: GoogleFonts.poppins(
                    //                       color: Color(0xFF303131),
                    //                       fontWeight: FontWeight.w500,
                    //                       fontSize: 14),
                    //                 ),
                    //               ],
                    //             ),
                    //             Row(
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceBetween,
                    //               children: [
                    //                 Text(
                    //                   'SIP',
                    //                   style: GoogleFonts.poppins(
                    //                       color: Color(0xFF8c8c8c),
                    //                       fontWeight: FontWeight.w500,
                    //                       fontSize: 14),
                    //                 ),
                    //                 Text(
                    //                   '0',
                    //                   style: GoogleFonts.poppins(
                    //                       color: Color(0xFF303131),
                    //                       fontWeight: FontWeight.w500,
                    //                       fontSize: 14),
                    //                 ),
                    //               ],
                    //             ),
                    //             Row(
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceBetween,
                    //               children: [
                    //                 Text(
                    //                   'Switch-Ins',
                    //                   style: GoogleFonts.poppins(
                    //                       color: Color(0xFF8c8c8c),
                    //                       fontWeight: FontWeight.w500,
                    //                       fontSize: 14),
                    //                 ),
                    //                 Text(
                    //                   '0',
                    //                   style: GoogleFonts.poppins(
                    //                       color: Color(0xFF303131),
                    //                       fontWeight: FontWeight.w500,
                    //                       fontSize: 14),
                    //                 ),
                    //               ],
                    //             ),
                    //             Row(
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceBetween,
                    //               children: [
                    //                 Text(
                    //                   'Dividends',
                    //                   style: GoogleFonts.poppins(
                    //                       color: Color(0xFF8c8c8c),
                    //                       fontWeight: FontWeight.w500,
                    //                       fontSize: 14),
                    //                 ),
                    //                 Text(
                    //                   '0',
                    //                   style: GoogleFonts.poppins(
                    //                       color: Color(0xFF303131),
                    //                       fontWeight: FontWeight.w500,
                    //                       fontSize: 14),
                    //                 ),
                    //               ],
                    //             ),
                    //             Container(
                    //               margin: EdgeInsets.only(top: 10, bottom: 10),
                    //               color: Color(0xFFcbd2d0),
                    //               height: 1,
                    //             ),
                    //             Row(
                    //               mainAxisAlignment: MainAxisAlignment.end,
                    //               children: [
                    //                 Text(
                    //                   '5,00,000',
                    //                   style: GoogleFonts.poppins(
                    //                       color: Color(0xFF303131),
                    //                       fontWeight: FontWeight.w500,
                    //                       fontSize: 14),
                    //                 ),
                    //               ],
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       SizedBox(
                    //         height: 168,
                    //         width: 1,
                    //         child: Container(
                    //           color: Color(
                    //               0xFFcbd2d0), // Replace 'Colors.red' with your desired color
                    //         ),
                    //       ),
                    //       SizedBox(
                    //         width: 165,
                    //         child: Column(
                    //           children: [
                    //             Row(
                    //               spacing: 10,
                    //               children: [
                    //                 SizedBox(
                    //                   width: 48,
                    //                   height: 48,
                    //                   child: Container(
                    //                     decoration: BoxDecoration(
                    //                       borderRadius:
                    //                           BorderRadius.circular(8),
                    //                       color: Color(0xFFb0daf4),
                    //                     ),
                    //                     child: Center(
                    //                         child: Image.asset(
                    //                             'assets/images/inv_tx.png')), // Replace 'Colors.red' with your desired color
                    //                   ),
                    //                 ),
                    //                 Text(
                    //                   'Received',
                    //                   style: GoogleFonts.poppins(
                    //                       color: Color(0xFF0f625c),
                    //                       fontSize: 16,
                    //                       fontWeight: FontWeight.w500),
                    //                 ),
                    //               ],
                    //             ),
                    //             SizedBox(
                    //               height: 10,
                    //             ),
                    //             Row(
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceBetween,
                    //               children: [
                    //                 Text(
                    //                   'Dividends',
                    //                   style: GoogleFonts.poppins(
                    //                       color: Color(0xFF8c8c8c),
                    //                       fontWeight: FontWeight.w500,
                    //                       fontSize: 14),
                    //                 ),
                    //                 Text(
                    //                   '0',
                    //                   style: GoogleFonts.poppins(
                    //                       color: Color(0xFF303131),
                    //                       fontWeight: FontWeight.w500,
                    //                       fontSize: 14),
                    //                 ),
                    //               ],
                    //             ),
                    //             Row(
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceBetween,
                    //               children: [
                    //                 Text(
                    //                   'Redemptions',
                    //                   style: GoogleFonts.poppins(
                    //                       color: Color(0xFF8c8c8c),
                    //                       fontWeight: FontWeight.w500,
                    //                       fontSize: 14),
                    //                 ),
                    //                 Text(
                    //                   '0',
                    //                   style: GoogleFonts.poppins(
                    //                       color: Color(0xFF303131),
                    //                       fontWeight: FontWeight.w500,
                    //                       fontSize: 14),
                    //                 ),
                    //               ],
                    //             ),
                    //             Row(
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceBetween,
                    //               children: [
                    //                 Text(
                    //                   'Switch-Outs',
                    //                   style: GoogleFonts.poppins(
                    //                       color: Color(0xFF8c8c8c),
                    //                       fontWeight: FontWeight.w500,
                    //                       fontSize: 14),
                    //                 ),
                    //                 Text(
                    //                   '0',
                    //                   style: GoogleFonts.poppins(
                    //                       color: Color(0xFF303131),
                    //                       fontWeight: FontWeight.w500,
                    //                       fontSize: 14),
                    //                 ),
                    //               ],
                    //             ),
                    //             Row(
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceBetween,
                    //               children: [
                    //                 Text(
                    //                   'SWP',
                    //                   style: GoogleFonts.poppins(
                    //                       color: Color(0xFF8c8c8c),
                    //                       fontWeight: FontWeight.w500,
                    //                       fontSize: 14),
                    //                 ),
                    //                 Text(
                    //                   '0',
                    //                   style: GoogleFonts.poppins(
                    //                       color: Color(0xFF303131),
                    //                       fontWeight: FontWeight.w500,
                    //                       fontSize: 14),
                    //                 ),
                    //               ],
                    //             ),
                    //             Container(
                    //               margin: EdgeInsets.only(top: 10, bottom: 10),
                    //               color: Color(0xFFcbd2d0),
                    //               height: 1,
                    //             ),
                    //             Row(
                    //               mainAxisAlignment: MainAxisAlignment.end,
                    //               children: [
                    //                 Text(
                    //                   '0',
                    //                   style: GoogleFonts.poppins(
                    //                       color: Color(0xFF303131),
                    //                       fontWeight: FontWeight.w500,
                    //                       fontSize: 14),
                    //                 ),
                    //               ],
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Container(
                    //   margin: EdgeInsets.only(top: 20),
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(15),
                    //     color: Colors.white,
                    //   ),
                    //   width: double.infinity,
                    //   child: Padding(
                    //     padding: EdgeInsets.all(20),
                    //     child: SingleChildScrollView(
                    //       scrollDirection: Axis.horizontal,
                    //       child: Row(
                    //         spacing: 20,
                    //         children: [
                    //           Column(
                    //             children: [
                    //               Text(
                    //                 'Balance\nUnits',
                    //                 style: GoogleFonts.poppins(
                    //                     color: Color(0xFF8c8c8c),
                    //                     fontSize: 14,
                    //                     fontWeight: FontWeight.w500),
                    //               ),
                    //               SizedBox(
                    //                 height: 5,
                    //               ),
                    //               Text(
                    //                 '7,534,163',
                    //                 style: GoogleFonts.poppins(
                    //                     color: Color(0xFF0f625c),
                    //                     fontSize: 14,
                    //                     fontWeight: FontWeight.w600),
                    //               ),
                    //             ],
                    //           ),
                    //           Column(
                    //             children: [
                    //               Text(
                    //                 'Average\nNAV',
                    //                 style: GoogleFonts.poppins(
                    //                     color: Color(0xFF8c8c8c),
                    //                     fontSize: 14,
                    //                     fontWeight: FontWeight.w500),
                    //               ),
                    //               SizedBox(
                    //                 height: 5,
                    //               ),
                    //               Text(
                    //                 '6,63,600',
                    //                 style: GoogleFonts.poppins(
                    //                     color: Color(0xFF0f625c),
                    //                     fontSize: 14,
                    //                     fontWeight: FontWeight.w600),
                    //               ),
                    //             ],
                    //           ),
                    //           Column(
                    //             children: [
                    //               Text(
                    //                 'Cost\nAmount',
                    //                 style: GoogleFonts.poppins(
                    //                     color: Color(0xFF8c8c8c),
                    //                     fontSize: 14,
                    //                     fontWeight: FontWeight.w500),
                    //               ),
                    //               SizedBox(
                    //                 height: 5,
                    //               ),
                    //               Text(
                    //                 '₹ ${double.tryParse(widget.scheme['invested_val']?.toString() ?? '0')?.toStringAsFixed(2) ?? '0.00'}',
                    //                 style: GoogleFonts.poppins(
                    //                     color: Color(0xFF0f625c),
                    //                     fontSize: 14,
                    //                     fontWeight: FontWeight.w600),
                    //               ),
                    //             ],
                    //           ),
                    //           Column(
                    //             children: [
                    //               Text(
                    //                 'Present\nValue',
                    //                 style: GoogleFonts.poppins(
                    //                     color: Color(0xFF8c8c8c),
                    //                     fontSize: 14,
                    //                     fontWeight: FontWeight.w500),
                    //               ),
                    //               SizedBox(
                    //                 height: 5,
                    //               ),
                    //               // Text('${widget.scheme['current_val']?.toString() ?? 'N/A'}',style: GoogleFonts.poppins(color: Color(0xFF0f625c),fontSize: 14,fontWeight: FontWeight.w600),),
                    //               Text(
                    //                 '₹ ${double.tryParse(widget.scheme['current_val']?.toString() ?? '0')?.toStringAsFixed(2) ?? '0.00'}',
                    //                 style: GoogleFonts.poppins(
                    //                     color: Color(0xFF0f625c),
                    //                     fontSize: 14,
                    //                     fontWeight: FontWeight.w600),
                    //               ),
                    //             ],
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   margin: EdgeInsets.only(bottom: 20, top: 20),
                    //   child: Wrap(
                    //     spacing: 12,
                    //     runSpacing: 28,
                    //     children: [
                    //       InkWell(
                    //         onTap: () {
                    //           // Define your action here
                    //           print("New Fund Offer button pressed");
                    //         },
                    //         borderRadius: BorderRadius.circular(
                    //             8), // Add ripple effect matching the button shape
                    //         child: Container(
                    //           width: 100,
                    //           padding: const EdgeInsets.symmetric(
                    //               vertical: 10), // Optional padding
                    //           child: Column(
                    //             crossAxisAlignment: CrossAxisAlignment.center,
                    //             children: [
                    //               Container(
                    //                 width: 50,
                    //                 height: 50,
                    //                 decoration: const BoxDecoration(
                    //                   color: Color(0xFFb2daf4),
                    //                   borderRadius:
                    //                       BorderRadius.all(Radius.circular(8)),
                    //                 ),
                    //                 child: Center(
                    //                   child: Image.asset(
                    //                       'assets/images/nw_fnd.png'),
                    //                 ),
                    //               ),
                    //               const SizedBox(height: 10),
                    //               Text(
                    //                 'Realized Gain',
                    //                 style: GoogleFonts.poppins(
                    //                   color: const Color(0xFF0f625c),
                    //                   fontSize: 14,
                    //                   fontWeight: FontWeight.w400,
                    //                 ),
                    //                 textAlign: TextAlign.center,
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //       Container(
                    //         width: 1,
                    //         height: 100,
                    //         color: Color(0xFFc7d1d0),
                    //       ),
                    //       InkWell(
                    //         onTap: () {
                    //           // Define your action here
                    //           print("New Fund Offer button pressed");
                    //         },
                    //         borderRadius: BorderRadius.circular(8),
                    //         child: SizedBox(
                    //           width: 100,
                    //           child: Column(
                    //             crossAxisAlignment: CrossAxisAlignment.center,
                    //             children: [
                    //               Container(
                    //                 width: 50,
                    //                 height: 50,
                    //                 decoration: BoxDecoration(
                    //                   color: Color(0xFFefecdb),
                    //                   borderRadius:
                    //                       BorderRadius.all(Radius.circular(8)),
                    //                 ),
                    //                 child: Center(
                    //                   child: Image.asset(
                    //                       'assets/images/thm_invst.png'),
                    //                 ),
                    //               ),
                    //               SizedBox(
                    //                 height: 10,
                    //               ),
                    //               Text(
                    //                 'Unrealized Gain',
                    //                 style: GoogleFonts.poppins(
                    //                   color: Color(0xFF0f625c),
                    //                   fontSize: 14,
                    //                   fontWeight: FontWeight.w400,
                    //                 ),
                    //                 textAlign: TextAlign.center,
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //       Container(
                    //         width: 1,
                    //         height: 100,
                    //         color: Color(0xFFc7d1d0),
                    //       ),
                    //       InkWell(
                    //         onTap: () {
                    //           // Define your action here
                    //           print("New Fund Offer button pressed");
                    //         },
                    //         borderRadius: BorderRadius.circular(8),
                    //         child: SizedBox(
                    //           width: 100,
                    //           child: Column(
                    //             crossAxisAlignment: CrossAxisAlignment.center,
                    //             children: [
                    //               Container(
                    //                 width: 50,
                    //                 height: 50,
                    //                 decoration: BoxDecoration(
                    //                   color: Color(0xFFa5d9d5),
                    //                   borderRadius:
                    //                       BorderRadius.all(Radius.circular(8)),
                    //                 ),
                    //                 child: Center(
                    //                   child: Image.asset(
                    //                       'assets/images/int_mtfnd.png'),
                    //                 ),
                    //               ),
                    //               SizedBox(
                    //                 height: 10,
                    //               ),
                    //               Text(
                    //                 'Overall Gain',
                    //                 style: GoogleFonts.poppins(
                    //                   color: Color(0xFF0f625c),
                    //                   fontSize: 14,
                    //                   fontWeight: FontWeight.w400,
                    //                 ),
                    //                 textAlign: TextAlign.center,
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    // each fund investment details end 20.03.2025

                    SizedBox(height: 20),
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

  String calculateGainLoss(dynamic currentVal, dynamic investedVal) {
    double current = double.tryParse(currentVal?.toString() ?? '0') ?? 0.0;
    double invested = double.tryParse(investedVal?.toString() ?? '0') ?? 0.0;
    double difference = current - invested; // Calculate gain/loss

    return difference.toStringAsFixed(2); // Format to 2 decimal places
  }
}
