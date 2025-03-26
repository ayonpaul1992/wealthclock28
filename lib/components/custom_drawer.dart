import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CustomDrawer extends StatefulWidget {
  final String userName;
  final String activeTile;
  final Function(String) onTileTap;
  // final VoidCallback onLogout;

  const CustomDrawer({
    super.key,
    required this.userName,
    required this.activeTile,
    required this.onTileTap,
    // required this.onLogout,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String activeTile = '';

  @override
  void initState() {
    super.initState();
    activeTile = widget.activeTile;
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
      // print('Auth token not found in SharedPreferences');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Unable to retrieve session data. Please log in again.')),
      );
      return;
    }

    try {
      // print('Attempting to log out...');
      // print('API URL: $apiUrl');
      // print('Authorization Token: $authToken');

      // Sending the GET request to the logout API
      final response = await http.get(
        Uri.parse('$apiUrl?logout=true'),
        headers: {
          'Authorization': 'Bearer $authToken', // Use the dynamic auth token
          'Content-Type': 'application/json',
        },
      );

      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');

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
        // print('Error during logout. Status code: ${response.statusCode}');
        // print('Error body: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to logout. Please try again.'),
          ),
        );
      }
    } catch (e) {
      // Handle network or other errors
      // print('Error during logout: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: Unable to log out. $e'),
        ),
      );
    }
  }

  Widget _buildDrawerTile({
    required String title,
    required IconData icon,
  }) {
    bool isActive = activeTile == title;
    return Container(
      decoration: BoxDecoration(
        border:
            Border(bottom: BorderSide(color: Colors.grey.shade400, width: 1.0)),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: isActive ? Color(0xFFfee0be) : Colors.transparent,
          elevation: isActive ? 5 : 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        onPressed: () {
          setState(() {
            activeTile = title;
          });
          widget.onTileTap(title);
          Navigator.pop(context); // Close drawer
        },
        child: ListTile(
          leading: Icon(icon,
              color: isActive ? Color(0xFF0f625c) : Color(0xFF303131),
              size: 20),
          title: Text(
            title,
            style: TextStyle(
              color: isActive ? Color(0xFF0f625c) : Color(0xFF303131),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color(0xFFfdd1a0),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Header
            DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFFfdd1a0)),
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
                      widget.userName,
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
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  )
                ],
              ),
            ),

            // Drawer Items
            _buildDrawerTile(title: 'Home', icon: Icons.home),
            _buildDrawerTile(
                title: 'My Orders', icon: Icons.shopping_bag_outlined),
            _buildDrawerTile(
                title: 'My Profile', icon: Icons.person_outline_sharp),
            _buildDrawerTile(
                title: 'Change Password', icon: Icons.lock_outline),
            _buildDrawerTile(
                title: 'Request a Service', icon: Icons.event_note_sharp),
            _buildDrawerTile(title: 'Contact Us', icon: Icons.email_outlined),

            // Logout Button
            Container(
              margin: EdgeInsets.only(top: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: ElevatedButton(
                      onPressed: () => _logout(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFfef1e2),
                        elevation: 5,
                      ),
                      child: Text(
                        'Log Out'.toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF222222),
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
    );
  }
}
