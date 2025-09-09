import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricAuth {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> checkBiometric({bool? setupMode = false}) async {
    try {
      final canCheckBiometric = await _auth.canCheckBiometrics;
      if (!canCheckBiometric) return false;

      final availableBiometric = await _auth.getAvailableBiometrics();
      if (availableBiometric.isEmpty) return false;

      final authenticated = await _auth.authenticate(
        localizedReason: "Scan your finger to authenticate",
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );

      if (authenticated && setupMode == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isBiometricEnabled', true);
      }

      return authenticated;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isBiometricEnabled') ?? false;
  }
}
