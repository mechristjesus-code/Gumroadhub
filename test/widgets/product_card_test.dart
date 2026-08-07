import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gumroad_app/models/product.dart';
import 'package:gumroad_app/widgets/product_card.dart';

void main() {
  testWidgets('ProductCard displays product details', (WidgetTester tester) async {
    final product = Product(
      id: '1',
      name: 'Test Product',
      price: 10.0,
      description: 'Test Description',
    );

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: ProductCard(product: product)),
    ));

    expect(find.text('Test Product'), findsOneWidget);
    expect(find.text('Test Description'), findsOneWidget);
    expect(find.text('\$10.00'), findsOneWidget);
  });
}
