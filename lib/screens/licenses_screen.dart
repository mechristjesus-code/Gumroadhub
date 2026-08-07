import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/license_provider.dart';

class LicensesScreen extends StatefulWidget {
  const LicensesScreen({super.key});

  @override
  State<LicensesScreen> createState() => _LicensesScreenState();
}

class _LicensesScreenState extends State<LicensesScreen> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LicenseProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('License Management')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter license key...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => provider.verifyLicense(_controller.text),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (provider.isLoading) const CircularProgressIndicator(),
            if (provider.foundLicense != null)
              Card(
                child: ListTile(
                  title: Text('Key: ${provider.foundLicense!.licenseKey}'),
                  subtitle: Text('Active: ${provider.foundLicense!.active}'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
