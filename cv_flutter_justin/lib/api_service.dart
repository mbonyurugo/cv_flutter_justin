import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'famillemambre.dart';

class ApiService {
  static const String baseUrl = 'http://localhost/api-test/public';

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  static Map<String, dynamic> _decode(String body) {
    if (body.isEmpty) return {};
    final decoded = jsonDecode(body);
    return decoded is Map<String, dynamic> ? decoded : {'data': decoded};
  }

  static String _errorMsg(Map<String, dynamic> data, int statusCode) {
    if (data['message'] != null && data['message'].toString().isNotEmpty) {
      return data['message'].toString();
    }
    if (data['errors'] is Map && (data['errors'] as Map).isNotEmpty) {
      return (data['errors'] as Map).values.first.toString();
    }
    return 'Erreur HTTP $statusCode';
  }

  static Future<dynamic> register({
    required String email,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/accounts/register'),
      headers: _headers,
      body: jsonEncode({'email': email, 'password': password}),
    );
    final data = _decode(res.body);
    if (res.statusCode == 200 || res.statusCode == 201) {
      return data['data'] ?? data;
    }
    throw Exception(_errorMsg(data, res.statusCode));
  }

  static Future<dynamic> login({
    required String email,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/accounts/login'),
      headers: _headers,
      body: jsonEncode({'email': email, 'password': password}),
    );
    final data = _decode(res.body);
    if (res.statusCode == 200) {
      return data['data'] ?? data;
    }
    throw Exception(_errorMsg(data, res.statusCode));
  }

  static Future<List<FamilleMembre>> getMembres() async {
    final res = await http.get(
      Uri.parse('$baseUrl/famille-membres'),
      headers: {'Accept': 'application/json'},
    );
    final data = _decode(res.body);
    if (res.statusCode == 200) {
      final list = data['data'];
      if (list is List) {
        return list
            .map((e) => FamilleMembre.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      }
      return [];
    }
    throw Exception(_errorMsg(data, res.statusCode));
  }

  static Future<FamilleMembre> createMembre(FamilleMembre membre) async {
    final res = await http.post(
      Uri.parse('$baseUrl/famille-membres'),
      headers: _headers,
      body: jsonEncode(membre.toJson()),
    );
    final data = _decode(res.body);
    if (res.statusCode == 200 || res.statusCode == 201) {
      return FamilleMembre.fromJson(
        Map<String, dynamic>.from(data['data'] as Map),
      );
    }
    throw Exception(_errorMsg(data, res.statusCode));
  }

  static Future<FamilleMembre> updateMembre(int id, FamilleMembre membre) async {
    final res = await http.put(
      Uri.parse('$baseUrl/famille-membres/$id'),
      headers: _headers,
      body: jsonEncode(membre.toJson()),
    );
    final data = _decode(res.body);
    if (res.statusCode == 200) {
      return FamilleMembre.fromJson(
        Map<String, dynamic>.from(data['data'] as Map),
      );
    }
    throw Exception(_errorMsg(data, res.statusCode));
  }

  static Future<void> deleteMembre(int id) async {
    final res = await http.delete(
      Uri.parse('$baseUrl/famille-membres/$id'),
      headers: {'Accept': 'application/json'},
    );
    final data = _decode(res.body);
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception(_errorMsg(data, res.statusCode));
    }
  }
}