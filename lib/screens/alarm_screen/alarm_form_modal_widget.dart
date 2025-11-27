import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../database/app_database.dart';
import '../../models/data_models.dart';

final database = AppDatabase.instance;

class AlarmFormModal extends StatefulWidget {
  final Alarm? alarmToEdit;
  final Function(Alarm) onSave; // Tipagem mais segura
  final VoidCallback onDelete;

  const AlarmFormModal({
    Key? key,
    this.alarmToEdit,
    required this.onSave,
    required this.onDelete,
  }) : super(key: key);

  @override
  _AlarmFormModalState createState() => _AlarmFormModalState();
}

class _AlarmFormModalState extends State<AlarmFormModal> {
  // Usamos TimeOfDay para manipular a hora nativamente no Material
  late TimeOfDay _selectedTime;
  late TextEditingController _labelController;
  late bool _snooze;

  @override
  void initState() {
    super.initState();

    // Lógica para converter String "HH:mm" para TimeOfDay
    if (widget.alarmToEdit != null) {
      final parts = widget.alarmToEdit!.time.split(':');
      _selectedTime = TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    } else {
      _selectedTime = const TimeOfDay(hour: 7, minute: 0);
    }

    _labelController =
        TextEditingController(text: widget.alarmToEdit?.label ?? "Alarme");
    _snooze = widget.alarmToEdit?.snooze ?? true;
  }

  // Função para abrir o relógio nativo do Android
  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        // Customizando as cores do relógio para bater com o App
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              dialHandColor: AppColors.primaryBlue,
              dialBackgroundColor: AppColors.backgroundLight,
              hourMinuteTextColor: AppColors.primaryBlue,
              hourMinuteColor: AppColors.primaryBlue.withOpacity(0.1),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryBlue,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _handleSave() {
    // Converter TimeOfDay de volta para String "HH:mm"
    final timeString =
        "${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}";

    final alarm = Alarm(
      id: widget.alarmToEdit?.id,
      time: timeString,
      label: _labelController.text,
      repeat: widget.alarmToEdit?.repeat ?? [],
      isActive: widget.alarmToEdit?.isActive ?? true,
      sound: widget.alarmToEdit?.sound ?? "Default",
      snooze: _snooze,
    );

    widget.onSave(alarm);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // Padding inferior para teclado
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        // Altura dinâmica baseada no conteúdo ou fixa se preferir
        decoration: const BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- HEADER (Toolbar) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar',
                        style: TextStyle(color: AppColors.textSecondaryLight)),
                  ),
                  Text(
                    widget.alarmToEdit == null ? 'Novo Alarme' : 'Editar',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: _handleSave,
                    child: const Text('Salvar',
                        style: TextStyle(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  // --- DISPLAY DE HORA GRANDE (Clique para editar) ---
                  Center(
                    child: InkWell(
                      onTap: _pickTime,
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        child: Column(
                          children: [
                            Text(
                              "${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}",
                              style: const TextStyle(
                                fontSize: 80,
                                fontWeight: FontWeight.w300, // Light font
                                color: AppColors.primaryBlue,
                                height: 1.0,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Toque para alterar horário",
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // --- FORMULÁRIO ---
                  TextField(
                    controller: _labelController,
                    decoration: const InputDecoration(
                      labelText: 'Nome do Alarme',
                      prefixIcon: Icon(Icons.label_outline),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Opções em Lista (ListTiles)
                  Card(
                    elevation: 0,
                    color: AppColors.surfaceLight,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: AppColors.borderLight)),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.repeat),
                          title: const Text('Repetir'),
                          subtitle: const Text('Nunca'), // Mockado
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // Navegação futura
                          },
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        ListTile(
                          leading: const Icon(Icons.music_note),
                          title: const Text('Som'),
                          subtitle: const Text('Default'), // Mockado
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // Navegação futura
                          },
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        SwitchListTile(
                          secondary: const Icon(Icons.snooze),
                          title: const Text('Soneca'),
                          value: _snooze,
                          activeColor: AppColors.primaryBlue,
                          onChanged: (val) => setState(() => _snooze = val),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // --- BOTÃO EXCLUIR ---
                  if (widget.alarmToEdit != null)
                    FilledButton.icon(
                      onPressed: () {
                        widget.onDelete();
                        Navigator.of(context).pop();
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.accentRed.withOpacity(0.1),
                        foregroundColor: AppColors.accentRed, // Texto vermelho
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      icon: const Icon(Icons.delete_outline),
                      label: const Text("Excluir Alarme"),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}