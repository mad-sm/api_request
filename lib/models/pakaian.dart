class Pakaian {
  final int? id;
  final String name;
  final int price;
  final String category;
  final String brand;
  final int sold;
  final double rating;
  final int stock;
  final int yearReleased;
  final String material;

  Pakaian({
    this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.brand,
    required this.sold,
    required this.rating,
    required this.stock,
    required this.yearReleased,
    required this.material,
  });

  factory Pakaian.fromJson(Map<String, dynamic> json) {
    return Pakaian(
      id: json['id'],
      name: json['name'] ?? 'Unknown',
      price: json['price'] ?? 0,
      category: json['category'] ?? 'Unknown',
      brand: json['brand'] ?? 'Unknown',
      sold: json['sold'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      yearReleased: json['yearReleased'] ?? 0,
      material: json['material'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "price": price,
      "category": category,
      "brand": brand,
      "sold": sold,
      "rating": rating,
      "stock": stock,
      "yearReleased": yearReleased,
      "material": material,
    };
  }
}
