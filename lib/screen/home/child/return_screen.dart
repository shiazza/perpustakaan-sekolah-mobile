import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReturnScreen extends StatelessWidget {
  const ReturnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data riwayat pengembalian sementara
    final returns = <Map<String, String>>[
      {
        'title': 'Algoritma Dasar',
        'date': '01 Des 2025',
      },
      {
        'title': 'Matematika Diskrit',
        'date': '25 Nov 2025',
      },
    ];

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          'Pengembalian',
          style: TextStyle(
            color: Color(0xFF5D3A1A),
            fontWeight: FontWeight.w600,
            fontSize: 17,
            decoration: TextDecoration.none,
          ),
        ),
        backgroundColor: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0x1F000000))),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: SafeArea(
          child: returns.isEmpty
              ? const Center(
                  child: Text(
                    'Belum ada riwayat pengembalian',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 8),
                      child: Text(
                        'RIWAYAT PENGEMBALIAN',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: Color(0xFF8D5524),
                        ),
                      ),
                    ),
                    ...returns.map((item) => _ReturnCard(item: item)),
                  ],
                ),
        ),
      ),
    );
  }
}

class _ReturnCard extends StatelessWidget {
  final Map<String, String> item;

  const _ReturnCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFFFF4DF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  CupertinoIcons.check_mark_circled_solid,
                  color: Color(0xFF8D5524),
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'] ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF5D3A1A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Dikembalikan: ${item['date']}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8D5524),
                      ),
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
}
