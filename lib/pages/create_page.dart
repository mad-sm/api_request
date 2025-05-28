import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/pakaian.dart';
import '../services/api_service.dart';

class CreateClothingPage extends StatefulWidget {
  const CreateClothingPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateClothingPageState createState() => _CreateClothingPageState();
}

class _CreateClothingPageState extends State<CreateClothingPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _brandController = TextEditingController();
  final _soldController = TextEditingController();
  final _ratingController = TextEditingController();
  final _stockController = TextEditingController();
  final _yearReleasedController = TextEditingController();
  final _materialController = TextEditingController();

  bool _isLoading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final clothing = Pakaian(
      name: _nameController.text,
      price: int.parse(_priceController.text),
      category: _categoryController.text,
      brand: _brandController.text,
      sold: int.parse(_soldController.text),
      rating: double.parse(_ratingController.text),
      stock: int.parse(_stockController.text),
      yearReleased: int.parse(_yearReleasedController.text),
      material: _materialController.text,
    );

    setState(() {
      _isLoading = true;
    });

    try {
      await ApiService.createClothing(clothing);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text('Clothing created successfully!')));
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _brandController.dispose();
    _soldController.dispose();
    _ratingController.dispose();
    _stockController.dispose();
    _yearReleasedController.dispose();
    _materialController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.indigo;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create New Clothing',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: themeColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(
                    controller: _nameController,
                    label: 'Name',
                    icon: Icons.checkroom,
                    validator:
                        (v) =>
                            v == null || v.isEmpty ? 'Name is required' : null,
                  ),
                  _buildTextField(
                    controller: _priceController,
                    label: 'Price',
                    icon: Icons.attach_money,
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Price is required';
                      if (int.tryParse(v) == null) return 'Must be an integer';
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _categoryController,
                    label: 'Category',
                    icon: Icons.category,
                    validator:
                        (v) =>
                            v == null || v.isEmpty
                                ? 'Category is required'
                                : null,
                  ),
                  _buildTextField(
                    controller: _brandController,
                    label: 'Brand',
                    icon: Icons.loyalty,
                    validator:
                        (v) =>
                            v == null || v.isEmpty ? 'Brand is required' : null,
                  ),
                  _buildTextField(
                    controller: _soldController,
                    label: 'Sold',
                    icon: Icons.shopping_cart,
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Sold is required';
                      if (int.tryParse(v) == null) return 'Must be an integer';
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _ratingController,
                    label: 'Rating (0 - 5)',
                    icon: Icons.star,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Rating is required';
                      final r = double.tryParse(v);
                      if (r == null || r < 0 || r > 5) {
                        return 'Rating must be between 0 and 5';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _stockController,
                    label: 'Stock',
                    icon: Icons.inventory,
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Stock is required';
                      if (int.tryParse(v) == null) return 'Must be an integer';
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _yearReleasedController,
                    label: 'Year Released (2018 - 2025)',
                    icon: Icons.calendar_today,
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Year is required';
                      final y = int.tryParse(v);
                      if (y == null || y < 2018 || y > 2025) {
                        return 'Must be between 2018 and 2025';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _materialController,
                    label: 'Material',
                    icon: Icons.texture,
                    validator:
                        (v) =>
                            v == null || v.isEmpty
                                ? 'Material is required'
                                : null,
                  ),
                  SizedBox(height: 20),
                  _isLoading
                      ? CircularProgressIndicator()
                      : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          icon: Icon(Icons.save),
                          label: Text(
                            'Create Clothing',
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: _submit,
                        ),
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
