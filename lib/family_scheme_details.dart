import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'family_fund_investment_details.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class familySchemeDetails extends StatefulWidget {
  const familySchemeDetails({super.key});

  @override
  State<familySchemeDetails> createState() => _familySchemeDetailsState();
}

class _familySchemeDetailsState extends State<familySchemeDetails>{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String activeTile = 'Home';
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

                    Text(
                      'Siddharth\nShrimal',
                      style: GoogleFonts.poppins(
                        color: Color(0xFF0f625c),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
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
              padding: EdgeInsets.only(left: 20,right: 20,bottom: 20,top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between the logo and buttons
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
                          minimumSize: Size(20, 20), // Adjust clickable area to match image size
                          padding: EdgeInsets.zero,  // Remove padding
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Shrink touch area
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
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0,bottom: 20,left: 15,right: 15),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),

                            Text(
                              'Garimal Shrimal',
                              style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF09a99d),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              child: Text(
                                'Bandhan Tax Advantage (ELSS)\nFund Regular Growth',
                                textAlign: TextAlign.center, // Apply text alignment here
                                style: GoogleFonts.poppins(
                                  color: Color(0xFF0f625c),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 3, // Adjust elevation as needed
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(50), // Match container's border radius
                                        ),
                                        backgroundColor: Colors.white, // Match container's color
                                      ),
                                      onPressed: () {
                                        // Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupPage()));
                                        // Define the action for the button here
                                        // Navigator.push(context, MaterialPageRoute(builder: (context) => const familyPortfolioPage()));
                                      },
                                      child: Text('Equity',style: GoogleFonts.poppins(
                                        color: Color(0xFF8c8c8c),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),),
                                    ),
                                    SizedBox(width: 10),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 3, // Adjust elevation as needed
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(50), // Match container's border radius
                                        ),
                                        backgroundColor: Colors.white, // Match container's color
                                      ),
                                      onPressed: () {
                                        // Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupPage()));
                                        // Define the action for the button here
                                        // Navigator.push(context, MaterialPageRoute(builder: (context) => const familyPortfolioPage()));
                                      },
                                      child: Text('ELSS',style: GoogleFonts.poppins(
                                        color: Color(0xFF8c8c8c),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text('Gain/Loss',style: GoogleFonts.poppins(color: Color(0xFF8c8c8c),fontSize: 14,fontWeight: FontWeight.w500)),
                                    Row(
                                      children: [
                                        Icon(Icons.arrow_upward,color: Color(0xFF09a99d),size: 15,),
                                        Text('2,32,690',style: GoogleFonts.poppins(
                                          color: Color(0xFF09a99d),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Folio No.',style: GoogleFonts.poppins(
                                      color: Color(0xFF8c8c8c),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),),
                                    Text('xxxx7/73',style: GoogleFonts.poppins(
                                      color: Color(0xFF303131),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Holding Pattern',style: GoogleFonts.poppins(
                                      color: Color(0xFF8c8c8c),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),),
                                    Text('Single',style: GoogleFonts.poppins(
                                      color: Color(0xFF303131),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Joint Holder',style: GoogleFonts.poppins(
                                      color: Color(0xFF8c8c8c),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),),
                                    Text('',style: GoogleFonts.poppins(
                                      color: Color(0xFF303131),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20,bottom: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('Portfolio Value',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF648683),
                                          ),
                                        ),
                                        Text('₹26,57,633',
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
                                        Text('Overal Gain %',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF648683),
                                          ),
                                        ),
                                        Text('₹7,07,633',
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
                                      Text('Abs. Ret.:',style: GoogleFonts.poppins(color: Color(0xFF0f625c),fontSize: 15,fontWeight: FontWeight.w400),),
                                      Text(' 27.29%',style: GoogleFonts.poppins(color: Color(0xFF0f625c),fontSize: 15,fontWeight: FontWeight.w600),),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 15),
                                Container(
                                  child: Row(
                                    children: [
                                      Text('XIRR:',style: GoogleFonts.poppins(color: Color(0xFF0f625c),fontSize: 15,fontWeight: FontWeight.w400),),
                                      Text(' 10.54%',style: GoogleFonts.poppins(color: Color(0xFF0f625c),fontSize: 15,fontWeight: FontWeight.w600),),
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
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // Adjust elevation as needed
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                50), // Match container's border radius
                          ),
                          backgroundColor:
                          Colors.white,
                          // Match container's color
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const familyFundInvstDtls()));
                          // Define the action for the button here
                        },
                        child: Text('Click Here For More Details',style: GoogleFonts.poppins(color: Color(0xFF09a99d),fontWeight: FontWeight.w500,fontSize: 14),),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Row(
                        spacing: 10,
                        children: [
                          SizedBox(
                            width: 165,
                            child: Column(
                              children: [
                                Row(
                                  spacing: 10,
                                  children: [
                                    SizedBox(
                                      width: 48,
                                      height: 48,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Color(0xFFf9eddb),
                                        ),
                                        child: Center(child: Image.asset('assets/images/ech_dlr.png')),// Replace 'Colors.red' with your desired color
                                      ),
                                    ),
                                    Text('Invested',style: GoogleFonts.poppins(color: Color(0xFF0f625c),fontSize: 16,fontWeight: FontWeight.w500),),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Lumsum',style: GoogleFonts.poppins(color: Color(0xFF8c8c8c),fontWeight: FontWeight.w500,fontSize: 14),),
                                    Text('5,00,000',style: GoogleFonts.poppins(color: Color(0xFF303131),fontWeight: FontWeight.w500,fontSize: 14),),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('SIP',style: GoogleFonts.poppins(color: Color(0xFF8c8c8c),fontWeight: FontWeight.w500,fontSize: 14),),
                                    Text('0',style: GoogleFonts.poppins(color: Color(0xFF303131),fontWeight: FontWeight.w500,fontSize: 14),),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Switch-Ins',style: GoogleFonts.poppins(color: Color(0xFF8c8c8c),fontWeight: FontWeight.w500,fontSize: 14),),
                                    Text('0',style: GoogleFonts.poppins(color: Color(0xFF303131),fontWeight: FontWeight.w500,fontSize: 14),),
                                  ],
                                ),Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Dividends',style: GoogleFonts.poppins(color: Color(0xFF8c8c8c),fontWeight: FontWeight.w500,fontSize: 14),),
                                    Text('0',style: GoogleFonts.poppins(color: Color(0xFF303131),fontWeight: FontWeight.w500,fontSize: 14),),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10,bottom: 10),
                                  color: Color(0xFFcbd2d0),
                                  height: 1,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [

                                    Text('5,00,000',style: GoogleFonts.poppins(color: Color(0xFF303131),fontWeight: FontWeight.w500,fontSize: 14),),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 168,width: 1,child: Container(
                            color: Color(0xFFcbd2d0), // Replace 'Colors.red' with your desired color
                          ),),
                          SizedBox(
                            width: 165,
                            child: Column(
                              children: [
                                Row(
                                  spacing: 10,
                                  children: [
                                    SizedBox(
                                      width: 48,
                                      height: 48,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Color(0xFFb0daf4),
                                        ),
                                        child: Center(child: Image.asset('assets/images/inv_tx.png')),// Replace 'Colors.red' with your desired color
                                      ),
                                    ),
                                    Text('Received',style: GoogleFonts.poppins(color: Color(0xFF0f625c),fontSize: 16,fontWeight: FontWeight.w500),),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Dividends',style: GoogleFonts.poppins(color: Color(0xFF8c8c8c),fontWeight: FontWeight.w500,fontSize: 14),),
                                    Text('0',style: GoogleFonts.poppins(color: Color(0xFF303131),fontWeight: FontWeight.w500,fontSize: 14),),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Redemptions',style: GoogleFonts.poppins(color: Color(0xFF8c8c8c),fontWeight: FontWeight.w500,fontSize: 14),),
                                    Text('0',style: GoogleFonts.poppins(color: Color(0xFF303131),fontWeight: FontWeight.w500,fontSize: 14),),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Switch-Outs',style: GoogleFonts.poppins(color: Color(0xFF8c8c8c),fontWeight: FontWeight.w500,fontSize: 14),),
                                    Text('0',style: GoogleFonts.poppins(color: Color(0xFF303131),fontWeight: FontWeight.w500,fontSize: 14),),
                                  ],
                                ),Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('SWP',style: GoogleFonts.poppins(color: Color(0xFF8c8c8c),fontWeight: FontWeight.w500,fontSize: 14),),
                                    Text('0',style: GoogleFonts.poppins(color: Color(0xFF303131),fontWeight: FontWeight.w500,fontSize: 14),),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10,bottom: 10),
                                  color: Color(0xFFcbd2d0),
                                  height: 1,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [

                                    Text('0',style: GoogleFonts.poppins(color: Color(0xFF303131),fontWeight: FontWeight.w500,fontSize: 14),),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          spacing: 20,
                          children: [
                            Column(
                              children: [
                                Text('Balance\nUnits',style: GoogleFonts.poppins(color: Color(0xFF8c8c8c),fontSize: 14,fontWeight: FontWeight.w500),),
                                SizedBox(height: 5,),
                                Text('7,534,163',style: GoogleFonts.poppins(color: Color(0xFF0f625c),fontSize: 14,fontWeight: FontWeight.w600),),
                              ],
                            ),
                            Column(
                              children: [
                                Text('Average\nNAV',style: GoogleFonts.poppins(color: Color(0xFF8c8c8c),fontSize: 14,fontWeight: FontWeight.w500),),
                                SizedBox(height: 5,),
                                Text('6,63,600',style: GoogleFonts.poppins(color: Color(0xFF0f625c),fontSize: 14,fontWeight: FontWeight.w600),),
                              ],
                            ),
                            Column(
                              children: [
                                Text('Cost\nAmount',style: GoogleFonts.poppins(color: Color(0xFF8c8c8c),fontSize: 14,fontWeight: FontWeight.w500),),
                                SizedBox(height: 5,),
                                Text('5,00,000',style: GoogleFonts.poppins(color: Color(0xFF0f625c),fontSize: 14,fontWeight: FontWeight.w600),),
                              ],
                            ),
                            Column(
                              children: [
                                Text('Present\nValue',style: GoogleFonts.poppins(color: Color(0xFF8c8c8c),fontSize: 14,fontWeight: FontWeight.w500),),
                                SizedBox(height: 5,),
                                Text('7,32,690',style: GoogleFonts.poppins(color: Color(0xFF0f625c),fontSize: 14,fontWeight: FontWeight.w600),),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20,top: 20),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 28,
                        children: [
                          InkWell(
                            onTap: () {
                              // Define your action here
                              print("New Fund Offer button pressed");
                            },
                            borderRadius: BorderRadius.circular(8), // Add ripple effect matching the button shape
                            child: Container(
                              width: 100,
                              padding: const EdgeInsets.symmetric(vertical: 10), // Optional padding
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFb2daf4),
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                    ),
                                    child: Center(
                                      child: Image.asset('assets/images/nw_fnd.png'),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Realized Gain',
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

                          Container(width: 1,height: 100,color: Color(0xFFc7d1d0),),
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
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                    ),
                                    child: Center(
                                      child: Image.asset('assets/images/thm_invst.png'),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Text('Unrealized Gain'
                                    ,style: GoogleFonts.poppins(
                                      color: Color(0xFF0f625c),fontSize: 14,fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(width: 1,height: 100,color: Color(0xFFc7d1d0),),
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
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                    ),
                                    child: Center(
                                      child: Image.asset('assets/images/int_mtfnd.png'),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Text('Overall Gain',
                                    style: GoogleFonts.poppins(
                                      color: Color(0xFF0f625c),fontSize: 14,fontWeight: FontWeight.w400,
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
                    SizedBox(height: 20),
                    // Add more widgets here
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 10,bottom: 10,left: 25,right: 25),
            color: Colors.white,
            child: Wrap(
              spacing: 15,
              runSpacing: 15,
              children: [
                InkWell(
                  onTap: (){

                  },
                  child: SizedBox(
                    width: 60,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/ftr_hmm.png',
                          // Adjust as needed
                          fit: BoxFit.contain, // Adjust as needed
                        ),
                        Text('Home',style: GoogleFonts.poppins(
                          color: Color(0xFF648683),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){

                  },
                  child: SizedBox(
                    width: 60,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/ftr_prtflo.png',
                          // Adjust as needed
                          fit: BoxFit.contain, // Adjust as needed
                        ),
                        Text('Portfolio',style: GoogleFonts.poppins(
                          color: Color(0xFF648683),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){

                  },
                  child: SizedBox(
                    width: 50,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/ftr_invst.png',
                          // Adjust as needed
                          fit: BoxFit.contain, // Adjust as needed
                        ),
                        Text('Invest',style: GoogleFonts.poppins(
                          color: Color(0xFF648683),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){

                  },
                  child: SizedBox(
                    width: 50,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/rptt.png',
                          // Adjust as needed
                          fit: BoxFit.contain, // Adjust as needed
                        ),
                        Text('Report',style: GoogleFonts.poppins(
                          color: Color(0xFF648683),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){

                  },
                  child: SizedBox(
                    width: 60,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/stng.png',
                          // Adjust as needed
                          fit: BoxFit.contain, // Adjust as needed
                        ),
                        Text('Settings',style: GoogleFonts.poppins(
                          color: Color(0xFF648683),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),),
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