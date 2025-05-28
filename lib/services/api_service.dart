import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pakaian.dart';

class ApiService {
  static const String baseUrl =
      'https://tpm-api-tugas-872136705893.us-central1.run.app/api/clothes';

  /// Ambil semua data baju
  static Future<List<Pakaian>> fetchClothes() async {
    final res = await http.get(Uri.parse(baseUrl));
    if (res.statusCode == 200) {
      final jsonData = json.decode(res.body);
      if (jsonData['status'] == 'Success') {
        final List data = jsonData['data'];
        return data.map((e) => Pakaian.fromJson(e)).toList();
      } else {
        throw Exception('API error: ${jsonData['message']}');
      }
    } else {
      throw Exception(
        'Failed to load clothes with status code ${res.statusCode}',
      );
    }
  }

  /// Ambil detail baju berdasarkan ID
  static Future<Pakaian> fetchClothing(int id) async {
    final res = await http.get(Uri.parse('$baseUrl/$id'));
    if (res.statusCode == 200) {
      final jsonData = json.decode(res.body);
      if (jsonData['status'] == 'Success') {
        return Pakaian.fromJson(jsonData['data']);
      } else {
        throw Exception('API error: ${jsonData['message']}');
      }
    } else if (res.statusCode == 404) {
      throw Exception('Clothing not found');
    } else {
      throw Exception(
        'Failed to fetch clothing with status code ${res.statusCode}',
      );
    }
  }

  /// Buat data baru
  static Future<void> createClothing(Pakaian cloth) async {
    final body = json.encode(cloth.toJson());
    print('Request Body: $body');

    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    print('Response status: ${res.statusCode}');
    print('Response body: ${res.body}');

    if (res.statusCode == 201) {
      final jsonData = json.decode(res.body);
      if (jsonData['status'] != 'Success') {
        throw Exception('Create failed: ${jsonData['message']}');
      }
    } else {
      throw Exception('Create failed with status code ${res.statusCode}');
    }
  }

  /// Update data berdasarkan ID
  /// Return true jika sukses, false jika gagal
  /// Bisa lempar exception untuk error spesifik (optional)
  static Future<bool> updateClothing(int? id, Map<String, dynamic> data) async {
    if (id == null) return false;

    final url = Uri.parse('$baseUrl/$id');
    final body = json.encode(data);

    print('Update request body: $body');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    print('Update response status: ${response.statusCode}');
    print('Update response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['status'] == 'Success') {
        return true;
      } else {
        print('Update error message: ${jsonData['message']}');
        return false;
      }
    } else {
      print('Update failed with status code: ${response.statusCode}');
      return false;
    }
  }

  /// Hapus data berdasarkan ID
  static Future<void> deleteClothing(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/$id'));

    print('Delete response status: ${res.statusCode}');
    print('Delete response body: ${res.body}');

    if (res.statusCode == 200) {
      final jsonData = json.decode(res.body);
      if (jsonData['status'] != 'Success') {
        throw Exception('Delete failed: ${jsonData['message']}');
      }
    } else if (res.statusCode == 404) {
      throw Exception('Clothing not found');
    } else {
      throw Exception('Delete failed with status code ${res.statusCode}');
    }
  }
}
