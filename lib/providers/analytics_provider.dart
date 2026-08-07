import 'package:flutter/foundation.dart';
import '../models/analytics.dart';
import '../services/gumroad_service.dart';

class AnalyticsProvider extends ChangeNotifier {
  final GumroadService _service = GumroadService();
  AnalyticsData? _data;
  bool _isLoading = false;

  AnalyticsData? get data => _data;
  bool get isLoading => _isLoading;

  Future<void> fetchAnalytics() async {
    _isLoading = true;
    notifyListeners();
    try {
      _data = await _service.getAnalytics();
    } catch (e) {
      debugPrint('Error fetching analytics: $e');
    }
    _isLoading = false;
    notifyListeners();
  }
}
