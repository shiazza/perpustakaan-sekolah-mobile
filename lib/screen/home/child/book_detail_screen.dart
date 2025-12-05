// lib/screen/home/child/book_detail_screen.dart
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
// Sesuaikan path ini dengan project kamu
import '../../../../app_settings.dart'; 
import 'writers_detail_screen.dart'; 
import 'category_books_screen.dart'; 

class BookDetailScreen extends StatefulWidget {
  final String title;
  final String author;
  final String genre;
  final Color coverColor;
  final String heroTag; 
  final String? imageUrl;

  const BookDetailScreen({
    super.key,
    required this.title,
    required this.author,
    required this.genre,
    this.coverColor = const Color(0xFFF4A261),
    required this.heroTag,
    this.imageUrl,
  });

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Animasi elemen internal (Text muncul perlahan) - Hanya dipakai kalau Fancy On
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.easeOut)),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3), 
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.7, curve: Curves.easeOutQuart)),
    );

    // Jalankan controller
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Navigasi internal
  void _navigateTo(Widget screen) {
    if (AppSettings.enableFancyAnimation) {
      // MODE MEWAH: Custom Slide + Fade
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, __, ___) => screen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
             final curve = CurvedAnimation(parent: animation, curve: Curves.easeOutQuart);
             return FadeTransition(
                opacity: curve,
                child: SlideTransition(
                  position: Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero).animate(curve),
                  child: child,
                ),
             );
          },
        ),
      );
    } else {
      // MODE RINGAN: Bawaan HP
      Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    }
  }

  Widget _buildPlaceholder() {
    return Stack(
      children: [
        Positioned(right: -20, top: -20, child: CircleAvatar(radius: 60, backgroundColor: Colors.white.withOpacity(0.2))),
        const Center(child: Icon(CupertinoIcons.book_solid, size: 60, color: Colors.white)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // AMBIL SETTINGAN GLOBAL
    final bool useFancyAnim = AppSettings.enableFancyAnimation;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseBgColor = Theme.of(context).scaffoldBackgroundColor;
    final sheetColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textMain = isDark ? Colors.white : const Color(0xFF5D3A1A);
    final textSub = isDark ? Colors.grey[400] : const Color(0xFF8D5524);
    final statsBoxColor = isDark ? const Color(0xFF2C2C2C) : const Color(0xFFFFF4DF);
    final primaryOrange = const Color(0xFFF4A261);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            // Jika Fancy OFF, Back button langsung muncul (tidak fade)
            icon: useFancyAnim 
                ? FadeTransition(
                    opacity: _fadeAnim,
                    child: _buildBackBtn(),
                  )
                : _buildBackBtn(), 
            onPressed: () => Navigator.pop(context),
          ),
        ),
        
        body: Stack(
          children: [
            // 1. Background
            Positioned.fill(child: Container(color: baseBgColor)),
            
            // 2. Cover Color Overlay (Dimmer)
            Positioned.fill(
              child: useFancyAnim 
                  ? FadeTransition(
                      opacity: _fadeAnim,
                      child: Container(color: widget.coverColor.withOpacity(0.1)),
                    )
                  : Container(color: widget.coverColor.withOpacity(0.1)), // Instant
            ),
            
            // 3. Effect (Blur / Dim)
            Positioned.fill(
              child: useFancyAnim
                  // FANCY: Fade + Blur
                  ? FadeTransition(
                      opacity: _fadeAnim,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), 
                        child: Container(color: Colors.black.withOpacity(0.1))
                      ),
                    )
                  // REDUCED: Langsung Gelap Tanpa Animasi
                  : Container(color: (isDark ? Colors.black : Colors.white).withOpacity(0.8)), 
            ),

            Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top + 20),
                
                // HERO & IMAGE
                Center(
                  child: Hero(
                    tag: widget.heroTag, 
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        width: 160, height: 240,
                        decoration: BoxDecoration(
                          color: widget.coverColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))
                          ],
                        ),
                        child: widget.imageUrl != null && widget.imageUrl!.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  widget.imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_,__,___) => _buildPlaceholder(),
                                ),
                              )
                            : _buildPlaceholder(),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),

                // CONTENT SHEET
                Expanded(
                  child: SlideTransition(
                    // Kalau Fancy OFF: Offset Zero (Langsung di posisi akhir)
                    position: useFancyAnim ? _slideAnim : AlwaysStoppedAnimation(Offset.zero),
                    child: Container(
                      width: double.infinity,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: sheetColor, 
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))
                        ]
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            _AnimatedSection(
                              controller: _controller, startTime: 0.35, useFancyAnim: useFancyAnim,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(widget.title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textMain, height: 1.2)),
                                        const SizedBox(height: 4),
                                        GestureDetector(
                                          onTap: () => _navigateTo(WritersDetailScreen(authorName: widget.author)),
                                          child: Row(
                                            children: [
                                              Text(widget.author, style: TextStyle(fontSize: 16, color: textSub, fontWeight: FontWeight.w600)),
                                              const SizedBox(width: 4),
                                              Icon(Icons.arrow_forward_ios_rounded, size: 12, color: textSub),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(color: primaryOrange.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                                    child: const Text('Gratis', style: TextStyle(color: Color(0xFFD67D3E), fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Stats
                            _AnimatedSection(
                              controller: _controller, startTime: 0.50, useFancyAnim: useFancyAnim,
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(color: statsBoxColor, borderRadius: BorderRadius.circular(16)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildStatItem('Rating', '4.8', Icons.star_rounded, Colors.orange, textSub!),
                                    _buildVerticalDivider(isDark),
                                    _buildStatItem('Halaman', '240', Icons.menu_book_rounded, textSub, textSub),
                                    _buildVerticalDivider(isDark),
                                    _buildStatItem('Bahasa', 'ID', Icons.language_rounded, textSub, textSub),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Sinopsis
                            _AnimatedSection(
                              controller: _controller, startTime: 0.65, useFancyAnim: useFancyAnim,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Sinopsis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textMain)),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Buku ini membahas tentang ${widget.title} secara mendalam...',
                                    style: TextStyle(fontSize: 14, height: 1.6, color: isDark ? Colors.grey[300] : Colors.grey.shade700),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Kategori
                            _AnimatedSection(
                              controller: _controller, startTime: 0.75, useFancyAnim: useFancyAnim,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Kategori', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textMain)),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      _buildCategoryChip(widget.genre, isActive: true, isDark: isDark),
                                      _buildCategoryChip('Best Seller', isDark: isDark),
                                      _buildCategoryChip('Rekomendasi', isDark: isDark),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // BUTTON FLOATING
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: _AnimatedSection(
                controller: _controller, startTime: 0.8, slideOffset: 0.5, useFancyAnim: useFancyAnim,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                  decoration: BoxDecoration(
                    color: sheetColor,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))],
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 52, width: 52,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white10 : Colors.grey.shade100, 
                          borderRadius: BorderRadius.circular(16), 
                          border: Border.all(color: isDark ? Colors.transparent : Colors.grey.shade300)
                        ),
                        child: Icon(Icons.bookmark_border_rounded, color: textMain),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryOrange, 
                            foregroundColor: Colors.white, 
                            fixedSize: const Size.fromHeight(52), 
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
                          ),
                          child: const Text('Pinjam Buku', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPERS ---
  
  Widget _buildBackBtn() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.3), shape: BoxShape.circle),
      child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
    );
  }

  Widget _buildCategoryChip(String label, {bool isActive = false, required bool isDark}) {
    return GestureDetector(
      onTap: () => _navigateTo(CategoryBooksScreen(categoryName: label, totalBooks: 15)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFF4A261) : (isDark ? Colors.white10 : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? Colors.transparent : (isDark ? Colors.white12 : Colors.grey.shade300)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : (isDark ? Colors.white70 : Colors.grey.shade700),
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color iconColor, Color textColor) {
    return Column(children: [
      Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)), 
      const SizedBox(height: 4), 
      Row(children: [
        Icon(icon, size: 16, color: iconColor), 
        const SizedBox(width: 4), 
        Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textColor)) 
      ])
    ]);
  }

  Widget _buildVerticalDivider(bool isDark) => Container(height: 30, width: 1, color: isDark ? Colors.white12 : Colors.grey.shade300);
}

// --- LOGIKA UTAMA PERUBAHAN ---
class _AnimatedSection extends StatelessWidget {
  final AnimationController controller;
  final double startTime;
  final Widget child;
  final double slideOffset;
  final bool useFancyAnim; 

  const _AnimatedSection({required this.controller, required this.startTime, required this.child, this.slideOffset = 0.2, required this.useFancyAnim});

  @override
  Widget build(BuildContext context) {
    // 1. JIKA FANCY (Default): Pakai Animasi Slide & Fade
    if (useFancyAnim) {
      final endTime = (startTime + 0.2).clamp(0.0, 1.0);
      final animationCurve = CurvedAnimation(parent: controller, curve: Interval(startTime, endTime, curve: Curves.easeOut));
      
      return FadeTransition(
        opacity: Tween<double>(begin: 0, end: 1).animate(animationCurve), 
        child: SlideTransition(
          position: Tween<Offset>(begin: Offset(0, slideOffset), end: Offset.zero).animate(animationCurve), 
          child: child
        )
      );
    } 
    // 2. JIKA REDUCED (Kurangi Animasi): LANGSUNG RETURN CHILD (Tanpa Fade, Tanpa Slide)
    else {
      return child; 
    }
  }
}