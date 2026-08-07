import 'package:flutter/foundation.dart';
import '../models/license.dart';

class LicenseProvider extends ChangeNotifier {
  License? _foundLicense;
  bool _isLoading = false;

  License? get foundLicense => _foundLicense;
  bool get isLoading => _isLoading;

  Future<void> verifyLicense(String licenseKey) async {
    _isLoading = true;
    notifyListeners();
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    _foundLicense = License(id: '1', productId: 'p1', licenseKey: licenseKey, active: true);
    _isLoading = false;
    notifyListeners();
  }
}
