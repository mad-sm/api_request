import 'package:flutter/material.dart';
import '../models/pakaian.dart';
import '../services/api_service.dart';
import 'create_page.dart';
import 'detail_page.dart';
import '../widget/pakaian_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Pakaian>> clothes;

  @override
  void initState() {
    super.initState();
    clothes = ApiService.fetchClothes();
  }

  void refresh() {
    setState(() {
      clothes = ApiService.fetchClothes();
    });
  }

  void deleteClothing(int id) async {
    try {
      await ApiService.deleteClothing(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Clothing deleted successfully')),
      );
      refresh();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to delete clothing: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clothes List')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CreateClothingPage()),
          ).then((value) {
            if (value == true) {
              refresh();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Pakaian>>(
        future: clothes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data ?? [];

          if (data.isEmpty) {
            return const Center(child: Text('No clothes found'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.7,
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final cloth = data[index];
              return Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(12),
                clipBehavior: Clip.hardEdge,
                child: Stack(
                  children: [
                    InkWell(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailPage(clothing: cloth),
                          ),
                        );
                        if (result == true) refresh();
                      },
                      child: ClothingCard(cloth: cloth),
                    ),
                    Positioned(
                      right: 6,
                      top: 6,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.red.shade700.withOpacity(0.85),
                        child: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 20,
                          ),
                          splashRadius: 24,
                          tooltip: 'Delete',
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder:
                                  (ctx) => AlertDialog(
                                    title: const Text('Confirm Delete'),
                                    content: const Text(
                                      'Are you sure you want to delete this item?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(ctx);
                                          deleteClothing(cloth.id!);
                                        },
                                        child: const Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
