import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login.dart';
import 'screens/dashboard_after_login.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensures async operations work before runApp
  String? userId = await getUserId(); // Retrieve stored userId
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? authToken = prefs.getString('auth_token');
  print('User ID: $userId');
  print('Auth Token: $authToken');

  runApp(
    MyApp(userId: userId, authToken: authToken),
  );
}

Future<String?> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_id'); // Returns userId if stored, else null
}

class MyApp extends StatelessWidget {
  final String? userId;
  final String? authToken;

  const MyApp({super.key, this.userId, this.authToken});

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn = userId != null && authToken != null;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home:
          isLoggedIn ? dashboardAfterLogin(userId: userId!) : const LoginPage(),
      // onUnknownRoute: (settings) {
      //   return MaterialPageRoute(
      //     builder: (context) => userId == null
      //         ? const LoginPage()
      //         : dashboardAfterLogin(userId: userId!),
      //   );
      //   // return null;
      // },
      // home: userId == null
      //     ? const LoginPage()
      //     : dashboardAfterLogin(userId: userId!),
    );
  }
}
