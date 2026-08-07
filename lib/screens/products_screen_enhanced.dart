import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../services/backup_service.dart';
import '../widgets/product_card.dart';

class ProductsScreenEnhanced extends StatefulWidget {
  const ProductsScreenEnhanced({super.key});

  @override
  State<ProductsScreenEnhanced> createState() => _ProductsScreenEnhancedState();
}

class _ProductsScreenEnhancedState extends State<ProductsScreenEnhanced> {
  final _backupService = BackupService();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ProductProvider>().fetchProducts());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _exportAsJson() async {
    try {
      final products = context.read<ProductProvider>().products;
      final filePath = await _backupService.exportProductsAsJson(products);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Backup saved to: $filePath')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_upload),
            tooltip: 'Import JSON Backup',
            onPressed: () {
              // TODO: Implement file picker and trigger _backupService.importProductsFromJson
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Import functionality coming soon.')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.backup),
            tooltip: 'Export as JSON',
            onPressed: _exportAsJson,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (query) {
                context.read<ProductProvider>().search(query);
              },
            ),
          ),
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.filteredProducts.isEmpty) {
                  return const Center(
                    child: Text('No products found. Create one to get started!'),
                  );
                }

                return ListView.builder(
                  itemCount: provider.filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = provider.filteredProducts[index];
                    return ProductCard(product: product);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create-product');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
