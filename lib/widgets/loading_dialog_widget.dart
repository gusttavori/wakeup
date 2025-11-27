import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  final String message;

  const LoadingDialog({Key? key, this.message = "Carregando..."}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // Material 3 usa cantos arredondados por padrão (geralmente 28, mas 16 fica bom para dialogs pequenos)
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      // Garante que o fundo use a cor de superfície definida no seu app_theme.dart
      backgroundColor: Theme.of(context).colorScheme.surface, 
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // O indicador de progresso do Material. 
            // Ele herda a cor primária (AppColors.primaryBlue) automaticamente do Theme.
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              message,
              // Usa o estilo de texto do corpo definido no seu tema
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}