import 'dart:async';

import 'package:flutter/material.dart'; // Importação do Material

import '../app_theme.dart';
import '../models/data_models.dart';

// =============================================
// 5. TELA DE CRONÔMETRO
// =============================================

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({Key? key}) : super(key: key);

  @override
  _StopwatchScreenState createState() => _StopwatchScreenState();
}

enum StopwatchState { idle, running, paused }

class _StopwatchScreenState extends State<StopwatchScreen> {
  StopwatchState _state = StopwatchState.idle;
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  final List<StopwatchLap> _laps = [];
  Duration _elapsed = Duration.zero;

  void _start() {
    setState(() {
      _state = StopwatchState.running;
    });
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      setState(() {
        _elapsed = _stopwatch.elapsed;
      });
    });
  }

  void _pause() {
    _timer?.cancel();
    _stopwatch.stop();
    setState(() {
      _state = StopwatchState.paused;
    });
  }

  void _reset() {
    _timer?.cancel();
    _stopwatch.stop();
    _stopwatch.reset();
    setState(() {
      _state = StopwatchState.idle;
      _laps.clear();
      _elapsed = Duration.zero;
    });
  }

  void _lap() {
    setState(() {
      _laps.insert(0, StopwatchLap(_laps.length + 1, _formatTime(_elapsed)));
    });
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitMilliseconds =
        (duration.inMilliseconds.remainder(1000) ~/ 10)
            .toString()
            .padLeft(2, '0');
    return "$twoDigitMinutes:$twoDigitSeconds.$twoDigitMilliseconds";
  }

  Widget _buildButtons() {
    // Mantive a lógica exata, apenas troquei as cores para ficarem harmônicas no Material
    switch (_state) {
      case StopwatchState.idle:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Botão Desabilitado (Visualmente cinza)
            StopwatchButton(
                label: 'Volta',
                foregroundColor: Colors.grey[400]!, // Texto apagado
                backgroundColor: Colors.grey[200]!, // Fundo apagado
                onPressed: null), // null desabilita o botão nativamente
            StopwatchButton(
                label: 'Iniciar',
                foregroundColor: const Color(0xFF1B5E20), // Verde escuro texto
                backgroundColor: const Color(0xFFA5D6A7), // Verde claro fundo
                onPressed: _start),
          ],
        );
      case StopwatchState.running:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StopwatchButton(
                label: 'Volta',
                foregroundColor: Colors.grey[800]!,
                backgroundColor: Colors.grey[300]!,
                onPressed: _lap),
            StopwatchButton(
                label: 'Pausar',
                foregroundColor: const Color(0xFFB71C1C), // Vermelho escuro texto
                backgroundColor: const Color(0xFFFFCDD2), // Vermelho claro fundo
                onPressed: _pause),
          ],
        );
      case StopwatchState.paused:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StopwatchButton(
                label: 'Zerar',
                foregroundColor: Colors.grey[800]!,
                backgroundColor: Colors.grey[300]!,
                onPressed: _reset),
            StopwatchButton(
                label: 'Retomar',
                foregroundColor: const Color(0xFF1B5E20),
                backgroundColor: const Color(0xFFA5D6A7),
                onPressed: _start),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cronômetro', style: AppTextStyles.navTitle),
        centerTitle: false,
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Área do Display Digital
            Padding(
              padding: const EdgeInsets.only(top: 60.0, bottom: 60.0),
              child: Center(
                child: Text(
                  _formatTime(_elapsed),
                  style: AppTextStyles.stopwatchTime.copyWith(
                    // Importante: Fontes monoespaçadas evitam que o texto "pule"
                    // quando os números mudam de largura (ex: de '1' para '0')
                    fontFamily: 'monospace', 
                    fontSize: 70, // Ajuste fino para Material
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
            
            // Botões de Controle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildButtons(),
            ),

            // Lista de Voltas (Laps)
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(top: 30.0),
                itemCount: _laps.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final lap = _laps[index];
                  // ListTile é o componente nativo perfeito para linhas de lista
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 32),
                    title: Text(
                      'Volta ${lap.id}',
                      style: AppTextStyles.bodySecondary,
                    ),
                    trailing: Text(
                      lap.time,
                      style: AppTextStyles.body.copyWith(
                        fontFamily: 'monospace',
                        fontSize: 16,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Componente: Botão do Cronômetro Refatorado ---

class StopwatchButton extends StatelessWidget {
  final String label;
  final Color foregroundColor;
  final Color backgroundColor;
  final VoidCallback? onPressed;

  const StopwatchButton({
    Key? key,
    required this.label,
    required this.foregroundColor,
    required this.backgroundColor,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // FilledButton é o padrão do Material 3 para botões com cor de fundo
    return SizedBox(
      width: 80,
      height: 80,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor, // Cor do texto e do efeito ripple
          shape: const CircleBorder(), // Força o formato redondo
          padding: EdgeInsets.zero, // Remove padding interno para centrar texto
          elevation: 0, // Design flat (opcional, pode aumentar para dar sombra)
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}