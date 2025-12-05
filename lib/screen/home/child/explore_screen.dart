// lib/screen/home/child/explore_screen.dart
import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'category_books_screen.dart'; 

class ExploreScreen extends StatefulWidget {
  final ValueChanged<bool>? onSearchBarActiveChanged;

  const ExploreScreen({super.key, this.onSearchBarActiveChanged});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  
  bool _showSearchBar = false;
  String _query = '';

  final List<Map<String, String>> _allBooks = [
    {'title': 'Pemrograman Dart', 'author': 'Andi', 'genre': 'Teknologi'},
    {'title': 'Flutter untuk Pemula', 'author': 'Budi', 'genre': 'Teknologi'},
    {'title': 'Algoritma Dasar', 'author': 'Cici', 'genre': 'Teknologi'},
    {'title': 'Matematika Diskrit', 'author': 'Dewi', 'genre': 'Sains'},
    {'title': 'Fisika Modern', 'author': 'Eka', 'genre': 'Sains'},
    {'title': 'Kimia Organik', 'author': 'Fajar', 'genre': 'Sains'},
  ];

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_showSearchBar && !_searchFocusNode.hasFocus && _query.isEmpty) {
      _setShowSearchBar(false);
    }
  }

  void _setShowSearchBar(bool value) {
    if (_showSearchBar == value) return;

    setState(() => _showSearchBar = value);
    widget.onSearchBarActiveChanged?.call(value);

    if (value) {
      // [FIX UTAMA DISINI]
      // Durasi Animasi Android kan 250ms.
      // Kita kasih waktu 300ms. Jadi animasi SELESAI DULU, baru keyboard nongol.
      // Ini mencegah tabrakan proses rendering.
      Future.delayed(const Duration(milliseconds: 10), () {
        if (mounted) _searchFocusNode.requestFocus();
      });
    } else {
      _searchFocusNode.unfocus();
      _searchController.clear();
      setState(() => _query = '');
    }
  }

  void _navigateTo(Widget screen) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          if (Platform.isAndroid) {
            return FadeTransition(opacity: animation, child: child);
          }
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
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Filter Logic
    final filteredBooks = _allBooks.where((book) {
      return book['title']!.toLowerCase().contains(_query.toLowerCase()) ||
          book['author']!.toLowerCase().contains(_query.toLowerCase());
    }).toList();

    final genres = ['Semua', ...{for (final b in _allBooks) b['genre']!}];
    
    final Map<String, int> genreCounts = {};
    for (final book in _allBooks) {
      genreCounts[book['genre']!] = (genreCounts[book['genre']!] ?? 0) + 1;
    }

    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          // 1. CONTENT LAYER
          Positioned.fill(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    "Jelajah",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    'Temukan koleksi buku perpustakaan',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ),
                const SizedBox(height: 24),

                // Genre List
                SizedBox(
                  height: 96,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    itemCount: genres.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final genre = genres[index];
                      final count = genre == 'Semua' ? _allBooks.length : (genreCounts[genre] ?? 0);

                      return GestureDetector(
                        onTap: () {
                           _navigateTo(CategoryBooksScreen(categoryName: genre, totalBooks: count));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          width: 140,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEBD2),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.transparent, width: 1.2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(genre == 'Semua' ? CupertinoIcons.square_grid_2x2 : CupertinoIcons.book_solid, size: 20, color: const Color(0xFF8D5524)),
                              Text(
                                genre, 
                                maxLines: 1, 
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF5D3A1A))
                              ),
                              Text('$count buku', style: const TextStyle(fontSize: 11, color: Color(0xFF8D5524))),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Book List
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(25, 20, 25, 180),
                    itemCount: filteredBooks.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) => ListTile(title: Text(filteredBooks[i]['title']!)),
                  ),
                ),
              ],
            ),
          ),

          // 2. DIM OVERLAY
          if (_showSearchBar)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => _setShowSearchBar(false),
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: Platform.isAndroid ? 250 : 350),
                  opacity: 1.0,
                  child: Container(color: Colors.black.withOpacity(0.2)),
                ),
              ),
            ),

          // 3. SEARCH BAR
          Align(
            alignment: Alignment.bottomCenter,
            // RepaintBoundary penting buat isolasi animasi dari background list
            child: RepaintBoundary(
              child: Platform.isAndroid 
                  ? _buildAndroidSearch(screenWidth) 
                  : _buildIOSSearch(screenWidth),
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget Builders ---

  Widget _buildAndroidSearch(double screenWidth) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
      child: _showSearchBar
          ? Container(
              key: const ValueKey('Box'),
              width: screenWidth, height: 80, margin: EdgeInsets.zero,
              decoration: _searchDecoration(radius: const BorderRadius.vertical(top: Radius.circular(24))),
              child: _searchContent(isExpanded: true),
            )
          : Container(
              key: const ValueKey('Pill'),
              width: 145, height: 50, margin: const EdgeInsets.only(bottom: 110),
              decoration: _searchDecoration(radius: BorderRadius.circular(30)),
              child: _searchContent(isExpanded: false),
            ),
    );
  }

  Widget _buildIOSSearch(double screenWidth) {
    final double targetWidth = _showSearchBar ? screenWidth : 145.0;
    final double targetHeight = _showSearchBar ? 80.0 : 50.0;
    final EdgeInsets targetMargin = _showSearchBar ? EdgeInsets.zero : const EdgeInsets.only(bottom: 110); 
    final BorderRadius targetRadius = _showSearchBar ? const BorderRadius.vertical(top: Radius.circular(24)) : BorderRadius.circular(30);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutQuart,
      width: targetWidth, height: targetHeight, margin: targetMargin,
      decoration: _searchDecoration(radius: targetRadius),
      child: _searchContent(isExpanded: _showSearchBar),
    );
  }

  BoxDecoration _searchDecoration({required BorderRadius radius}) {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.96),
      borderRadius: radius,
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 25, offset: const Offset(0, 8))],
    );
  }

  Widget _searchContent({required bool isExpanded}) {
    return GestureDetector(
      onTap: _showSearchBar ? null : () => _setShowSearchBar(true),
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: isExpanded
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: CupertinoSearchTextField(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          backgroundColor: Colors.black.withOpacity(0.05),
                          placeholder: 'Cari judul buku...',
                          onChanged: (v) => setState(() => _query = v),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => _setShowSearchBar(false), 
                      child: const Text('Batal', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w600, fontSize: 15))
                    ),
                  ],
                ),
              )
            : const Row(
                mainAxisSize: MainAxisSize.min, 
                children: [
                  Icon(CupertinoIcons.search, color: Colors.black87, size: 20), 
                  SizedBox(width: 8), 
                  Text('Cari buku', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 15))
                ]
              ),
      ),
    );
  }
}