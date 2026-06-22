import 'package:flutter/material.dart';

class SafeZoneColors {
  const SafeZoneColors._();

  static const Color voidBlack = Color(0xFF050507);
  static const Color charcoal = Color(0xFF0B0D12);
  static const Color panel = Color(0xFF12141B);
  static const Color panelHigh = Color(0xFF191D27);
  static const Color white = Color(0xFFFFFFFF);
  static const Color softWhite = Color(0xFFF5F7FA);
  static const Color muted = Color(0xFF8F96A3);
  static const Color dim = Color(0xFF555C68);
  static const Color danger = Color(0xFFFF263F);
  static const Color redDeep = Color(0xFFB80F24);
  static const Color safe = Color(0xFF00FF88);
  static const Color cyan = Color(0xFF00D8FF);
  static const Color warning = Color(0xFFFFB800);
  static const Color orange = Color(0xFFFF6B35);
  static const Color purple = Color(0xFF8B5CF6);

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF050507), Color(0xFF10131A), Color(0xFF07080C)],
  );
}

