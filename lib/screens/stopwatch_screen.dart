import 'dart:async';
import 'dart:convert';
import 'dart:html' as html; // Necessário para web localStorage

import 'package:flutter/material.dart';

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  late Timer _timer;

  bool _isRunning = false;
  int _elapsedMs = 0;
  int? _lastStartTimestamp;

  List<int> _laps = [];

  @override
  void initState() {
    super.initState();
    _loadState();
    _startAutoUpdate();
  }

  // ----------------------------------------
  //             PERSISTÊNCIA
  // ----------------------------------------

  void _saveState() {
    final data = {
      "isRunning": _isRunning,
      "elapsedMs": _elapsedMs,
      "lastStartTimestamp": _lastStartTimestamp,
      "laps": _laps,
    };

    html.window.localStorage["stopwatch_state"] = jsonEncode(data);
  }

  void _loadState() {
    final raw = html.window.localStorage["stopwatch_state"];
    if (raw == null) return;

    try {
      final data = jsonDecode(raw);

      _isRunning = data["isRunning"] ?? false;
      _elapsedMs = data["elapsedMs"] ?? 0;
      _lastStartTimestamp = data["lastStartTimestamp"];

      final savedLaps = data["laps"];
      if (savedLaps is List) {
        _laps = savedLaps.cast<int>();
      }

      if (_isRunning && _lastStartTimestamp != null) {
        final now = DateTime.now().millisecondsSinceEpoch;
        _elapsedMs += now - _lastStartTimestamp!;
      }
    } catch (_) {}
  }

  // ----------------------------------------
  //             UPDATE LOOP
  // ----------------------------------------

  void _startAutoUpdate() {
    _timer = Timer.periodic(const Duration(milliseconds: 60), (_) {
      if (_isRunning && _lastStartTimestamp != null) {
        final now = DateTime.now().millisecondsSinceEpoch;
        setState(() {
          _elapsedMs += now - _lastStartTimestamp!;
        });
        _lastStartTimestamp = now;
        _saveState();
      }
    });
  }

  // ----------------------------------------
  //             CONTROLES
  // ----------------------------------------

  void _toggle() {
    if (_isRunning) {
      _pause();
    } else {
      _start();
    }
  }

  void _start() {
    setState(() {
      _isRunning = true;
      _lastStartTimestamp = DateTime.now().millisecondsSinceEpoch;
    });
    _saveState();
  }

  void _pause() {
    setState(() {
      _isRunning = false;
      _lastStartTimestamp = null;
    });
    _saveState();
  }

  void _reset() {
    setState(() {
      _isRunning = false;
      _elapsedMs = 0;
      _laps.clear();
      _lastStartTimestamp = null;
    });
    _saveState();
  }

  void _addLap() {
    setState(() {
      _laps.add(_elapsedMs);
    });
    _saveState();
  }

  // ----------------------------------------
  //             FORMATAÇÃO
  // ----------------------------------------

  String _formatTime(int ms) {
    final seconds = ms ~/ 1000;
    final minutes = seconds ~/ 60;
    final hours = minutes ~/ 60;

    final s = seconds % 60;
    final m = minutes % 60;
    final h = hours;

    final centiseconds = (ms % 1000) ~/ 10;

    return "${h.toString().padLeft(2, '0')}:"
        "${m.toString().padLeft(2, '0')}:"
        "${s.toString().padLeft(2, '0')}.${centiseconds.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // ----------------------------------------
  //             UI
  // ----------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cronômetro")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              _formatTime(_elapsedMs),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),

            // Botões
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _toggle,
                  child: Text(_isRunning ? "Pausar" : "Iniciar"),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _reset,
                  child: const Text("Zerar"),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _addLap,
                  child: const Text("Volta"),
                ),
              ],
            ),

            const SizedBox(height: 32),

            const Text("Voltas", style: TextStyle(fontSize: 20)),
            Expanded(
              child: ListView.builder(
                itemCount: _laps.length,
                itemBuilder: (context, index) {
                  final lap = _laps[index];
                  return ListTile(
                    leading: Text("#${index + 1}"),
                    title: Text(_formatTime(lap)),
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
