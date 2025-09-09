// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/login.dart'; // Import your LoginPage

class TokenRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  Future<void> _checkToken(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final expiresAt = prefs.getString('expires_at');

    // If no token, force login
    if (token == null) {
      _redirectToLogin(context, message: "Session missing, please log in.");
      return;
    }

    // If app is storing an expiry timestamp (because Sanctum expiration is set)
    if (expiresAt != null) {
      final expiryDate = DateTime.tryParse(expiresAt);
      if (expiryDate != null && DateTime.now().isAfter(expiryDate)) {
        // Token expired locally
        await prefs.clear(); // clears all stored keys
        _redirectToLogin(context,
            message: "Session expired, please log in again.");
      }
    }

    // else → token is opaque and "valid until backend says otherwise"
  }

  void _redirectToLogin(BuildContext context, {required String message}) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      _checkToken(route.navigator!.context);
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute) {
      _checkToken(previousRoute.navigator!.context);
    }
  }
}
