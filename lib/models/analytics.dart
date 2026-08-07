import 'package:equatable/equatable.dart';

class AnalyticsData extends Equatable {
  final int totalSales;
  final double revenue;
  final int customers;

  const AnalyticsData({
    required this.totalSales,
    required this.revenue,
    required this.customers,
  });

  factory AnalyticsData.fromJson(Map<String, dynamic> json) => AnalyticsData(
        totalSales: json['totalSales'] as int,
        revenue: (json['revenue'] as num).toDouble(),
        customers: json['customers'] as int,
      );

  Map<String, dynamic> toJson() => {
        'totalSales': totalSales,
        'revenue': revenue,
        'customers': customers,
      };

  @override
  List<Object?> get props => [totalSales, revenue, customers];
}
