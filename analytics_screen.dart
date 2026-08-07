import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/analytics_provider.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<AnalyticsProvider>().fetchAnalytics());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: Consumer<AnalyticsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.data == null) {
            return const Center(child: Text('No analytics data available.'));
          }
          
          final data = provider.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildStatCard('Total Revenue', '\$${data.revenue.toStringAsFixed(2)}'),
                const SizedBox(height: 16),
                _buildStatCard('Total Sales', data.totalSales.toString()),
                const SizedBox(height: 16),
                _buildStatCard('Customers', data.customers.toString()),
                const SizedBox(height: 16),
                _buildPlaceholderChart(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
    );
  }

  Widget _buildPlaceholderChart() {
    return Expanded(
      child: Container(
        color: Colors.grey[200],
        child: const Center(child: Text('Chart Placeholder')),
      ),
    );
  }
}
