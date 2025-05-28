import 'package:flutter/material.dart';
import '../models/pakaian.dart';
import '../services/api_service.dart';

class EditPage extends StatefulWidget {
  final Pakaian clothing;
  const EditPage({super.key, required this.clothing});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> _formData;

  @override
  void initState() {
    super.initState();
    _formData = {
      'name': widget.clothing.name,
      'price': widget.clothing.price,
      'category': widget.clothing.category,
      'brand': widget.clothing.brand,
      'sold': widget.clothing.sold,
      'rating': widget.clothing.rating,
      'stock': widget.clothing.stock,
      'yearReleased': widget.clothing.yearReleased,
      'material': widget.clothing.material,
    };
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final success = await ApiService.updateClothing(
        widget.clothing.id,
        _formData,
      );
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Clothing updated successfully')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Failed to update clothing')),
        );
      }
    }
  }

  String? _validateRating(String? value) {
    final rating = double.tryParse(value ?? '');
    if (rating == null) return 'Please enter a valid number';
    if (rating < 0 || rating > 5) return 'Rating must be between 0 and 5';
    return null;
  }

  String? _validateYearReleased(String? value) {
    final year = int.tryParse(value ?? '');
    if (year == null) return 'Please enter a valid year';
    if (year < 2018 || year > 2025) return 'Year must be between 2018 and 2025';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('✏️ Edit Clothing')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField('name', icon: Icons.shopping_bag),
              _buildTextField('category', icon: Icons.category),
              _buildTextField('brand', icon: Icons.local_offer),
              _buildTextField('material', icon: Icons.texture),
              _buildTextField(
                'price',
                isNumber: true,
                icon: Icons.attach_money,
              ),
              _buildTextField('sold', isNumber: true, icon: Icons.sell),
              _buildTextField(
                'rating',
                isDecimal: true,
                validator: _validateRating,
                icon: Icons.star,
              ),
              _buildTextField('stock', isNumber: true, icon: Icons.inventory),
              _buildTextField(
                'yearReleased',
                isNumber: true,
                validator: _validateYearReleased,
                icon: Icons.calendar_today,
              ),
              const SizedBox(height: 25),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.save),
                label: const Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String key, {
    bool isNumber = false,
    bool isDecimal = false,
    String? Function(String?)? validator,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        initialValue: _formData[key].toString(),
        decoration: InputDecoration(
          labelText: _capitalize(key),
          prefixIcon: icon != null ? Icon(icon) : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        keyboardType:
            isDecimal
                ? const TextInputType.numberWithOptions(decimal: true)
                : (isNumber ? TextInputType.number : TextInputType.text),
        onSaved: (value) {
          if (isNumber) {
            _formData[key] = int.tryParse(value ?? '') ?? 0;
          } else if (isDecimal) {
            _formData[key] = double.tryParse(value ?? '') ?? 0.0;
          } else {
            _formData[key] = value ?? '';
          }
        },
        validator:
            validator ??
            (value) =>
                (value == null || value.isEmpty)
                    ? 'This field is required'
                    : null,
      ),
    );
  }

  String _capitalize(String text) {
    return text.isNotEmpty ? text[0].toUpperCase() + text.substring(1) : text;
  }
}
