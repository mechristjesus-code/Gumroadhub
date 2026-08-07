import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';

class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({super.key});

  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _descController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty || double.tryParse(value) == null ? 'Enter valid price' : null,
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) => value!.isEmpty ? 'Please enter description' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newProduct = Product(
                      id: const Uuid().v4(),
                      name: _nameController.text,
                      price: double.parse(_priceController.text),
                      description: _descController.text,
                    );
                    context.read<ProductProvider>().addProduct(newProduct);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
