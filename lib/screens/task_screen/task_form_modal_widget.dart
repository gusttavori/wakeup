import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Recomendado para formatar a data no texto

import '../../app_theme.dart';
import '../../models/data_models.dart';

class TaskFormModal extends StatefulWidget {
  final Task? taskToEdit;
  final Function(Task) onSave; // Tipagem mais segura

  const TaskFormModal({Key? key, this.taskToEdit, required this.onSave}) : super(key: key);

  @override
  _TaskFormModalState createState() => _TaskFormModalState();
}

class _TaskFormModalState extends State<TaskFormModal> {
  late TextEditingController _titleController;
  late TextEditingController _noteController;

  bool _enableReminder = false;
  late DateTime _reminderTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.taskToEdit?.title ?? '');
    _noteController = TextEditingController(text: widget.taskToEdit?.note ?? '');

    if (widget.taskToEdit?.reminder != null) {
      _enableReminder = true;
      _reminderTime = widget.taskToEdit!.reminder!;
    } else {
      _enableReminder = false;
      // Padrão: 1 hora a partir de agora
      _reminderTime = DateTime.now().add(const Duration(hours: 1));
    }
  }

  // Lógica Material para seleção de Data e Hora (Dialogs em sequência)
  Future<void> _pickDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _reminderTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      // Customização de cores do calendário
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryBlue,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimaryLight,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      // Se escolheu a data, agora pede a hora
      if (!mounted) return;
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_reminderTime),
      );

      if (pickedTime != null) {
        setState(() {
          _reminderTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _saveTask() {
    if (_titleController.text.trim().isEmpty) {
      // SnackBar é a forma padrão do Material de mostrar avisos
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, dê um nome à tarefa.')),
      );
      return;
    }

    final newTask = Task(
      id: widget.taskToEdit?.id ?? DateTime.now().millisecondsSinceEpoch,
      title: _titleController.text,
      note: _noteController.text,
      reminder: _enableReminder ? _reminderTime : null,
      isDone: widget.taskToEdit?.isDone ?? false,
    );

    widget.onSave(newTask);
    Navigator.of(context).pop(); // Fecha o modal
  }

  @override
  Widget build(BuildContext context) {
    // Padding inferior para evitar que o teclado cubra os campos
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: const BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28), // Arredondamento padrão MD3
            topRight: Radius.circular(28),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ocupa apenas o espaço necessário
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- HEADER ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.taskToEdit == null ? 'Nova Tarefa' : 'Editar Tarefa',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- CAMPOS DE TEXTO ---
            TextField(
              controller: _titleController,
              autofocus: widget.taskToEdit == null, // Foca automático se for nova
              decoration: const InputDecoration(
                labelText: 'O que precisa ser feito?',
                border: OutlineInputBorder(), // Borda padrão Material
                prefixIcon: Icon(Icons.task_alt),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Descrição (opcional)',
                border: OutlineInputBorder(),
                alignLabelWithHint: true, // Alinha o label no topo da caixa grande
                prefixIcon: Icon(Icons.notes),
              ),
            ),
            const SizedBox(height: 24),

            // --- LEMBRETE ---
            // SwitchListTile é o componente perfeito para toggle + texto
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Definir Lembrete'),
              value: _enableReminder,
              activeColor: AppColors.primaryBlue,
              onChanged: (bool value) {
                setState(() {
                  _enableReminder = value;
                });
              },
            ),

            // Se o lembrete estiver ativo, mostramos um "botão" disfarçado de input
            // para abrir o DatePicker
            if (_enableReminder)
              InkWell(
                onTap: _pickDateTime,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderLight),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month, color: AppColors.primaryBlue),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Data e Hora',
                            style: AppTextStyles.caption,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            // Formatação simples. Se quiser, use DateFormat('dd/MM HH:mm')
                            "${_reminderTime.day}/${_reminderTime.month} às ${_reminderTime.hour}:${_reminderTime.minute.toString().padLeft(2, '0')}",
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.edit, size: 16, color: Colors.grey),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 32),

            // --- BOTÃO SALVAR ---
            FilledButton(
              onPressed: _saveTask,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Salvar Tarefa',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}