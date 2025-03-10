import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'family_scheme_details.dart';
import 'individual_portfolio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class familyPortfolioPage extends StatefulWidget {
  const familyPortfolioPage({super.key});

  @override
  State<familyPortfolioPage> createState() => _familyPortfolioPageState();
}

class _familyPortfolioPageState extends State<familyPortfolioPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String activeTile = 'Home';
  String userName = "Loading...";
  String userCurrentValue = "Loading...";
  String userTotalGain = "Loading...";
  String userInvestedValue = "Loading...";

  @override
  void initState() {
    super.initState();
    fetchUserName();
    fetchUserCurrentValue();
    fetchUserTotalGain();
    // fetchUserDtlsPopUp();
    fetchUserInvestedValue();
  }

  Future<void> fetchUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');
    const String apiUrl = 'https://wealthclockadvisors.com/api/client/dashboard';

    if (authToken == null || authToken.isEmpty) {
      setState(() {
        userName = "Auth token not found!";
      });
      return;
    }

    try {
      print("Auth Token: $authToken"); // Debugging: Check if token exists

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      print("Response Status Code: ${response.statusCode}");
      print("Full Response: ${response.body}");

      final String responseBody = response.body.trim();

      if (response.statusCode == 200) {
        if (responseBody.isNotEmpty && (responseBody.startsWith('{') || responseBody.startsWith('['))) {
          final Map<String, dynamic> data = json.decode(responseBody);
          print("Parsed Data: $data");

          if (data.containsKey("clientData") && data["clientData"] is List) {
            if (data["clientData"].isEmpty) {
              print("clientData is empty. Setting userName to blank.");
              setState(() {
                userName = ""; // If clientData is empty, show blank string
              });
              return;
            }

            String? fetchedName = data["clientData"][0]["user_name"];
            String? fetchedPan = data["clientData"][0]["pan"];

            print("Fetched Name: $fetchedName");
            print("Fetched PAN: $fetchedPan");

            setState(() {
              if (fetchedPan == null || fetchedPan.isEmpty) {
                userName = ""; // PAN is missing, set userName to blank
              } else {
                userName = fetchedName ?? "No Name Found";
              }
            });
          } else {
            setState(() {
              userName = "Invalid data format";
            });
          }
        } else {
          setState(() {
            userName = "Invalid response format (Not JSON)";
          });
        }
      } else if (response.statusCode == 400) {
        final Map<String, dynamic> data = json.decode(responseBody);
        String errorMessage = data["message"] ?? "Bad Request";

        print("Received 400 Error: $errorMessage");

        setState(() {
          if (errorMessage.toLowerCase().contains("sorry user pan does not exist")) {
            print("Detected 'sorry user pan does not exist'. Setting userName to blank.");
            userName = ""; // If error message contains this phrase, set blank
          } else {
            userName = errorMessage;
          }
        });
      } else if (response.statusCode == 401) {
        setState(() {
          userName = "Unauthorized: Please login again!";
        });
      } else {
        setState(() {
          userName = "Error ${response.statusCode}: Something went wrong!";
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        userName = "Error fetching data!";
      });
    }
  }
  Future<void> fetchUserCurrentValue() async {
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');
    const String apiUrl = 'https://wealthclockadvisors.com/api/client/dashboard';

    if (authToken == null || authToken.isEmpty) {
      setState(() {
        userCurrentValue = "Auth token not found!";
      });
      return;
    }

    try {
      print("Auth Token: $authToken");
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      print("Response Status Code: ${response.statusCode}");
      print("Raw Response Body: '${response.body}'");

      final String responseBody = response.body.trim();

      if (response.statusCode == 200) {
        if (responseBody.isNotEmpty && (responseBody.startsWith('{') || responseBody.startsWith('['))) {
          try {
            final Map<String, dynamic> data = json.decode(responseBody);
            print("Parsed Data: $data");

            if (data.containsKey("clientData") && data["clientData"] is List && data["clientData"].isNotEmpty) {
              String? fetchedPan = data["clientData"][0]["pan"];

              // If PAN does not exist, return "0.00"
              if (fetchedPan == null || fetchedPan.isEmpty) {
                print("PAN does not exist. Setting userCurrentValue to 0.00");
                setState(() {
                  userCurrentValue = "0.00";
                });
                return;
              }

              double totalGain = (data["clientData"][0]["total_current_val"] ?? 0).toDouble();

              // Ensure totalGain is not negative or NaN
              if (totalGain.isNaN || totalGain < 0) {
                totalGain = 0;
              }

              String formattedTotalGain = NumberFormat('#,##0.00').format(totalGain);

              setState(() {
                userCurrentValue = formattedTotalGain;
              });
            } else {
              setState(() {
                userCurrentValue = "0.00"; // If clientData is missing, return "0.00"
              });
            }
          } catch (e) {
            print("Error decoding JSON: $e");
            setState(() {
              userCurrentValue = "0.00"; // Default to "0.00" on JSON error
            });
          }
        } else {
          setState(() {
            userCurrentValue = "0.00"; // Response not JSON, default to "0.00"
          });
        }
      } else if (response.statusCode == 400) {
        final Map<String, dynamic> data = json.decode(responseBody);
        String errorMessage = data["message"] ?? "";

        if (errorMessage.toLowerCase().contains("sorry user pan does not exist")) {
          print("Detected 'sorry user pan does not exist'. Setting userCurrentValue to 0.00");
          setState(() {
            userCurrentValue = "0.00"; // If PAN is missing, return "0.00"
          });
        } else {
          setState(() {
            userCurrentValue = errorMessage;
          });
        }
      } else if (response.statusCode == 401) {
        setState(() {
          userCurrentValue = "Unauthorized: Please login again!";
        });
      } else {
        setState(() {
          userCurrentValue = "Error ${response.statusCode}: Something went wrong!";
        });
      }
    } catch (e) {
      print("Exception caught: $e");
      setState(() {
        userCurrentValue = "0.00"; // Default to "0.00" on any exception
      });
    }
  }
  Future<void> fetchUserTotalGain() async {
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');
    const String apiUrl = 'https://wealthclockadvisors.com/api/client/dashboard';

    if (authToken == null || authToken.isEmpty) {
      setState(() {
        userTotalGain = "Auth token not found!";
        isZero = true;
      });
      return;
    }

    try {
      print("Auth Token: $authToken");
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      print("Response Status Code: ${response.statusCode}");
      print("Raw Response Body: '${response.body}'");

      final String responseBody = response.body.trim();

      if (response.statusCode == 200) {
        if (responseBody.isNotEmpty && (responseBody.startsWith('{') || responseBody.startsWith('['))) {
          try {
            final Map<String, dynamic> data = json.decode(responseBody);
            print("Parsed Data: $data");

            if (data.containsKey("clientData") && data["clientData"] is List && data["clientData"].isNotEmpty) {
              String? fetchedPan = data["clientData"][0]["pan"];

              if (fetchedPan == null || fetchedPan.isEmpty) {
                print("PAN does not exist. Setting userTotalGain to 0.00");
                setState(() {
                  userTotalGain = "0.00";
                  isGainPositive = true;
                  isZero = true;
                });
                return;
              }

              double totalGain = (data["clientData"][0]["totalGain"] ?? 0).toDouble();

              if (totalGain.isNaN) {
                totalGain = 0;
              }

              String formattedTotalGain = NumberFormat('#,##0.00').format(totalGain);

              setState(() {
                userTotalGain = formattedTotalGain;
                isGainPositive = totalGain > 0; // True if positive, false if negative
                isZero = totalGain == 0; // True if 0.00
              });
            } else {
              setState(() {
                userTotalGain = "0.00";
                isGainPositive = true;
                isZero = true;
              });
            }
          } catch (e) {
            print("Error decoding JSON: $e");
            setState(() {
              userTotalGain = "0.00";
              isGainPositive = true;
              isZero = true;
            });
          }
        } else {
          setState(() {
            userTotalGain = "0.00";
            isGainPositive = true;
            isZero = true;
          });
        }
      } else if (response.statusCode == 400) {
        final Map<String, dynamic> data = json.decode(responseBody);
        String errorMessage = data["message"] ?? "";

        if (errorMessage.toLowerCase().contains("sorry user pan does not exist")) {
          print("Detected 'sorry user pan does not exist'. Setting userTotalGain to 0.00");
          setState(() {
            userTotalGain = "0.00";
            isGainPositive = true;
            isZero = true;
          });
        } else {
          setState(() {
            userTotalGain = errorMessage;
            isGainPositive = false;
            isZero = false;
          });
        }
      } else if (response.statusCode == 401) {
        setState(() {
          userTotalGain = "Unauthorized: Please login again!";
          isGainPositive = false;
          isZero = false;
        });
      } else {
        setState(() {
          userTotalGain = "Error ${response.statusCode}: Something went wrong!";
          isGainPositive = false;
          isZero = false;
        });
      }
    } catch (e) {
      print("Exception caught: $e");
      setState(() {
        userTotalGain = "0.00";
        isGainPositive = true;
        isZero = true;
      });
    }
  }
  Future<void> fetchUserInvestedValue() async {
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');
    const String apiUrl = 'https://wealthclockadvisors.com/api/client/dashboard';

    if (authToken == null || authToken.isEmpty) {
      setState(() {
        userInvestedValue = "Auth token not found!";
      });
      return;
    }

    try {
      print("Auth Token: $authToken");
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      print("Response Status Code: ${response.statusCode}");
      print("Raw Response Body: '${response.body}'");

      final String responseBody = response.body.trim();

      if (response.statusCode == 200) {
        if (responseBody.isNotEmpty && (responseBody.startsWith('{') || responseBody.startsWith('['))) {
          try {
            final Map<String, dynamic> data = json.decode(responseBody);
            print("Parsed Data: $data");

            if (data.containsKey("clientData") && data["clientData"] is List && data["clientData"].isNotEmpty) {
              String? fetchedPan = data["clientData"][0]["pan"];

              // If PAN does not exist, return "0.00"
              if (fetchedPan == null || fetchedPan.isEmpty) {
                print("PAN does not exist. Setting userInvestedValue to 0.00");
                setState(() {
                  userInvestedValue = "0.00";
                });
                return;
              }

              double totalGain = (data["clientData"][0]["total_invested_val"] ?? 0).toDouble();

              // Ensure totalGain is not negative or NaN
              if (totalGain.isNaN || totalGain < 0) {
                totalGain = 0;
              }

              String formattedTotalGain = NumberFormat('#,##0.00').format(totalGain);

              setState(() {
                userInvestedValue = formattedTotalGain;
              });
            } else {
              setState(() {
                userInvestedValue = "0.00"; // If clientData is missing, return "0.00"
              });
            }
          } catch (e) {
            print("Error decoding JSON: $e");
            setState(() {
              userInvestedValue = "0.00"; // Default to "0.00" on JSON error
            });
          }
        } else {
          setState(() {
            userInvestedValue = "0.00"; // Response not JSON, default to "0.00"
          });
        }
      } else if (response.statusCode == 400) {
        final Map<String, dynamic> data = json.decode(responseBody);
        String errorMessage = data["message"] ?? "";

        if (errorMessage.toLowerCase().contains("sorry user pan does not exist")) {
          print("Detected 'sorry user pan does not exist'. Setting userCurrentValue to 0.00");
          setState(() {
            userInvestedValue = "0.00"; // If PAN is missing, return "0.00"
          });
        } else {
          setState(() {
            userInvestedValue = errorMessage;
          });
        }
      } else if (response.statusCode == 401) {
        setState(() {
          userInvestedValue = "Unauthorized: Please login again!";
        });
      } else {
        setState(() {
          userInvestedValue = "Error ${response.statusCode}: Something went wrong!";
        });
      }
    } catch (e) {
      print("Exception caught: $e");
      setState(() {
        userInvestedValue = "0.00"; // Default to "0.00" on any exception
      });
    }
  }
  // Future<void> fetchUserDtlsPopUp() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final String? authToken = prefs.getString('auth_token');
  //   const String apiUrl = 'https://wealthclockadvisors.com/api/client/dashboard';
  //
  //   if (authToken == null || authToken.isEmpty) {
  //     setState(() {
  //       userName = "Auth token not found!";
  //     });
  //     return;
  //   }
  //
  //   try {
  //     print("Auth Token: $authToken"); // Debugging: Check if token exists
  //
  //     final response = await http.get(
  //       Uri.parse(apiUrl),
  //       headers: {
  //         'Authorization': 'Bearer $authToken',
  //         'Content-Type': 'application/json',
  //       },
  //     );
  //
  //     print("Response Status Code: ${response.statusCode}");
  //     print("Full Response: ${response.body}");
  //
  //     final String responseBody = response.body.trim();
  //
  //     if (response.statusCode == 200) {
  //       if (responseBody.isNotEmpty && (responseBody.startsWith('{') || responseBody.startsWith('['))) {
  //         final Map<String, dynamic> data = json.decode(responseBody);
  //         print("Parsed Data: $data");
  //
  //         if (data.containsKey("clientData") && data["clientData"] is List) {
  //           if (data["clientData"].isEmpty) {
  //             print("clientData is empty. Setting userName to blank.");
  //             setState(() {
  //               userName = ""; // If clientData is empty, show blank string
  //             });
  //             return;
  //           }
  //
  //           String? fetchedName = data["clientData"][0]["user_name"];
  //           String? fetchedPan = data["clientData"][0]["pan"];
  //
  //           print("Fetched Name: $fetchedName");
  //           print("Fetched PAN: $fetchedPan");
  //
  //           setState(() {
  //             if (fetchedPan == null || fetchedPan.isEmpty) {
  //               userName = ""; // PAN is missing, set userName to blank
  //             } else {
  //               userName = fetchedName ?? "No Name Found";
  //             }
  //           });
  //         } else {
  //           setState(() {
  //             userName = "Invalid data format";
  //           });
  //         }
  //       } else {
  //         setState(() {
  //           userName = "Invalid response format (Not JSON)";
  //         });
  //       }
  //     } else if (response.statusCode == 400) {
  //       final Map<String, dynamic> data = json.decode(responseBody);
  //       String errorMessage = data["message"] ?? "Bad Request";
  //
  //       print("Received 400 Error: $errorMessage");
  //
  //       setState(() {
  //         if (errorMessage.toLowerCase().contains("sorry user pan does not exist")) {
  //           print("Detected 'sorry user pan does not exist'. Setting userName to blank.");
  //           userName = ""; // If error message contains this phrase, set blank
  //         } else {
  //           userName = errorMessage;
  //         }
  //       });
  //     } else if (response.statusCode == 401) {
  //       setState(() {
  //         userName = "Unauthorized: Please login again!";
  //       });
  //     } else {
  //       setState(() {
  //         userName = "Error ${response.statusCode}: Something went wrong!";
  //       });
  //     }
  //   } catch (e) {
  //     print("Error: $e");
  //     setState(() {
  //       userName = "Error fetching data!";
  //     });
  //   }
  // }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve the dynamically stored API URL and auth token from SharedPreferences
    const String apiUrl = 'https://wealthclockadvisors.com/api/client/logout'; // Replace with your actual API URL
    final String? authToken = prefs.getString('auth_token'); // Dynamically get the auth token

    // Check if the auth token is null
    if (authToken == null) {
      print('Auth token not found in SharedPreferences');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to retrieve session data. Please log in again.')),
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
      }else {
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
  bool isGainPositive = true;
  bool isZero = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // Back arrow
          onPressed: () {
            Navigator.pop(context); // You can replace this with any other back navigation
          },
        ),
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
                            Navigator.pop(context); // Close the drawer when the icon is pressed
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
                        bottom: BorderSide(color: Colors.grey.shade400,width: 1.0)
                    )
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero, // Remove extra padding
                    backgroundColor:
                    activeTile == 'Home' ? Color(0xFFfee0be) : Colors.transparent, // Change background color based on active state
                    elevation: activeTile == 'Home' ? 5 : 0, // Optional: Adjust elevation
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // Set border radius to zero
                    ),

                  ),
                  onPressed: () {
                    setState(() {
                      activeTile = 'Home'; // Set this tile as active
                    });
                    Navigator.pop(context); // Close the drawer
                  },
                  child: ListTile(
                    leading:  Icon(Icons.home, color: activeTile == 'Home' ? Color(0xFF0f625c) : Color(0xFF303131),size: 20,),
                    title:  Text(
                      'Home',
                      style: TextStyle(
                        color: activeTile == 'Home' ? Color(0xFF0f625c) : Color(0xFF303131),
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
                        bottom: BorderSide(color: Colors.grey.shade400,width: 1.0)
                    )
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero, // Remove extra padding
                    backgroundColor:
                    activeTile == 'My Orders' ? Color(0xFFfee0be) : Colors.transparent, // Change background color based on active state
                    elevation: activeTile == 'My Orders' ? 5 : 0, // Optional: Adjust elevation
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // Set border radius to zero
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      activeTile = 'My Orders'; // Set this tile as active
                    });
                    Navigator.pop(context); // Close the drawer
                  },
                  child: ListTile(
                    leading:  Icon(Icons.shopping_bag_outlined, color: activeTile == 'My Orders' ? Color(0xFF0f625c) : Color(0xFF303131),size: 20,),
                    title:  Text(
                      'My Orders',
                      style: TextStyle(
                        color: activeTile == 'My Orders' ? Color(0xFF0f625c) : Color(0xFF303131),
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
                        bottom: BorderSide(color: Colors.grey.shade400,width: 1.0)
                    )
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero, // Remove extra padding
                    backgroundColor:
                    activeTile == 'My Profile' ? Color(0xFFfee0be) : Colors.transparent, // Change background color based on active state
                    elevation: activeTile == 'My Profile' ? 5 : 0, // Optional: Adjust elevation
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // Set border radius to zero
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      activeTile = 'My Profile'; // Set this tile as active
                    });
                    Navigator.pop(context); // Close the drawer
                  },
                  child: ListTile(
                    leading:  Icon(Icons.person_outline_sharp, color: activeTile == 'My Profile' ? Color(0xFF0f625c) : Color(0xFF303131),size: 20,),
                    title:  Text(
                      'My Profile',
                      style: TextStyle(
                        color: activeTile == 'My Profile' ? Color(0xFF0f625c) : Color(0xFF303131),
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
                        bottom: BorderSide(color: Colors.grey.shade400,width: 1.0)
                    )
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero, // Remove extra padding
                    backgroundColor:
                    activeTile == 'Change Password' ? Color(0xFFfee0be) : Colors.transparent, // Change background color based on active state
                    elevation: activeTile == 'Change Password' ? 5 : 0, // Optional: Adjust elevation
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // Set border radius to zero
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      activeTile = 'Change Password'; // Set this tile as active
                    });
                    Navigator.pop(context); // Close the drawer
                  },
                  child: ListTile(
                    leading:  Icon(Icons.lock_outline, color: activeTile == 'Change Password' ? Color(0xFF0f625c) : Color(0xFF303131),size: 20,),
                    title:  Text(
                      'Change Password',
                      style: TextStyle(
                        color: activeTile == 'Change Password' ? Color(0xFF0f625c) : Color(0xFF303131),
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
                        bottom: BorderSide(color: Colors.grey.shade400,width: 1.0)
                    )
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero, // Remove extra padding
                    backgroundColor:
                    activeTile == 'Request a Service' ? Color(0xFFfee0be) : Colors.transparent, // Change background color based on active state
                    elevation: activeTile == 'Request a Service' ? 5 : 0, // Optional: Adjust elevation
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // Set border radius to zero
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      activeTile = 'Request a Service'; // Set this tile as active
                    });
                    Navigator.pop(context); // Close the drawer
                  },
                  child: ListTile(
                    leading:  Icon(Icons.event_note_sharp, color: activeTile == 'Request a Service' ? Color(0xFF0f625c) : Color(0xFF303131),size: 20,),
                    title:  Text(
                      'Request a Service',
                      style: TextStyle(
                        color: activeTile == 'Request a Service' ? Color(0xFF0f625c) : Color(0xFF303131),
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
                    backgroundColor:
                    activeTile == 'Contact Us' ? Color(0xFFfee0be) : Colors.transparent, // Change background color based on active state
                    elevation: activeTile == 'Contact Us' ? 5 : 0, // Optional: Adjust elevation
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // Set border radius to zero
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      activeTile = 'Contact Us'; // Set this tile as active
                    });
                    Navigator.pop(context); // Close the drawer
                  },
                  child: ListTile(
                    leading:  Icon(Icons.email_outlined, color: activeTile == 'Contact Us' ? Color(0xFF0f625c) : Color(0xFF303131),size: 20,),
                    title:  Text(
                      'Contact Us',
                      style: TextStyle(
                        color: activeTile == 'Contact Us' ? Color(0xFF0f625c) : Color(0xFF303131),
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
                            color: Color(0xFF222222), // Text color (set to white for contrast)
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
          Container(
            color: Colors.white,
            child: Padding(
              padding:
                  EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Space between the logo and buttons
                children: [
                  // Logo on the left
                  Image.asset(
                    'assets/images/dshb_logo.png',
                  ),

                  // Buttons on the right
                  Row(
                    children: [
                      // First button
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

                      const SizedBox(width: 10), // Spacing between buttons

                      // Second button
                      // TextButton(
                      //   onPressed: () {
                      //     // Add your functionality here
                      //   },
                      //   style: TextButton.styleFrom(
                      //     minimumSize: Size(20, 20),
                      //     padding: EdgeInsets.zero,
                      //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      //   ),
                      //   child: Image.asset(
                      //     'assets/images/search-svgrepo-com.png',
                      //     height: 20,
                      //     width: 20,
                      //   ),
                      // ),
                      //
                      // const SizedBox(width: 10), // Spacing between buttons

                      // Third button
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
                    ],
                  ),
                ],
              ),
            ),
          ),

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
                      'MF Portfolio',
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
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0f625c),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 25),
                            Container(
                              width: 1,
                              height: 56,
                              color: Color(0xFFd5d4d0),
                            ),
                            SizedBox(width: 25),
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
                                      fontSize: 22,
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
                                'Abs. Ret.:',
                                style: GoogleFonts.poppins(
                                    color: Color(0xFF0f625c),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                ' 27.29%',
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
                                'XIRR:',
                                style: GoogleFonts.poppins(
                                    color: Color(0xFF0f625c),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                ' 10.54%',
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
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              color: Color(0xFF2cbefc),
                                              width: 4,
                                              height: 30,
                                            ),
                                            SizedBox(width: 10),
                                            SizedBox(
                                              width: 53,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Equity',
                                                    style: GoogleFonts.poppins(
                                                        color: Color(0xFF303131),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Text(
                                                    '95.87%',
                                                    style: GoogleFonts.poppins(
                                                        color: Color(0xFF8c8c8c),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              '₹ 1,14,96,531',
                                              style: GoogleFonts.poppins(
                                                  color: Color(0xFF0f625c),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Container(
                                              color: Color(0xFFf79e3b),
                                              width: 4,
                                              height: 30,
                                            ),
                                            SizedBox(width: 10),
                                            SizedBox(
                                              width: 53,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Hybrid',
                                                    style: GoogleFonts.poppins(
                                                        color: Color(0xFF303131),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Text(
                                                    '3.91%',
                                                    style: GoogleFonts.poppins(
                                                        color: Color(0xFF8c8c8c),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              '₹ 14,68,903',
                                              style: GoogleFonts.poppins(
                                                  color: Color(0xFF0f625c),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Container(
                                              color: Color(0xFFa6a8a7),
                                              width: 4,
                                              height: 30,
                                            ),
                                            SizedBox(width: 10),
                                            SizedBox(
                                              width: 53,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Debt',
                                                    style: GoogleFonts.poppins(
                                                        color: Color(0xFF303131),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Text(
                                                    '0%',
                                                    style: GoogleFonts.poppins(
                                                        color: Color(0xFF8c8c8c),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              '₹ 0',
                                              style: GoogleFonts.poppins(
                                                  color: Color(0xFF0f625c),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Container(
                                              color: Color(0xFFdac45e),
                                              width: 4,
                                              height: 30,
                                            ),
                                            SizedBox(width: 10),
                                            SizedBox(
                                              width: 53,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Other',
                                                    style: GoogleFonts.poppins(
                                                        color: Color(0xFF303131),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Text(
                                                    '0.22%',
                                                    style: GoogleFonts.poppins(
                                                        color: Color(0xFF8c8c8c),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              '₹ 26.055',
                                              style: GoogleFonts.poppins(
                                                  color: Color(0xFF0f625c),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Container(
                                    child:
                                        Image.asset('assets/images/rtt_brd.png'),
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
                                  '29/03/2023',
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const individualPortfolioPage()));
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 20, bottom: 20),
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.only(top: 0, bottom: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      userName,
                                      style: GoogleFonts.poppins(
                                        color: Color(0xFF0f625c),
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 12,),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color(0xFF0d958b),
                                      size: 18,
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  top: 10,
                                ),
                              ),
                              // Text('Fund Regular Growth',style: GoogleFonts.poppins(
                              //   color: Color(0xFF0f625c),
                              //   fontSize: 17,
                              //   fontWeight: FontWeight.w500,
                              // ),),
                              // Container(
                              //   margin: EdgeInsets.only(top: 10,bottom: 10),
                              //   child: Text('₹7,32,690',style: GoogleFonts.poppins(
                              //     color: Color(0xFF0f625c),
                              //     fontSize: 18,
                              //     fontWeight: FontWeight.w600,
                              //   ),),
                              // ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
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
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          '₹ $userInvestedValue',
                                          style: GoogleFonts.poppins(
                                            color: Color(0xFF303131),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 15,),
                                    Column(
                                      children: [
                                        Text(
                                          'Present Value',
                                          style: GoogleFonts.poppins(
                                            color: Color(0xFF8c8c8c),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          '₹ $userCurrentValue',
                                          style: GoogleFonts.poppins(
                                            color: Color(0xFF303131),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 15,),
                                    Column(
                                      children: [
                                        Text(
                                          'Gain/Loss',
                                          style: GoogleFonts.poppins(
                                            color: Color(0xFF8c8c8c),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            if (!isZero)
                                            Icon(
                                              isGainPositive ? Icons.arrow_upward : Icons.arrow_downward,
                                              color: isGainPositive ? Color(0xFF09a99d) : Colors.red,
                                              size: 15,
                                            ),
                                            Text(
                                              '₹ $userTotalGain',
                                              style: GoogleFonts.poppins(
                                                color: isZero
                                                    ? Color(0xFF303131) // Black color for 0.00
                                                    : (isGainPositive ? Color(0xFF09a99d) : Colors.red),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 18, bottom: 18),
                                width: double.infinity,
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
                                          'Abs. Ret.:',
                                          style: GoogleFonts.poppins(
                                              color: Color(0xFF0f625c),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          ' 40.46%',
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
                                          'XIRR:',
                                          style: GoogleFonts.poppins(
                                              color: Color(0xFF0f625c),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          ' 11.02%',
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
                            ],
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const familySchemeDetails()));
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 20, bottom: 20),
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.only(top: 0, bottom: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Garimal Shrimal',
                                      style: GoogleFonts.poppins(
                                        color: Color(0xFF0f625c),
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 12,),
                                      Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color(0xFF0d958b),
                                      size: 18,
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  top: 10,
                                ),
                              ),
                              // Text('Fund Regilar Growth',style: GoogleFonts.poppins(
                              //   color: Color(0xFF0f625c),
                              //   fontSize: 17,
                              //   fontWeight: FontWeight.w500,
                              // ),),
                              // Container(
                              //   margin: EdgeInsets.only(top: 10,bottom: 10),
                              //   child: Text('₹10,34,198',style: GoogleFonts.poppins(
                              //     color: Color(0xFF0f625c),
                              //     fontSize: 18,
                              //     fontWeight: FontWeight.w600,
                              //   ),),
                              // ),
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
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '19,50,000',
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
                                        'Present Value',
                                        style: GoogleFonts.poppins(
                                          color: Color(0xFF8c8c8c),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '26,57,633',
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
                                        'Gain/Loss',
                                        style: GoogleFonts.poppins(
                                          color: Color(0xFF8c8c8c),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.arrow_upward,
                                            color: Color(0xFF09a99d),
                                            size: 15,
                                          ),
                                          Text(
                                            '7,07,633',
                                            style: GoogleFonts.poppins(
                                              color: Color(0xFF09a99d),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 18, bottom: 18),
                                width: double.infinity,
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
                                          'Abs. Ret.:',
                                          style: GoogleFonts.poppins(
                                              color: Color(0xFF0f625c),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          ' 36.29%',
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
                                          'XIRR:',
                                          style: GoogleFonts.poppins(
                                              color: Color(0xFF0f625c),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          ' 12.65%',
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
                            ],
                          ),
                        ),
                      ),
                    ),
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
}
