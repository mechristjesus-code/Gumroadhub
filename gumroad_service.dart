import 'package:dio/dio.dart';
import '../core/constants.dart';
import '../models/product.dart';
import '../models/analytics.dart';

class GumroadService {
  final Dio _dio;

  GumroadService() : _dio = Dio(BaseOptions(baseUrl: AppConstants.apiBaseUrl));

  Future<List<Product>> getProducts() async {
    final response = await _dio.get('/products');
    final List<dynamic> data = response.data;
    return data.map((json) => Product.fromJson(json)).toList();
  }

  Future<AnalyticsData> getAnalytics() async {
    // This requires an actual API endpoint, using a mock return for structure
    await Future.delayed(const Duration(seconds: 1));
    return const AnalyticsData(totalSales: 342, revenue: 12450.0, customers: 120);
  }
}
