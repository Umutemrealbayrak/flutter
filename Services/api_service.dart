import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/address.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  // Tüm adresleri getir
  Future<List<Address>> getAddresses() async {
    final response = await http.get(Uri.parse('$baseUrl/api/addresses'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((e) => Address.fromJson(e)).toList();
    } else {
      throw Exception('API Hatası: ${response.statusCode}');
    }
  }

  // Belirli ID'ye sahip adresi getir
  Future<Address> getAddressById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/api/addresses/$id'));
    if (response.statusCode == 200) {
      return Address.fromJson(json.decode(response.body));
    } else {
      throw Exception('Adres bulunamadı: ${response.statusCode}');
    }
  }

  // Adresi güncelle
  Future<void> updateAddress(int id, Address address) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/addresses/$id'), // Küçük harfli endpoint
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(address.toJson()),
    );

    print("Güncelleme response: ${response.statusCode} ${response.body}");

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Adres güncellenemedi: ${response.statusCode}");
    }
  }

  // Yeni adres oluştur
  Future<void> createAddress(Address address) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/addresses'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(address.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception("Adres oluşturulamadı: ${response.statusCode}");
    }
  }
}
