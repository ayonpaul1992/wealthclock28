import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login.dart';
import 'screens/dashboard_after_login.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensures async operations work before runApp
  String? userId = await getUserId(); // Retrieve stored userId
  runApp(
    MyApp(userId: userId),
  );
}

Future<String?> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_id'); // Returns userId if stored, else null
}

class MyApp extends StatelessWidget {
  final String? userId;
  const MyApp({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => userId == null
              ? const LoginPage()
              : dashboardAfterLogin(userId: userId!),
        );
        // return null;
      },
      home: userId == null
          ? const LoginPage()
          : dashboardAfterLogin(userId: userId!),
    );
  }
}
