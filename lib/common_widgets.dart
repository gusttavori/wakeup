import 'package:flutter/material.dart'; // Import único e completo
import 'app_theme.dart';

// =============================================
// 8. COMPONENTES GENÉRICOS
// =============================================

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String details;

  const EmptyState({
    Key? key,
    required this.icon,
    required this.message,
    required this.details,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // O Icon agora usa a renderização padrão do Material
          Icon(icon, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          // Mantivemos o AppTextStyles, assumindo que ele retorna TextStyle padrão
          Text(
            message,
            style: AppTextStyles.title1,
            textAlign: TextAlign.center, // Boa prática para evitar quebras estranhas
          ),
          const SizedBox(height: 8),
          Text(
            details,
            style: AppTextStyles.bodySecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}