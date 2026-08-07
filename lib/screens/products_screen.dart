import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import '../services/export_service.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ProductProvider>().fetchProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              final products = context.read<ProductProvider>().products;
              final csv = ExportService.toCSV(products);
              debugPrint('Exported CSV: $csv');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Products exported to console (CSV)')),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (query) => context.read<ProductProvider>().search(query),
            ),
          ),
        ),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.filteredProducts.isEmpty) {
            return const Center(child: Text('No products found.'));
          }
          return ListView.builder(
            itemCount: provider.filteredProducts.length,
            itemBuilder: (context, index) => ProductCard(product: provider.filteredProducts[index]),
          );
        },
      ),
    );
  }
}
