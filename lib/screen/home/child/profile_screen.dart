import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../../../service/api_service.dart'; 
import '../../../../models/api_models.dart';

import 'settings_screen.dart';
import 'loan_screen.dart'; // Buat history peminjaman
import 'return_screen.dart'; // Buat history pengembalian

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // 1. FUNGSI AMBIL DATA (Dengan Error Handling)
  Future<void> _loadUserProfile() async {
    setState(() => _isLoading = true); // Pastikan loading nyala saat refresh
    try {
      final user = await _apiService.getUserProfile();
      
      if (mounted) {
        setState(() {
          _user = user;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        // Jangan crash, tampilkan pesan error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat profil: ${e.toString().replaceAll("Exception:", "")}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  // 2. FUNGSI LOGOUT
  void _handleLogout() async {
    // Tampilkan Dialog Loading
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator(color: Color(0xFFF4A261)))
    );

    try {
      final success = await _apiService.logout();
      
      if (!mounted) return;
      Navigator.pop(context); // Tutup Dialog

      if (success) {
        // Balik ke Login & Hapus semua history page sebelumnya
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal Logout, sesi mungkin sudah habis.')),
        );
        // Force logout jika perlu
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      }
    } catch (e) {
      Navigator.pop(context); // Tutup dialog jika error
    }
  }

  @override
  Widget build(BuildContext context) {
    // Style Variables
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final borderColor = isDark ? Colors.white10 : Colors.grey.shade200;
    final textColor = isDark ? Colors.white : Colors.black87;

    // Logic Foto Profil
    String? photoUrl;
    if (_user?.photo != null && _user!.photo!.isNotEmpty) {
      // Pastikan storageUrl di ApiService benar (biasanya: http://ip:8000/storage)
      photoUrl = "${_apiService.storageUrl}/${_user!.photo}";
    }

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF9F9F9),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadUserProfile,
          color: const Color(0xFFF4A261),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            children: [
              
              // --- HEADER PROFILE ---
              Row(
                children: [
                  // AVATAR
                  Container(
                    width: 70, height: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF4DF),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFF4A261), width: 2),
                      image: photoUrl != null 
                          ? DecorationImage(image: NetworkImage(photoUrl), fit: BoxFit.cover)
                          : null,
                    ),
                    child: photoUrl == null 
                        ? const Icon(Icons.person, size: 35, color: Color(0xFFF4A261))
                        : null,
                  ),
                  
                  const SizedBox(width: 20),
                  
                  // TEXT INFO
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_isLoading) ...[
                          // Skeleton Animation kalau lagi loading
                          Container(width: 140, height: 20, decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(4))),
                          const SizedBox(height: 8),
                          Container(width: 100, height: 14, decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(4))),
                        ] else ...[
                          // Data User
                          Text(
                            _user?.name ?? 'Pengunjung',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _user?.email ?? 'Silahkan login kembali',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                        ]
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // --- GROUP: AKTIVITAS ---
              _buildSectionTitle('Aktivitas Saya', isDark),
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
                  ]
                ),
                child: Column(
                  children: [
                    _buildTile(
                      context: context,
                      icon: CupertinoIcons.book_fill,
                      color: Colors.blueAccent,
                      title: 'Peminjaman',
                      subtitle: 'Riwayat buku yang dipinjam',
                      onTap: () {
                         // Pastikan class LoanScreen ada atau ganti Placeholder()
                         Navigator.push(context, CupertinoPageRoute(builder: (_) => const LoanScreen()));
                      },
                      isLast: false,
                    ),
                    _buildTile(
                      context: context,
                      icon: CupertinoIcons.arrow_2_circlepath_circle_fill,
                      color: Colors.green,
                      title: 'Pengembalian',
                      subtitle: 'Riwayat buku yang dikembalikan',
                      onTap: () {
                         Navigator.push(context, CupertinoPageRoute(builder: (_) => const ReturnScreen()));
                      },
                      isLast: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // --- GROUP: AKUN ---
              _buildSectionTitle('Akun & Lainnya', isDark),
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
                  ]
                ),
                child: Column(
                  children: [
                    _buildTile(
                      context: context,
                      icon: CupertinoIcons.settings_solid,
                      color: Colors.grey.shade600,
                      title: 'Pengaturan',
                      onTap: () {
                        Navigator.push(context, CupertinoPageRoute(builder: (_) => const SettingsScreen()));
                      },
                      isLast: false,
                    ),
                    _buildTile(
                      context: context,
                      icon: CupertinoIcons.info_circle_fill,
                      color: Colors.orange,
                      title: 'Tentang Aplikasi',
                      onTap: () {},
                      isLast: false,
                    ),
                    _buildTile(
                      context: context,
                      icon: Icons.logout_rounded,
                      color: Colors.redAccent,
                      title: 'Keluar',
                      textColor: Colors.redAccent,
                      onTap: _handleLogout,
                      isLast: true, // Hilangkan divider di item terakhir
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPER ---

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16, 
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.white70 : Colors.black87
        ),
      ),
    );
  }

  Widget _buildTile({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? textColor,
    required bool isLast,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: textColor ?? (isDark ? Colors.white : Colors.black87),
            ),
          ),
          subtitle: subtitle != null 
              ? Text(subtitle, style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.grey))
              : null,
          trailing: Icon(CupertinoIcons.chevron_right, size: 16, color: isDark ? Colors.white24 : Colors.grey.shade300),
          onTap: onTap,
        ),
        if (!isLast) 
          Divider(height: 1, indent: 70, color: isDark ? Colors.white10 : Colors.grey.shade100),
      ],
    );
  }
}