import 'package:flutter/material.dart';

// =============================================
// 1. TOKENS DE DESIGN (Cores e Estilos)
// =============================================

class AppColors {
  // Mantive as mesmas cores hex, pois são a identidade da sua marca,
  // mas agora elas se integram ao ColorScheme do Material 3 no main.dart
  static const Color primaryBlue = Color(0xFF007AFF); // Material Blue similar
  static const Color accentGreen = Color(0xFF34C759);
  static const Color accentRed = Color(0xFFFF3B30);

  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  
  static const Color textPrimaryLight = Color(0xFF1B1B1F); // Ajustado levemente para o cinza escuro padrão do Material 3
  static const Color textSecondaryLight = Color(0xFF5E5E62); // Ajustado para contraste padrão MD3
  static const Color borderLight = Color(0xFFE0E2E5); // Cinza de borda padrão MD3

  // Cores do modo escuro (Sugestão Material Dark)
  // static const Color backgroundDark = Color(0xFF121212);
  // static const Color surfaceDark = Color(0xFF1E1E1E);
}

class AppTextStyles {
  // DICA: No Material Design, deixamos 'null' para usar a fonte padrão do sistema (Roboto no Android).
  // Se quiser forçar o Inter, descomente a linha abaixo.
  // static const String? fontFamily = 'Inter';
  static const String? fontFamily = null; 

  // Equivalente ao Headline Medium/Large do Material
  static const TextStyle largeTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32, // Leve redução (34 -> 32) para escala Material
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryLight,
    letterSpacing: -0.5, // Material titles geralmente são mais "apertados"
  );

  // Equivalente ao Title Large
  static const TextStyle title1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22, // (24 -> 22) Padrão Material
    fontWeight: FontWeight.w500, // Material usa Medium (w500) muito frequentemente
    color: AppColors.textPrimaryLight,
  );

  // Equivalente ao Title Medium
  static const TextStyle navTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimaryLight,
    letterSpacing: 0.15,
  );

  // Equivalente ao Body Medium
  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimaryLight,
    letterSpacing: 0.25,
  );

  // Equivalente ao Body Small
  static const TextStyle bodySecondary = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondaryLight,
    letterSpacing: 0.4,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondaryLight,
  );

  // Estilos Específicos do App (Clock Face)
  static const TextStyle alarmTime = TextStyle(
    fontFamily: fontFamily,
    fontSize: 48,
    fontWeight: FontWeight.w400, // Relógios Material geralmente não são bold
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle stopwatchTime = TextStyle(
    fontFamily: fontFamily,
    fontSize: 72,
    fontWeight: FontWeight.w300, // Light weight fica muito elegante no Material
    color: AppColors.textPrimaryLight,
    letterSpacing: -1.5, // Números grandes ficam melhores mais juntos
  );
}