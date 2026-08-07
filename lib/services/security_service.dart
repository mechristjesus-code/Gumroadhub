// Note: Add 'local_auth' to pubspec.yaml to enable this service.
// dependencies:
//   local_auth: ^2.1.8

import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class SecurityService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> canAuthenticate() async {
    final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
    final bool canAuthenticate = canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
    return canAuthenticate;
  }

  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Please authenticate to access Gumroad Creator Hub',
        options: const AuthenticationOptions(biometricOnly: true),
      );
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }
}
