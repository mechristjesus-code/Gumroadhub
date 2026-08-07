import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/product.dart';
import '../services/gumroad_service.dart';

class ProductProvider extends ChangeNotifier {
  final GumroadService _service = GumroadService();
  final Box _box = Hive.box('products');
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  List<Product> get filteredProducts => _filteredProducts;

bool get isLoading => _isLoading;

ProductProvider() {
  _loadFromCache();
}

void _loadFromCache() {
  final cachedData = _box.get('list');
  if (cachedData != null) {
    _products = (cachedData as List).map((e) => Product.fromJson(Map<String, dynamic>.from(e))).toList();
    _filteredProducts = _products;
    notifyListeners();
  }
}

void search(String query) {
  if (query.isEmpty) {
    _filteredProducts = _products;
  } else {
    _filteredProducts = _products.where((p) => p.name.toLowerCase().contains(query.toLowerCase())).toList();
  }
  notifyListeners();
}

Future<void> fetchProducts() async {
  _isLoading = true;
  notifyListeners();
  try {
    _products = await _service.getProducts();
    _filteredProducts = _products;
    await _box.put('list', _products.map((p) => p.toJson()).toList());
  } catch (e) {
    debugPrint('Error fetching products: $e, loading from cache.');
    _loadFromCache();
  }
  _isLoading = false;
  notifyListeners();
}

  Future<void> addProduct(Product product) async {
    _products.add(product);
    await _box.put('list', _products.map((p) => p.toJson()).toList());
    notifyListeners();
  }

  Future<void> deleteProduct(String productId) async {
    _products.removeWhere((p) => p.id == productId);
    _filteredProducts.removeWhere((p) => p.id == productId);
    await _box.put('list', _products.map((p) => p.toJson()).toList());
    notifyListeners();
  }

  Future<void> updateProduct(Product updatedProduct) async {
    final index = _products.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      _products[index] = updatedProduct;
      final filteredIndex = _filteredProducts.indexWhere((p) => p.id == updatedProduct.id);
      if (filteredIndex != -1) {
        _filteredProducts[filteredIndex] = updatedProduct;
      }
      await _box.put('list', _products.map((p) => p.toJson()).toList());
      notifyListeners();
    }
  }
}
