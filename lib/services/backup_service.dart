import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/product.dart';

class BackupService {
  /// Export products to a JSON file in the device's documents directory
  Future<String> exportProductsAsJson(List<Product> products) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${directory.path}/gumroad_backup_$timestamp.json');
      
      final jsonData = {
        'exportedAt': DateTime.now().toIso8601String(),
        'productCount': products.length,
        'products': products.map((p) => p.toJson()).toList(),
      };
      
      await file.writeAsString(jsonEncode(jsonData));
      return file.path;
    } catch (e) {
      throw Exception('Failed to export products: $e');
    }
  }

  /// Import products from a JSON backup file
  Future<List<Product>> importProductsFromJson(String filePath) async {
    try {
      final file = File(filePath);
      final jsonString = await file.readAsString();
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      
      final productsList = jsonData['products'] as List<dynamic>;
      return productsList.map((p) => Product.fromJson(p as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Failed to import products: $e');
    }
  }
}
