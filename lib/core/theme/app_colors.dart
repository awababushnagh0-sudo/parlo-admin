import 'package:flutter/material.dart';

/// Colour tokens — shared with the Parlo mobile app so the dashboard reads as
/// the same product. Emerald accent marks meaning (primary actions, current
/// state), never decoration. Never hard-code colours; reference these.
class AppColors {
  const AppColors._();

  // Seed color used to generate the color scheme
  static const Color seedColor = Color(0xFF16A34A); // A nice Emerald/Green

  // Primary palette
  static const Color primary = Color(0xFF16A34A);
  static const Color secondary = Color(0xFF15803D);
  static const Color tertiary = Color(0xFF22C55E);

  // Semantic colors
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color.fromARGB(255, 239, 104, 104);
  static const Color info = Color(0xFF3B82F6);

  // Grays/Neutrals
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Colors.white;
  static const Color outlineLight = Color(0xFFE2E8F0);
  static const Color onSurfaceVariantLight = Color(0xFF64748B);

  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color outlineDark = Color(0xFF334155);
  static const Color onSurfaceVariantDark = Color(0xFF94A3B8);

  // Accent colors
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentOrange = Color(0xFFF97316);

  // Surface variations
  static const Color surfaceVariantLight = Color(0xFFF1F5F9);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color elevatedLight = Color(0xFFEEF2F7);

  // Dark surfaces
  static const Color surfaceVariantDark = Color(0xFF1A2437);
  static const Color elevatedDark = Color(0xFF243041);

  // Neutral utility colors
  static const Color dividerLight = Color(0xFFE5E7EB);
  static const Color dividerDark = Color(0xFF374151);

  // Text colors
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // Soft container colors
  static const Color blueContainer = Color(0xFFDBEAFE);
  static const Color purpleContainer = Color(0xFFEDE9FE);
  static const Color orangeContainer = Color(0xFFFFEDD5);
}
