import 'package:flutter_test/flutter_test.dart';
import 'package:gumroad_app/models/product.dart';

void main() {
  group('Product Model', () {
    test('fromJson and toJson should work correctly', () {
      final json = {
        'id': '1',
        'name': 'Test Product',
        'price': 10.0,
        'description': 'Test Description',
      };
      final product = Product.fromJson(json);
      expect(product.id, '1');
      expect(product.toJson(), json);
    });
  });
}
