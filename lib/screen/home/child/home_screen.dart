// lib/screen/home/child/home_screen.dart
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../app_settings.dart'; 
import '../../../service/api_service.dart';
import '../../../models/api_models.dart';
import 'book_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  late Future<Map<String, dynamic>> _homeDataFuture;

  @override
  void initState() {
    super.initState();
    _homeDataFuture = _apiService.getHomeData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _homeDataFuture = _apiService.getHomeData();
    });
    await _homeDataFuture;
  }

  @override
  Widget build(BuildContext context) {
    final double navOverlap = 22 + 60; 
    final double bottomSafe = MediaQuery.of(context).padding.bottom;
    
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary = isDark ? Colors.grey[400] : Colors.grey[600];
    final sectionTitleColor = Theme.of(context).textTheme.titleLarge?.color;

    return SafeArea(
      top: true,
      bottom: false,
      child: FutureBuilder<Map<String, dynamic>>(
        future: _homeDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFF4A261)));
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text("Gagal memuat data", style: TextStyle(color: textSecondary)),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _refreshData, 
                    child: const Text("Coba Lagi", style: TextStyle(color: Color(0xFFF4A261)))
                  )
                ],
              ),
            );
          }

          final data = snapshot.data ?? {};
          final List<Book> recommendations = (data['recommendations'] as List<Book>?) ?? [];
          final List<Book> newArrivals = (data['new_arrivals'] as List<Book>?) ?? [];

          return RefreshIndicator(
            onRefresh: _refreshData,
            color: const Color(0xFFF4A261),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(25, 20, 25, bottomSafe + navOverlap),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_formatTanggal(DateTime.now()), style: TextStyle(fontSize: 12, color: textSecondary, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Text("Beranda", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: sectionTitleColor)),
                  const SizedBox(height: 30),

                  Text("Transaksi", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: sectionTitleColor)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _TransaksiButton(icon: CupertinoIcons.book, label: "Pinjam")),
                      const SizedBox(width: 12),
                      Expanded(child: _TransaksiButton(icon: CupertinoIcons.arrow_2_circlepath, label: "Kembali")),
                    ],
                  ),

                  const SizedBox(height: 32),

                  Text("Rekomendasi", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: sectionTitleColor)),
                  const SizedBox(height: 14),
                  if (recommendations.isEmpty)
                    _buildEmptyState("Belum ada rekomendasi")
                  else
                    SizedBox(
                      height: 180,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        itemCount: recommendations.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) => _BookCardVertical(
                          book: recommendations[index], 
                          heroTag: "rec-${recommendations[index].id}"
                        ),
                      ),
                    ),

                  const SizedBox(height: 32),

                  Text("Buku Terbaru", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: sectionTitleColor)),
                  const SizedBox(height: 14),
                  if (newArrivals.isEmpty)
                    _buildEmptyState("Belum ada buku baru")
                  else
                    SizedBox(
                      height: 140,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        itemCount: newArrivals.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) => _BookCardVertical(
                          book: newArrivals[index],
                          heroTag: "new-${newArrivals[index].id}"
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(String msg) {
    return Container(
      height: 100, width: double.infinity, alignment: Alignment.center,
      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(msg, style: const TextStyle(color: Colors.grey)),
    );
  }
}

class _BookCardVertical extends StatelessWidget {
  final Book book;
  final String heroTag;

  const _BookCardVertical({required this.book, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final imageUrl = "${ApiService().storageUrl}/${book.image}";
    final hasImage = book.image != null && book.image!.isNotEmpty;
    
    // CEK LOGIKA ANIMASI
    // true = Default (Bagus), false = Kurangi Animasi
    final bool enableAnimation = AppSettings.enableFancyAnimation;

    // --- WIDGET GAMBAR BUKU (Dipisah biar rapi) ---
    Widget bookContent = Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity, height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Color(0xFFFFD39B), Color(0xFFF4A261)],
          ),
        ),
        child: hasImage 
            ? Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (ctx, err, stack) => const Center(child: Icon(Icons.broken_image, color: Colors.white54)))
            : Stack(children: [
                Positioned(right: -20, top: -20, child: CircleAvatar(radius: 60, backgroundColor: Colors.white.withOpacity(0.2))),
                const Center(child: Icon(CupertinoIcons.book_solid, size: 50, color: Colors.white)),
              ]),
      ),
    );

    return GestureDetector(
      onTap: () {
        // NAVIGASI
        if (enableAnimation) {
          // 1. ANIMASI MEWAH (Custom Morphing)
          Navigator.push(
            context,
            PageRouteBuilder(
              opaque: false,
              barrierColor: Colors.black.withOpacity(0.01),
              transitionDuration: const Duration(milliseconds: 650),
              reverseTransitionDuration: const Duration(milliseconds: 500),
              pageBuilder: (_, __, ___) => BookDetailScreen(
                title: book.title, author: book.author, genre: book.genre,
                coverColor: const Color(0xFFF4A261), heroTag: heroTag, imageUrl: imageUrl,
              ),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                final curve = CurvedAnimation(parent: animation, curve: Curves.easeOutQuart);
                final radiusAnim = Tween<double>(begin: 80, end: 0).animate(curve);
                final slideAnim = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(curve);
                return AnimatedBuilder(
                  animation: curve,
                  builder: (context, child) => ClipRRect(borderRadius: BorderRadius.circular(radiusAnim.value), child: child),
                  child: FadeTransition(opacity: curve, child: SlideTransition(position: slideAnim, child: child)),
                );
              },
            ),
          );
        } else {
          // 2. ANIMASI BAWAAN HP (Tanpa Morphing, Tanpa Hero Terbang)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BookDetailScreen(
                title: book.title, author: book.author, genre: book.genre,
                coverColor: const Color(0xFFF4A261), heroTag: heroTag, imageUrl: imageUrl,
              ),
            ),
          );
        }
      },
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.12),
              blurRadius: 12, offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // --- LOGIKA UTAMA: MATIKAN HERO JIKA ANIMASI DIKURANGI ---
              enableAnimation 
                  ? Hero(tag: heroTag, child: bookContent) // Pakai Hero (Terbang)
                  : bookContent, // Gak Pakai Hero (Diam aja)
              
              // Teks Judul & Penulis
              Positioned(
                left: 10, right: 10, bottom: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(book.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.white, decoration: TextDecoration.none, shadows: [Shadow(color: Colors.black54, blurRadius: 6, offset: Offset(0, 2))])),
                    const SizedBox(height: 4),
                    Text(book.author, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Colors.white70, decoration: TextDecoration.none, shadows: [Shadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 1))])),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TransaksiButton extends StatelessWidget {
  final IconData icon;
  final String label;
  const _TransaksiButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFFFF4DF),
        borderRadius: BorderRadius.circular(14),
        border: isDark ? Border.all(color: Colors.white10) : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: const Color(0xFFF4A261)),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : Colors.black87)),
        ],
      ),
    );
  }
}

String _formatTanggal(DateTime date) {
  final List<String> hari = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
  final List<String> bulan = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
  return '${hari[date.weekday - 1]}, ${date.day} ${bulan[date.month - 1]}';
}