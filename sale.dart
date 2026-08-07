import 'package:equatable/equatable.dart';

class Sale extends Equatable {
  final String id;
  final String productId;
  final double amount;
  final DateTime createdAt;

  const Sale({
    required this.id,
    required this.productId,
    required this.amount,
    required this.createdAt,
  });

  factory Sale.fromJson(Map<String, dynamic> json) => Sale(
        id: json['id'] as String,
        productId: json['productId'] as String,
        amount: (json['amount'] as num).toDouble(),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'productId': productId,
        'amount': amount,
        'createdAt': createdAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, productId, amount, createdAt];
}
