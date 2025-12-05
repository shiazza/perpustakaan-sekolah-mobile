// lib/screen/home/child/writers_detail_screen.dart
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WritersDetailScreen extends StatefulWidget {
  final String authorName;

  const WritersDetailScreen({super.key, required this.authorName});

  @override
  State<WritersDetailScreen> createState() => _WritersDetailScreenState();
}

class _WritersDetailScreenState extends State<WritersDetailScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  // Data Buku Karangan Penulis (Dummy)
  final List<String> _books = ['Buku Rahasia', 'Cara Menjadi Hebat', 'Flutter Masterclass', 'Dart Basic', 'Algoritma Hidup'];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isIOS = Platform.isIOS;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // Title di AppBar gw kosongin atau bisa diisi "Detail Penulis" kalau mau
        // Biar fokus ke Nama Besar di body
        title: const Text("Profil Penulis", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // FOTO DIHAPUS, LANGSUNG NAMA

            // NAMA (Start Time jadi 0.0 biar langsung muncul)
            _AnimatedSimple(
              controller: _controller, startTime: 0.0, isIOS: isIOS,
              child: Text(
                widget.authorName, 
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black)
              ),
            ),

             // BIO SINGKAT (Start Time 0.1)
            _AnimatedSimple(
              controller: _controller, startTime: 0.1, isIOS: isIOS,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  "${widget.authorName} adalah penulis profesional yang telah menerbitkan lebih dari 10 buku best seller di bidang teknologi dan sains.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600, height: 1.5),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // LIST BUKU HEADER (Start Time 0.2)
            _AnimatedSimple(
               controller: _controller, startTime: 0.2, isIOS: isIOS,
               child: Align(
                 alignment: Alignment.centerLeft,
                 child: Text("Buku Karya ${widget.authorName}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
               ),
            ),

            const SizedBox(height: 16),

            // GRID BUKU (Start Time 0.3 + Index)
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _books.length,
              itemBuilder: (context, index) {
                return _AnimatedSimple(
                  controller: _controller, 
                  startTime: 0.3 + (index * 0.1), // Staggered Animation
                  isIOS: isIOS,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200)
                    ),
                    child: ListTile(
                      leading: Container(
                        width: 40, height: 50,
                        decoration: BoxDecoration(
                          color: Colors.orange.shade200,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(CupertinoIcons.book_solid, color: Colors.white, size: 20),
                      ),
                      title: Text(_books[index], style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: const Text("Teknologi • 2024"),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                      onTap: () {
                        // Kalau mau drill down lagi ke detail buku, bisa di sini
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Helper Animasi Simpel
class _AnimatedSimple extends StatelessWidget {
  final AnimationController controller;
  final double startTime;
  final Widget child;
  final bool isIOS;

  const _AnimatedSimple({required this.controller, required this.startTime, required this.child, required this.isIOS});

  @override
  Widget build(BuildContext context) {
    final anim = CurvedAnimation(parent: controller, curve: Interval(startTime, (startTime + 0.4).clamp(0, 1), curve: Curves.easeOut));
    if (isIOS) {
       return FadeTransition(opacity: anim, child: SlideTransition(position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(anim), child: child));
    }
    return FadeTransition(opacity: anim, child: child);
  }
}