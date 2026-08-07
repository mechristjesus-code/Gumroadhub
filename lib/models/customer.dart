import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  final String id;
  final String email;
  final String name;

  const Customer({
    required this.id,
    required this.email,
    required this.name,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json['id'] as String,
        email: json['email'] as String,
        name: json['name'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
      };

  @override
  List<Object?> get props => [id, email, name];
}
