import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../models/sale.dart';

class ProductStatsProvider extends ChangeNotifier {
  final Map<String, int> _productSalesCount = {};
  final Map<String, double> _productRevenue = {};

  Map<String, int> get productSalesCount => _productSalesCount;
  Map<String, double> get productRevenue => _productRevenue;

  /// Calculate total sales count for all products
  int getTotalSalesCount() {
    return _productSalesCount.values.fold(0, (sum, count) => sum + count);
  }

  /// Calculate total revenue for all products
  double getTotalRevenue() {
    return _productRevenue.values.fold(0.0, (sum, revenue) => sum + revenue);
  }

  /// Get sales count for a specific product
  int getSalesCountForProduct(String productId) {
    return _productSalesCount[productId] ?? 0;
  }

  /// Get revenue for a specific product
  double getRevenueForProduct(String productId) {
    return _productRevenue[productId] ?? 0.0;
  }

  /// Update stats based on sales data
  void updateStatsFromSales(List<Sale> sales) {
    _productSalesCount.clear();
    _productRevenue.clear();

    for (final sale in sales) {
      _productSalesCount[sale.productId] = (_productSalesCount[sale.productId] ?? 0) + 1;
      _productRevenue[sale.productId] = (_productRevenue[sale.productId] ?? 0.0) + sale.amount;
    }

    notifyListeners();
  }

  /// Get top selling products
  List<MapEntry<String, int>> getTopSellingProducts({int limit = 5}) {
    final sorted = _productSalesCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(limit).toList();
  }

  /// Get top revenue generating products
  List<MapEntry<String, double>> getTopRevenueProducts({int limit = 5}) {
    final sorted = _productRevenue.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(limit).toList();
  }
}
