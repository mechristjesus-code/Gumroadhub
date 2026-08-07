import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.push('/products'),
              child: const Text('View Products'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.push('/create-product'),
              child: const Text('Create Product'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.push('/analytics'),
              child: const Text('View Analytics'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.push('/licenses'),
              child: const Text('Manage Licenses'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.push('/ebook-creator'),
              child: const Text('E-book Creator'),
            ),
          ],
        ),
      ),
    );
  }
}
