import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wealthclock28/biometric_auth.dart';
import 'screens/login.dart';
import 'screens/dashboard_after_login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String? userId = await getUserId();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? authToken = prefs.getString('auth_token');

  runApp(
    MyApp(userId: userId, authToken: authToken),
  );
}

Future<String?> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_id');
}

class MyApp extends StatelessWidget {
  final String? userId;
  final String? authToken;

  const MyApp({super.key, this.userId, this.authToken});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: SplashScreen(userId: userId, authToken: authToken),
    );
  }
}

class SplashScreen extends StatefulWidget {
  final String? userId;
  final String? authToken;

  const SplashScreen({super.key, this.userId, this.authToken});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final biometric = BiometricAuth();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _decideStartScreen();
    });
  }

  Future<void> _decideStartScreen() async {
    final loggedIn = widget.userId != null && widget.authToken != null;

    if (!loggedIn) {
      _goTo(const LoginPage());
      return;
    }

    final bioEnabled = await biometric.isBiometricEnabled();

    if (bioEnabled) {
      final authenticated = await biometric.checkBiometric();
      if (authenticated) {
        _goTo(dashboardAfterLogin(userId: widget.userId!));
      } else {
        _goTo(const LoginPage());
      }
    } else {
      _goTo(dashboardAfterLogin(userId: widget.userId!));
    }
  }

  void _goTo(Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

// class _SplashScreenState extends State<SplashScreen> {
//   final biometric = BiometricAuth();

//   @override
//   void initState() {
//     super.initState();
//     _decideStartScreen();
//   }

//   Future<void> _decideStartScreen() async {
//     final loggedIn = widget.userId != null && widget.authToken != null;

//     if (!loggedIn) {
//       _goTo(const LoginPage());
//       return;
//     }

//     final bioEnabled = await biometric.isBiometricEnabled();

//     if (bioEnabled) {
//       final authenticated = await biometric.checkBiometric();
//       if (authenticated) {
//         _goTo(dashboardAfterLogin(userId: widget.userId!));
//       } else {
//         _goTo(const LoginPage());
//       }
//     } else {
//       _goTo(dashboardAfterLogin(userId: widget.userId!));
//     }
//   }

//   void _goTo(Widget screen) {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (_) => screen),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(child: CircularProgressIndicator()),
//     );
//   }
// }
