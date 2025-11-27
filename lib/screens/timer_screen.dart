import 'dart:async';
import 'package:flutter/material.dart'; // Apenas Material agora!
import '../../app_theme.dart';

// =============================================
// 6. TELA DE TEMPORIZADOR (100% Material)
// =============================================

class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

enum TimerState { idle, running, paused }

class _TimerScreenState extends State<TimerScreen> {
  TimerState _state = TimerState.idle;
  Duration _duration = const Duration(minutes: 5);
  Duration _remaining = const Duration(minutes: 5);
  Timer? _timer;

  // Formatação HH:MM:SS ou MM:SS
  String _formatTimerTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    
    if (duration.inHours > 0) {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  void _startTimer() {
    if (_state == TimerState.idle) {
      _remaining = _duration;
    }
    setState(() {
      _state = TimerState.running;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remaining.inSeconds > 0) {
          _remaining = _remaining - const Duration(seconds: 1);
        } else {
          _timer?.cancel();
          _state = TimerState.idle;
          _remaining = _duration;
          
          // Alerta Nativo Material
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Temporizador Concluído'),
              content: Text('${_duration.inMinutes} minutos se passaram.'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ),
          );
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _state = TimerState.paused;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _state = TimerState.idle;
      _remaining = _duration;
    });
  }

  void _setPreset(Duration duration) {
    setState(() {
      _duration = duration;
      _remaining = duration;
    });
  }

  // Lógica de Seleção 100% Material
  Future<void> _pickDuration() async {
    // Usamos o TimePicker nativo do Android, mas interpretamos Hora como "Horas de duração"
    // e Minutos como "Minutos de duração".
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: _duration.inHours, 
        minute: _duration.inMinutes.remainder(60)
      ),
      initialEntryMode: TimePickerEntryMode.input, // Abre teclado numérico direto (melhor para timers)
      helpText: 'DEFINIR DURAÇÃO (H:M)', // Label customizada
      builder: (BuildContext context, Widget? child) {
        // Forçamos o modo 24h para não aparecer AM/PM, pois é uma duração
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _duration = Duration(hours: picked.hour, minutes: picked.minute);
        _remaining = _duration;
      });
    }
  }

  Widget _buildPickerDisplay() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Display Gigante do Tempo
        InkWell(
          onTap: _pickDuration, // Abre o TimePicker Material
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Column(
              children: [
                Text(
                  _formatTimerTime(_duration),
                  style: const TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.w200,
                    color: AppColors.primaryBlue,
                    fontFamily: 'monospace'
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Toque para ajustar",
                  style: AppTextStyles.caption,
                )
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 40),
        
        // Chips de Presets
        Wrap(
          spacing: 12,
          children: [
            PresetChip(
                label: '5 min',
                duration: const Duration(minutes: 5),
                onTap: _setPreset,
                isSelected: _duration == const Duration(minutes: 5)),
            PresetChip(
                label: '10 min',
                duration: const Duration(minutes: 10),
                onTap: _setPreset,
                isSelected: _duration == const Duration(minutes: 10)),
            PresetChip(
                label: '15 min',
                duration: const Duration(minutes: 15),
                onTap: _setPreset,
                isSelected: _duration == const Duration(minutes: 15)),
          ],
        ),
      ],
    );
  }

  Widget _buildProgress() {
    double progress = 1.0;
    if (_duration.inSeconds > 0) {
      progress = _remaining.inSeconds / _duration.inSeconds;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 280,
          height: 280,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: 1.0,
                strokeWidth: 12,
                color: Colors.grey[200],
              ),
              CircularProgressIndicator(
                value: progress,
                strokeWidth: 12,
                backgroundColor: Colors.transparent,
                color: AppColors.primaryBlue,
                strokeCap: StrokeCap.round,
              ),
              Center(
                child: Text(
                  _formatTimerTime(_remaining),
                  style: const TextStyle(
                    fontSize: 56, 
                    fontWeight: FontWeight.w300,
                    fontFamily: 'monospace'
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimerButtons() {
    switch (_state) {
      case TimerState.idle:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StopwatchButton(
                label: 'Zerar',
                foregroundColor: Colors.grey[400]!,
                backgroundColor: Colors.grey[200]!,
                onPressed: null),
            StopwatchButton(
                label: 'Iniciar',
                foregroundColor: const Color(0xFF1B5E20),
                backgroundColor: const Color(0xFFA5D6A7),
                onPressed: _startTimer),
          ],
        );
      case TimerState.running:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StopwatchButton(
                label: 'Zerar',
                foregroundColor: Colors.grey[800]!,
                backgroundColor: Colors.grey[300]!,
                onPressed: _resetTimer),
            StopwatchButton(
                label: 'Pausar',
                foregroundColor: const Color(0xFFB71C1C),
                backgroundColor: const Color(0xFFFFCDD2),
                onPressed: _pauseTimer),
          ],
        );
      case TimerState.paused:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StopwatchButton(
                label: 'Zerar',
                foregroundColor: Colors.grey[800]!,
                backgroundColor: Colors.grey[300]!,
                onPressed: _resetTimer),
            StopwatchButton(
                label: 'Retomar',
                foregroundColor: const Color(0xFF1B5E20),
                backgroundColor: const Color(0xFFA5D6A7),
                onPressed: _startTimer),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temporizador', style: AppTextStyles.navTitle),
        centerTitle: false,
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _state == TimerState.idle ? _buildPickerDisplay() : _buildProgress(),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: _buildTimerButtons(),
            ),
          ],
        ),
      ),
    );
  }
}

// --- PRESET CHIP (Material) ---
class PresetChip extends StatelessWidget {
  final String label;
  final Duration duration;
  final ValueChanged<Duration> onTap;
  final bool isSelected;

  const PresetChip({
    Key? key,
    required this.label,
    required this.duration,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: () => onTap(duration),
      backgroundColor: isSelected ? AppColors.primaryBlue.withOpacity(0.2) : Colors.grey[200],
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primaryBlue : AppColors.textPrimaryLight,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide.none,
      shape: const StadiumBorder(),
    );
  }
}

// --- STOPWATCH BUTTON (Material FilledButton) ---
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
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 90,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
    );
  }
}