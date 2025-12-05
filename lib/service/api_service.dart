// lib/service/api_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/api_models.dart';
import 'auth_service.dart'; 

class ApiService {
  // Pastikan ini 10.0.2.2 jika pakai Emulator Android, atau IP Laptop jika HP Asli
  final String baseUrl = AuthService.baseUrl; 
  
  // Helper untuk URL Gambar
  // HATI-HATI: Jangan pake 'localhost' di sini kalau di Emulator/HP.
  // Gunakan IP yang sama dengan AuthService.baseUrl tapi port 8000/storage
  String get storageUrl {
     // Trik: Ambil base URL, hapus '/api' di belakang, tambah '/storage'
     return baseUrl.replaceAll('/api', '/storage');
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // --- GET PROFILE ---
  Future<User?> getUserProfile() async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/user');

    print("Fetching Profile: $url"); // DEBUG 1

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json', // Wajib biar Laravel gak kirim HTML login
      });

      print("Status Code: ${response.statusCode}"); // DEBUG 2
      
      if (response.statusCode == 200) {
        // Coba decode
        try {
           final body = jsonDecode(response.body);
           // Sesuaikan dengan format return API kamu. 
           // Kalau return-nya { "data": { ... } }, pakai body['data']
           // Kalau langsung { "id": ... }, pakai body
           return User.fromJson(body['data']); 
        } catch (e) {
           print("Error Parsing JSON: $e");
           print("Body server: ${response.body}"); // <--- INI BAKAL KASIH TAU ISI HTML NYA
           throw Exception("Server tidak mengirim JSON yang valid.");
        }
      } else {
        print("Server Error (${response.statusCode}): ${response.body}");
        return null;
      }
    } catch (e) {
      print("Connection Error: $e");
      rethrow;
    }
  }

  // --- GET HOME DATA ---
  Future<Map<String, dynamic>> getHomeData() async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/home');
    
    print("Fetching Home: $url");

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body)['data'];
        
        List<Book> recommended = (data['recommendations'] as List)
            .map((e) => Book.fromJson(e)).toList();
        
        List<Category> categories = (data['categories'] as List)
            .map((e) => Category.fromJson(e)).toList();
            
        List<Book> newArrivals = (data['new_arrivals'] as List)
            .map((e) => Book.fromJson(e)).toList();

        return {
          'recommendations': recommended,
          'categories': categories,
          'new_arrivals': newArrivals,
        };
      } catch (e) {
         print("JSON Parse Error di Home: $e");
         print("Raw Body: ${response.body}");
         throw Exception('Format data server salah');
      }
    } else {
      print("Home API Error: ${response.statusCode} - ${response.body}");
      throw Exception('Gagal load home data');
    }
  }

  // --- LOGOUT ---
  Future<bool> logout() async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/logout');

    final response = await http.post(url, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

  // STATUSSSS
    if (response.statusCode == 200 || response.statusCode == 401) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear(); 
      return true;
    }
    return false;
  }
}