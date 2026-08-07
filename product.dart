import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final double price;
  final String description;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as String,
        name: json['name'] as String,
        price: (json['price'] as num).toDouble(),
        description: json['description'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'description': description,
      };

  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? description,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [id, name, price, description];
}
