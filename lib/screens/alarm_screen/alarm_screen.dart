import 'package:flutter/material.dart'; // Import completo do Material
import 'package:wakeup_app/widgets/loading_dialog_widget.dart';

import '../../app_theme.dart';
import '../../common_widgets.dart'; // Assumindo EmptyState aqui
import '../../database/app_database.dart';
import '../../models/data_models.dart';
import 'alarm_card_widget.dart';
import 'alarm_form_modal_widget.dart';

final database = AppDatabase.instance;

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({Key? key}) : super(key: key);

  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  List<Alarm> _alarms = [];

  Future _loadAlarms() async {
    final fetchedAlarms = await database.getAllAlarms();

    if (mounted) {
      setState(() {
        _alarms = fetchedAlarms;
      });
    }
  }

  Future<bool> _toggleAlarm(int id, bool value) async {
    try {
      await database.toggleTask(id, value); // Nota: verifique se o método no DB é toggleAlarm ou toggleTask

      setState(() {
        _alarms.firstWhere((a) => a.id == id).isActive = value;
      });

      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao atualizar alarme')),
      );
      return false;
    }
  }

  Future<bool> _deleteAlarm(BuildContext context, int id, {bool closeFormModal = false}) async {
    // Loading Material
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const LoadingDialog(message: "Excluindo..."),
    );

    try {
      await database.deleteAlarm(id);

      if (mounted) {
        setState(() {
          _alarms.removeWhere((a) => a.id == id);
        });

        Navigator.of(context, rootNavigator: true).pop(); // Fecha Loading

        if (closeFormModal) {
          Navigator.of(context).pop(); // Fecha Modal de Edição
        }
      }

      return true;
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop(); // Fecha Loading
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao excluir alarme')),
      );
      return false;
    }
  }

  void _openAlarmModal([Alarm? defaultAlarm]) {
    // Padrão Material para formulários que sobem da parte inferior
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permite que o modal ocupe tela cheia se necessário
      useSafeArea: true,
      backgroundColor: Colors.transparent, // Deixa o widget do modal controlar o design
      builder: (modalContext) => AlarmFormModal(
        alarmToEdit: defaultAlarm,
        onDelete: () async {
          if (defaultAlarm != null) {
            // Passamos o 'context' da tela principal, não do modal, para o snackbar funcionar
            await _deleteAlarm(context, defaultAlarm.id!, closeFormModal: true);
          }
        },
        onSave: (Alarm newAlarm) async {
          // Loading
          showDialog(
              context: modalContext, // Contexto do modal para o dialog aparecer sobre ele
              barrierDismissible: false,
              builder: (_) => const LoadingDialog()
          );

          try {
            if (defaultAlarm == null) {
              final createdId = await database.insertAlarm(newAlarm);
              final alarmWithId = newAlarm.copyWith(id: createdId);
              if (mounted) {
                setState(() {
                  _alarms.add(alarmWithId);
                });
              }
            } else {
              await database.updateAlarm(newAlarm.id!, newAlarm);
              if (mounted) {
                setState(() {
                  final index = _alarms.indexWhere((a) => a.id == newAlarm.id);
                  if (index != -1) {
                    _alarms[index] = newAlarm;
                  }
                });
              }
            }
            
            if (!mounted) return;
            Navigator.pop(modalContext); // Fecha Loading
            // O Navigator.pop do Modal é chamado dentro do AlarmFormModal ao salvar
          } catch (e) {
            Navigator.pop(modalContext); // Fecha Loading
            showDialog(
                context: modalContext,
                builder: (_) => AlertDialog(
                  title: const Text("Erro"),
                  content: const Text("Ocorreu um erro, tente novamente."),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK")
                    )
                  ],
                ));
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadAlarms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. AppBar Material
      appBar: AppBar(
        title: const Text('Alarmes', style: AppTextStyles.navTitle),
        centerTitle: false, // Títulos à esquerda no Android
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
      ),
      // 2. Botão Flutuante (FAB)
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAlarmModal(null),
        backgroundColor: AppColors.primaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: _alarms.isEmpty
            ? const EmptyState(
                icon: Icons.alarm_off, // Ícone Material
                message: "Nenhum alarme",
                details: "Toque em + para criar um novo alarme.",
              )
            : ListView.builder(
                padding: const EdgeInsets.only(bottom: 80), // Espaço para o FAB não cobrir o último item
                itemCount: _alarms.length,
                itemBuilder: (context, index) {
                  final alarm = _alarms[index];
                  return Dismissible(
                    key: Key(alarm.id.toString()),
                    direction: DismissDirection.endToStart, // Arrasta da direita p/ esquerda
                    confirmDismiss: (direction) {
                      return _deleteAlarm(context, alarm.id!);
                    },
                    // Fundo Vermelho de Delete
                    background: Container(
                      color: AppColors.accentRed,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20.0),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: AlarmCard(
                      alarm: alarm,
                      onToggle: (value) => _toggleAlarm(alarm.id!, value),
                      onTap: () => _openAlarmModal(alarm),
                    ),
                  );
                },
              ),
      ),
    );
  }
}