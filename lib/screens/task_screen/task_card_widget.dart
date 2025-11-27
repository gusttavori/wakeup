import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../models/data_models.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onTap;

  const TaskCard({
    Key? key,
    required this.task,
    required this.onToggle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      // Material 3: Cards têm elevação sutil e cor de superfície
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.2), // Ajuste fino da sombra
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias, // Necessário para o InkWell não vazar bordas
      child: InkWell(
        // O InkWell adiciona o efeito de "Ripple" (onda) ao clicar
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // CHECKBOX MATERIAL
              // Transform.scale é opcional, serve para ajustar o tamanho da checkbox se achar pequena
              Transform.scale(
                scale: 1.2,
                child: Checkbox(
                  value: task.isDone,
                  // O Checkbox pede uma função (bool?), adaptamos para seu VoidCallback
                  onChanged: (_) => onToggle(),
                  shape: const CircleBorder(), // Mantém o visual redondo moderno
                  activeColor: AppColors.primaryBlue,
                  side: BorderSide(
                    color: AppColors.borderLight, 
                    width: 2
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // CONTEÚDO DE TEXTO
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: task.isDone
                          ? AppTextStyles.body.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: AppColors.textSecondaryLight,
                            )
                          : AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                    ),
                    if (task.note.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(
                          task.note,
                          style: AppTextStyles.caption,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    // SEÇÃO DE LEMBRETE
                    if (task.reminder != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.alarm, // Ícone Material
                            size: 14,
                            color: task.reminder!.isBefore(DateTime.now()) &&
                                    !task.isDone
                                ? AppColors.accentRed
                                : AppColors.primaryBlue,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${task.reminder!.day}/${task.reminder!.month} ${task.reminder!.hour}:${task.reminder!.minute.toString().padLeft(2, '0')}",
                            style: AppTextStyles.caption.copyWith(
                              color: task.reminder!.isBefore(DateTime.now()) &&
                                      !task.isDone
                                  ? AppColors.accentRed
                                  : AppColors.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                    ],
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