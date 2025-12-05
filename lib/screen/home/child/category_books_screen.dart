import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryBooksScreen extends StatefulWidget {
  final String categoryName;
  final int totalBooks;

  const CategoryBooksScreen({
    super.key, 
    required this.categoryName,
    required this.totalBooks,
  });

  @override
  State<CategoryBooksScreen> createState() => _CategoryBooksScreenState();
}

class _CategoryBooksScreenState extends State<CategoryBooksScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  // Dummy data list buku per kategori
  final List<String> _books = ['Flutter Expert', 'UI/UX Design', 'Product Management', 'Data Science', 'AI Basic', 'Cyber Security', 'Network Engineer'];

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
        backgroundColor: Colors.white,
        elevation: 0,
        // Tombol back simple
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // HEADER DESAIN MENARIK
          // Muncul pake FadeIn
          _AnimatedSimple(
            controller: _controller, startTime: 0.0, isIOS: isIOS,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul Kategori Besar
                  Text(
                    widget.categoryName,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Pill Jumlah Buku
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(CupertinoIcons.book, size: 14, color: Colors.grey.shade600),
                        const SizedBox(width: 6),
                        Text(
                          "${widget.totalBooks} Buku Tersedia",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),
          const Divider(height: 1),

          // LIST BUKU
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: _books.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                // Animasi per item
                // Staggered: Item muncul satu-satu
                final double start = 0.2 + (index * 0.1);
                
                return _AnimatedSimple(
                  controller: _controller,
                  startTime: start,
                  isIOS: isIOS,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))
                      ]
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          // Cover Buku
                          Container(
                            width: 70, height: 100,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4A261),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(color: Colors.orange.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))
                              ]
                            ),
                            child: const Center(child: Icon(CupertinoIcons.book_solid, color: Colors.white, size: 28)),
                          ),
                          const SizedBox(width: 16),
                          // Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_books[index], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                                const SizedBox(height: 4),
                                Text("Penulis A", style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                                const SizedBox(height: 10),
                                // Label Kategori kecil
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: const Color(0xFFFFF4DF), borderRadius: BorderRadius.circular(6)),
                                  child: Text(widget.categoryName, style: const TextStyle(fontSize: 10, color: Color(0xFFD67D3E), fontWeight: FontWeight.bold)),
                                )
                              ],
                            ),
                          ),
                          // Arrow
                          const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Helper Animasi yang sama (Biar gak duplikat code)
class _AnimatedSimple extends StatelessWidget {
  final AnimationController controller;
  final double startTime;
  final Widget child;
  final bool isIOS;

  const _AnimatedSimple({required this.controller, required this.startTime, required this.child, required this.isIOS});

  @override
  Widget build(BuildContext context) {
    // Clamp biar gak error value > 1.0
    final double safeEnd = (startTime + 0.4).clamp(0.0, 1.0);
    if (startTime >= 1.0) return child; // Safety check

    final anim = CurvedAnimation(
      parent: controller, 
      curve: Interval(startTime, safeEnd, curve: Curves.easeOut)
    );

    if (isIOS) {
       return FadeTransition(
         opacity: anim, 
         child: SlideTransition(
           position: Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(anim), 
           child: child
         )
       );
    }
    return FadeTransition(opacity: anim, child: child);
  }
}