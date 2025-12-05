import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // GANTI IP INI SESUAI DEVICE KALIAN:
  // Emulator Android: 'http://10.0.2.2:8000/api'
  // Apple Simulator / Web Browser (Chrome dkk...): 'http://127.0.0.1:8000/api'
  // HP Asli: 'http://192.168.1.x:8000/api' (Cek IP laptop pake ipconfig/ifconfig)
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json', // Wajib biar Laravel tau ini request API
        },
        body: {
          'email': email,
          'password': password,
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Login Sukses
        String token = data['token'];
        
        // Simpan token di HP biar gak perlu login ulang nanti
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('user_name', data['user']['name']); // Opsional

        return {'success': true, 'message': 'Login berhasil'};
      } else {
        // Login Gagal (Password salah / validasi error)
        return {
          'success': false, 
          'message': data['message'] ?? 'Login gagal, cek kredensial.'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Gagal koneksi ke server: $e'};
    }
  }
}