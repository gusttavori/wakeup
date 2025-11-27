import 'dart:async';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import '../../app_theme.dart';

// =============================================
// 6. TELA DE TEMPORIZADOR (com Persistência Web)
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

  int? _lastTickTimestamp; // timestamp em ms

  // ---------------------------------------------
  //   PERSISTÊNCIA
  // ---------------------------------------------

  void _saveState() {
    final data = {
      "state": _state.index,
      "duration": _duration.inMilliseconds,
      "remaining": _remaining.inMilliseconds,
      "lastTick": _lastTickTimestamp,
    };

    html.window.localStorage["timer_state"] = data.toString();
  }

  void _loadState() {
    final raw = html.window.localStorage["timer_state"];
    if (raw == null) return;

    try {
      final map = _parseMap(raw);

      _state = TimerState.values[map["state"] ?? 0];

      _duration = Duration(milliseconds: map["duration"] ?? 300000);
      _remaining = Duration(milliseconds: map["remaining"] ?? 300000);

      _lastTickTimestamp = map["lastTick"];

      // Se estava rodando, recalcular tempo real passado
      if (_state == TimerState.running && _lastTickTimestamp != null) {
        final now = DateTime.now().millisecondsSinceEpoch;
        final diff = now - _lastTickTimestamp!;

        _remaining -= Duration(milliseconds: diff);

        if (_remaining.isNegative) {
          _remaining = Duration.zero;
          _state = TimerState.idle;
        }
      }
    } catch (_) {}
  }

  Map<String, dynamic> _parseMap(String raw) {
    // converte "{key: value}" para mapa real
    raw = raw.substring(1, raw.length - 1); // remove {}
    final entries = raw.split(", ");
    final map = <String, dynamic>{};
    for (final e in entries) {
      final kv = e.split(": ");
      map[kv[0]] = int.tryParse(kv[1]) ?? kv[1];
    }
    return map;
  }

  // ---------------------------------------------
  //   INICIALIZAÇÃO
  // ---------------------------------------------
  @override
  void initState() {
    super.initState();
    _loadState();
    _startAutoLoop();
  }

  void _startAutoLoop() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_state == TimerState.running) {
        setState(() {
          _remaining -= const Duration(seconds: 1);

          if (_remaining <= Duration.zero) {
            _remaining = Duration.zero;
            _state = TimerState.idle;
            _showFinishDialog();
          }

          _lastTickTimestamp = DateTime.now().millisecondsSinceEpoch;
        });

        _saveState();
      }
    });
  }

  // =============================================
  //  L   Ó   G   I   C   A
  // =============================================

  String _formatTimerTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    if (duration.inHours > 0) {
      return "${twoDigits(duration.inHours)}:"
             "${twoDigits(duration.inMinutes % 60)}:"
             "${twoDigits(duration.inSeconds % 60)}";
    }
    return "${twoDigits(duration.inMinutes % 60)}:"
           "${twoDigits(duration.inSeconds % 60)}";
  }

  void _startTimer() {
    setState(() {
      if (_state == TimerState.idle) {
        _remaining = _duration;
      }
      _state = TimerState.running;
      _lastTickTimestamp = DateTime.now().millisecondsSinceEpoch;
    });

    _saveState();
  }

  void _pauseTimer() {
    setState(() {
      _state = TimerState.paused;
      _lastTickTimestamp = null;
    });
    _saveState();
  }

  void _resetTimer() {
    setState(() {
      _state = TimerState.idle;
      _remaining = _duration;
      _lastTickTimestamp = null;
    });
    _saveState();
  }

  void _setPreset(Duration d) {
    setState(() {
      _duration = d;
      _remaining = d;
    });
    _saveState();
  }

  Future<void> _pickDuration() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: _duration.inHours,
        minute: _duration.inMinutes % 60,
      ),
      initialEntryMode: TimePickerEntryMode.input,
      helpText: 'DEFINIR DURAÇÃO (H:M)',
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _duration =
            Duration(hours: picked.hour, minutes: picked.minute);
        _remaining = _duration;
      });
      _saveState();
    }
  }

  void _showFinishDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Temporizador concluído"),
        content: Text(
            "${_duration.inMinutes} minutos se passaram."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  // =============================================
  //  I   N   T   E   R   F   A   C   E
  // =============================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Temporizador", style: AppTextStyles.navTitle),
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _state == TimerState.idle
                  ? _buildPickerDisplay()
                  : _buildProgress(),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: _buildTimerButtons(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPickerDisplay() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: _pickDuration,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  _formatTimerTime(_duration),
                  style: const TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.w200,
                    fontFamily: 'monospace',
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(height: 8),
                const Text("Toque para ajustar", style: AppTextStyles.caption)
              ],
            ),
          ),
        ),
        const SizedBox(height: 40),
        Wrap(
          spacing: 12,
          children: [
            PresetChip(
              label: '5 min',
              duration: const Duration(minutes: 5),
              onTap: _setPreset,
              isSelected: _duration == const Duration(minutes: 5),
            ),
            PresetChip(
              label: '10 min',
              duration: const Duration(minutes: 10),
              onTap: _setPreset,
              isSelected: _duration == const Duration(minutes: 10),
            ),
            PresetChip(
              label: '15 min',
              duration: const Duration(minutes: 15),
              onTap: _setPreset,
              isSelected: _duration == const Duration(minutes: 15),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildProgress() {
    final progress =
        _duration.inSeconds == 0 ? 1 : _remaining.inSeconds / _duration.inSeconds;

    return Center(
      child: SizedBox(
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
              value: progress.toDouble(),
              strokeWidth: 12,
              color: AppColors.primaryBlue,
              backgroundColor: Colors.transparent,
              strokeCap: StrokeCap.round,
            ),
            Center(
              child: Text(
                _formatTimerTime(_remaining),
                style: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ),
      ),
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
              onPressed: _startTimer,
            ),
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
              onPressed: _resetTimer,
            ),
            StopwatchButton(
              label: 'Pausar',
              foregroundColor: const Color(0xFFB71C1C),
              backgroundColor: const Color(0xFFFFCDD2),
              onPressed: _pauseTimer,
            ),
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
              onPressed: _resetTimer,
            ),
            StopwatchButton(
              label: 'Retomar',
              foregroundColor: const Color(0xFF1B5E20),
              backgroundColor: const Color(0xFFA5D6A7),
              onPressed: _startTimer,
            ),
          ],
        );
    }
  }
}

// --------------------------------------------
//    COMPONENTES
// --------------------------------------------

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
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: () => onTap(duration),
      backgroundColor:
          isSelected ? AppColors.primaryBlue.withOpacity(0.2) : Colors.grey[200],
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primaryBlue : AppColors.textPrimaryLight,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: const StadiumBorder(),
    );
  }
}

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
    return SizedBox(
      width: 90,
      height: 90,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: const CircleBorder(),
        ),
        child: Text(label, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
