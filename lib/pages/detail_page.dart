import 'package:flutter/material.dart';
import '../models/pakaian.dart';
import '../services/api_service.dart';
import 'edit_page.dart';

class DetailPage extends StatefulWidget {
  final Pakaian clothing;
  const DetailPage({super.key, required this.clothing});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Pakaian _clothing;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _clothing = widget.clothing;
  }

  Future<void> _refreshData() async {
    setState(() => _isLoading = true);
    try {
      final updated = await ApiService.fetchClothing(_clothing.id!);
      setState(() => _clothing = updated);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to refresh data')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(_clothing.name),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: _refreshData,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 250,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFc084fc), Color(0xFF8ec5fc)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          top: 100,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Hero(
                              tag: 'cloth-${_clothing.name}',
                              child: Icon(
                                Icons.checkroom,
                                size: 100,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              _infoRow('Category', _clothing.category),
                              _infoRow('Brand', _clothing.brand),
                              _infoRow('Material', _clothing.material),
                              _infoRow('Price', 'Rp${_clothing.price}'),
                              _infoRow('Stock', '${_clothing.stock} pcs'),
                              _infoRow('Sold', '${_clothing.sold} pcs'),
                              _infoRow('Rating', '${_clothing.rating} ★'),
                              _infoRow(
                                'Year Released',
                                '${_clothing.yearReleased}',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => EditPage(clothing: _clothing),
            ),
          );
          if (result == true) {
            await _refreshData();
            Navigator.pop(context, true);
          }
        },
        icon: const Icon(Icons.edit),
        label: const Text("Edit"),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
