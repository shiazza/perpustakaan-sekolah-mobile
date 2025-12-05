import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoanScreen extends StatelessWidget {
  const LoanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data peminjaman sementara
    final loans = <Map<String, String>>[
      {
        'title': 'Pemrograman Dart',
        'due': '12 Des 2025',
      },
      {
        'title': 'Flutter untuk Pemula',
        'due': '20 Des 2025',
      },
    ];

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          'Peminjaman',
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
          child: loans.isEmpty
              ? const Center(
                  child: Text(
                    'Belum ada peminjaman aktif',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 8),
                      child: Text(
                        'PEMINJAMAN AKTIF',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: Color(0xFF8D5524),
                        ),
                      ),
                    ),
                    ...loans.map((loan) => _LoanCard(loan: loan)),
                  ],
                ),
        ),
      ),
    );
  }
}

class _LoanCard extends StatelessWidget {
  final Map<String, String> loan;

  const _LoanCard({required this.loan});

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
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  CupertinoIcons.book_solid,
                  color: Color(0xFFF4A261),
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loan['title'] ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF5D3A1A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Jatuh tempo: ${loan['due']}',
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
