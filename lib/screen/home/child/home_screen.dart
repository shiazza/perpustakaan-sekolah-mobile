import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double navOverlap = 22 + 60; // pastikan sama dengan offset navbar + tinggi navbar
    final double bottomSafe = MediaQuery.of(context).padding.bottom;

    return SafeArea(
      top: true,
      bottom: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(25, 20, 25, bottomSafe + navOverlap),
            child: ConstrainedBox(
              // saat konten pendek, isi ruang sehingga tidak muncul "celah putih" di bawah
              constraints: BoxConstraints(minHeight: constraints.maxHeight - (/* top safe handled */ 0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [

                  // const SizedBox(height: 10),  // dihapus karena sudah di-handle oleh padding atas

                  // TANGGAL (KECIL)
                  Text(
                    _formatTanggal(DateTime.now()), // format: Hari, Tanggal Bulan
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // RINGKASAN/JUDUL (BESAR)
                  const Text(
                    "Beranda",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // TRANSAKSI
                  const Text(
                    "Transaksi",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(child: _TransaksiButton(icon: CupertinoIcons.book, label: "Pinjam")),
                      const SizedBox(width: 12),
                      Expanded(child: _TransaksiButton(icon: CupertinoIcons.arrow_2_circlepath, label: "Kembali")),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // REKOMENDASI
                  const Text(
                    "Rekomendasi",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 14),

                  SizedBox(
                    height: 180,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        _BookCardVertical(title: "Buku A", author: "Penulis A"),
                        SizedBox(width: 12),
                        _BookCardVertical(title: "Buku B", author: "Penulis B"),
                        SizedBox(width: 12),
                        _BookCardVertical(title: "Buku C", author: "Penulis C"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // FAVORIT
                  const Text(
                    "Favorit",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 14),

                  SizedBox(
                    height: 140,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        _BookCardVertical(title: "Favorit 1", author: "Penulis X"),
                        SizedBox(width: 12),
                        _BookCardVertical(title: "Favorit 2", author: "Penulis Y"),
                      ],
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
}


/// CARD BUKU VERTICAL (cover buku beneran)
class _BookCardVertical extends StatelessWidget {
  final String title;
  final String author;

  const _BookCardVertical({
    required this.title,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // COVER BUKU RATIO 3:4
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.blue.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            author,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}


// TOMBOL TRANSAKSI
class _TransaksiButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TransaksiButton({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: Colors.blue.shade700),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// Helper function untuk format tanggal
String _formatTanggal(DateTime date) {
  final List<String> hari = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
  final List<String> bulan = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
  
  return '${hari[date.weekday - 1]}, ${date.day} ${bulan[date.month - 1]}';
}
