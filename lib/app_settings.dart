import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppSettings {
  static final ValueNotifier<bool> isDarkMode = ValueNotifier(false);
  
  // UBAH DARI 'Force IOS' JADI 'Reduce Animation'
  // Default False = Animasi Full (Bagus)
  static final ValueNotifier<bool> reduceAnimation = ValueNotifier(false);

  // Helper Logic
  static bool get enableFancyAnimation {
    // Kalau 'Kurangi Animasi' nyala, berarti Fancy mati
    if (reduceAnimation.value) return false;
    
    // Defaultnya TRUE (Animasi Bagus untuk semua HP, kecuali dimatiin user)
    return true; 
  }
}