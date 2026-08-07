import 'package:equatable/equatable.dart';

class License extends Equatable {
  final String id;
  final String productId;
  final String licenseKey;
  final bool active;

  const License({
    required this.id,
    required this.productId,
    required this.licenseKey,
    required this.active,
  });

  factory License.fromJson(Map<String, dynamic> json) => License(
        id: json['id'] as String,
        productId: json['productId'] as String,
        licenseKey: json['licenseKey'] as String,
        active: json['active'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'productId': productId,
        'licenseKey': licenseKey,
        'active': active,
      };

  @override
  List<Object?> get props => [id, productId, licenseKey, active];
}
