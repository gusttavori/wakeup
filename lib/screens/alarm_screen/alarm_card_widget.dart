import 'package:flutter/material.dart'; // Importação do Material

import '../../app_theme.dart';
import '../../models/data_models.dart';

class AlarmCard extends StatelessWidget {
  final Alarm alarm;
  final ValueChanged<bool> onToggle;
  final VoidCallback onTap;

  const AlarmCard({
    Key? key,
    required this.alarm,
    required this.onToggle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isActive = alarm.isActive;
    final Color textColor =
        isActive ? AppColors.textPrimaryLight : AppColors.textSecondaryLight;

    return Card(
      // Material Design: Card fornece elevação e bordas arredondadas nativas
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.surfaceLight,
      clipBehavior: Clip.antiAlias, // Garante que o efeito de clique (InkWell) respeite as bordas redondas
      child: InkWell(
        onTap: onTap,
        // InkWell fornece o feedback visual de toque (Ripple Effect)
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alarm.time,
                    style: AppTextStyles.alarmTime.copyWith(
                        color: textColor.withOpacity(isActive ? 1.0 : 0.6)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${alarm.label}, ${alarm.repeat.join(', ')}",
                    style: AppTextStyles.bodySecondary.copyWith(
                        color: textColor.withOpacity(isActive ? 1.0 : 0.6)),
                  ),
                ],
              ),
              // Switch Nativo do Material
              Switch(
                value: alarm.isActive,
                onChanged: onToggle,
                // No Material, definimos a cor do 'thumb' (bolinha) ou 'track' (trilho)
                // Para ficar bonito e verde quando ativo:
                activeColor: Colors.white, 
                activeTrackColor: AppColors.accentGreen,
                inactiveThumbColor: Colors.grey[400],
                inactiveTrackColor: Colors.grey[200],
              ),
            ],
          ),
        ),
      ),
    );
  }
}