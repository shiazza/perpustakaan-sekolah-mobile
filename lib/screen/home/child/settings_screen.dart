import 'dart:io'; 
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// Sesuaikan path import ini ke lokasi file app_settings.dart kamu
import '../../../../app_settings.dart'; 

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Dummy variable untuk notifikasi (karena belum ada logic backend-nya)
  bool _notifEnabled = true;

  @override
  Widget build(BuildContext context) {
    // Cek Platform (Android/iOS)
    final bool isAndroid = Platform.isAndroid;
    // Cek Tema Gelap/Terang sistem atau AppSettings
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Warna teks & background adaptif
    final textColor = isDark ? Colors.white : const Color(0xFF5D3A1A);
    final headerColor = isDark ? const Color(0xFFF4A261) : const Color(0xFF8D5524);
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    
    // Warna Box Setting (Sedikit lebih terang dari bg di dark mode, atau krem di light mode)
    final boxColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFFF4DF);

    return CupertinoPageScaffold(
      backgroundColor: bgColor,
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'Setelan',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 17,
            decoration: TextDecoration.none,
          ),
        ),
        backgroundColor: bgColor, 
        border: Border(bottom: BorderSide(color: isDark ? Colors.white12 : const Color(0x1F000000))),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              // =======================
              // SEKSI 1: TAMPILAN
              // =======================
              _SettingsSectionHeader(title: 'TAMPILAN', color: headerColor),
              
              // Switch: Mode Gelap
              _SettingsSwitchRow(
                label: 'Mode Gelap',
                value: AppSettings.isDarkMode.value, 
                icon: CupertinoIcons.moon_fill,
                boxColor: boxColor,
                textColor: textColor,
                onChanged: (v) {
                  setState(() {
                    AppSettings.isDarkMode.value = v; 
                  });
                },
              ),

              // Switch: Kurangi Animasi (LOGIKA BARU)
              // Kita tampilkan di Android opsi ini agar user HP spek rendah bisa mematikan efek blur
              if (isAndroid) ...[
                _SettingsSwitchRow(
                  label: 'Kurangi Animasi', // Label diubah
                  value: AppSettings.reduceAnimation.value, // Menggunakan value baru
                  icon: CupertinoIcons.speedometer, // Icon diganti jadi Speedometer (Performa)
                  boxColor: boxColor,
                  textColor: textColor,
                  onChanged: (v) {
                    setState(() {
                      AppSettings.reduceAnimation.value = v; 
                    });
                  },
                ),
                // Deskripsi penjelasan di bawah tombol
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 4),
                  child: Text(
                    'Aktifkan untuk menghilangkan efek buram (blur) dan menghemat baterai.',
                    style: TextStyle(fontSize: 11, color: isDark ? Colors.grey : Colors.grey.shade500),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // =======================
              // SEKSI 2: UMUM
              // =======================
              _SettingsSectionHeader(title: 'UMUM', color: headerColor),
              _SettingsSwitchRow(
                label: 'Notifikasi',
                value: _notifEnabled,
                icon: CupertinoIcons.bell_fill,
                boxColor: boxColor,
                textColor: textColor,
                onChanged: (v) => setState(() => _notifEnabled = v),
              ),

              const SizedBox(height: 24),

              // =======================
              // SEKSI 3: TENTANG
              // =======================
              _SettingsSectionHeader(title: 'TENTANG APLIKASI', color: headerColor),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: boxColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.info_circle_fill, size: 20, color: headerColor),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Versi aplikasi',
                            style: TextStyle(
                              fontSize: 14,
                              color: textColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          '1.0.0',
                          style: TextStyle(
                            fontSize: 12,
                            color: headerColor,
                            fontWeight: FontWeight.w600,
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
      ),
    );
  }
}

// --- WIDGET HELPER (Supaya kode rapi) ---

class _SettingsSectionHeader extends StatelessWidget {
  final String title;
  final Color color;

  const _SettingsSectionHeader({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: color,
        ),
      ),
    );
  }
}

class _SettingsSwitchRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData? icon;
  final Color boxColor;
  final Color textColor;

  const _SettingsSwitchRow({
    required this.label,
    required this.value,
    required this.onChanged,
    this.icon,
    required this.boxColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1), // Background icon netral
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 18, color: const Color(0xFFF4A261)),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ),
              Transform.scale(
                scale: 0.8,
                child: CupertinoSwitch(
                  value: value,
                  activeColor: const Color(0xFFF4A261),
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}