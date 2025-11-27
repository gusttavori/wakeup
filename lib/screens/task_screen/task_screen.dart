import 'package:flutter/material.dart'; // Importação completa do Material
import 'package:wakeup_app/screens/task_screen/task_card_widget.dart';
import 'package:wakeup_app/screens/task_screen/task_form_modal_widget.dart';

import '../../app_theme.dart';
import '../../common_widgets.dart'; // Assumindo que EmptyState está aqui
import '../../database/app_database.dart';
import '../../models/data_models.dart';
import '../../widgets/loading_dialog_widget.dart';

final database = AppDatabase.instance;

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  // No Material 3, SegmentedButton usa Set<T> para seleção
  Set<int> _selectedSegment = {0};

  List<Task> _tasks = [];

  Future _loadTasks() async {
    final fetchedTasks = await database.getAllTasks();
    setState(() {
      _tasks = fetchedTasks;
    });
  }

  List<Task> get _filteredTasks {
    if (_selectedSegment.contains(0)) {
      return _tasks.where((task) => !task.isDone).toList();
    } else {
      return _tasks.where((task) => task.isDone).toList();
    }
  }

  // Lógica de Toggle (marcar como feito)
  Future<bool> _toggleTask(int id, bool value) async {
    try {
      await database.toggleTask(id, value);
      setState(() {
        _tasks.firstWhere((t) => t.id == id).isDone = value;
      });
      return true;
    } catch (e) {
      // SnackBar é melhor que Dialog para erros rápidos de interação
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao atualizar tarefa")),
      );
      return false;
    }
  }

  // Lógica de Exclusão
  Future<bool> _deleteTask(BuildContext context, int id) async {
    // Loading Material
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const LoadingDialog(message: "Excluindo..."),
    );

    try {
      await database.deleteTask(id);
      if (mounted) {
        setState(() {
          _tasks.removeWhere((t) => t.id == id);
        });
        Navigator.of(context, rootNavigator: true).pop(); // Fecha Loading
      }
      return true;
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop(); // Fecha Loading
      return false;
    }
  }

  // Abrir Modal de Formulário
  void _openTaskModal([Task? defaultTask]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Importante: permite que o modal cresça com o teclado
      useSafeArea: true,
      backgroundColor: Colors.transparent, // Deixa o TaskFormModal controlar o estilo
      builder: (context) => TaskFormModal(
        taskToEdit: defaultTask,
        onSave: (Task newTask) async {
          // Exibe Loading
          showDialog(
              context: context, 
              barrierDismissible: false,
              builder: (_) => const LoadingDialog()
          );

          try {
            if (defaultTask == null) {
              final createdId = await database.insertTask(newTask);
              final taskWithId = newTask.copyWith(id: createdId);
              setState(() {
                _tasks.add(taskWithId);
              });
            } else {
              await database.updateTask(newTask.id!, newTask);
              setState(() {
                final index = _tasks.indexWhere((t) => t.id == newTask.id);
                if (index != -1) {
                  _tasks[index] = newTask;
                }
              });
            }

            if (!mounted) return;
            Navigator.pop(context); // Fecha Loading
            // Nota: O Navigator.pop do Modal já foi chamado dentro do TaskFormModal
            // Se não foi, precisaria chamar aqui.
          } catch (e) {
            Navigator.pop(context); // Fecha Loading
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("Erro"),
                content: const Text("Ocorreu um erro, tente novamente."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar padrão do Material
      appBar: AppBar(
        title: const Text('Tarefas'),
        centerTitle: false, // No Android o título geralmente fica à esquerda
        elevation: 0,
        backgroundColor: AppColors.backgroundLight,
      ),
      // Botão Flutuante (FAB) nativo
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openTaskModal(null),
        backgroundColor: AppColors.primaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          // SegmentedButton (Filtro)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SizedBox(
              width: double.infinity,
              child: SegmentedButton<int>(
                segments: const [
                  ButtonSegment<int>(
                    value: 0,
                    label: Text('Ativas'),
                    icon: Icon(Icons.check_box_outline_blank),
                  ),
                  ButtonSegment<int>(
                    value: 1,
                    label: Text('Concluídas'),
                    icon: Icon(Icons.check_box),
                  ),
                ],
                selected: _selectedSegment,
                onSelectionChanged: (Set<int> newSelection) {
                  setState(() {
                    // SegmentedButton permite multi-seleção por padrão, 
                    // mas aqui pegamos apenas o primeiro item para simular abas
                    _selectedSegment = newSelection;
                  });
                },
                style: ButtonStyle(
                  // Customizando cores para bater com o tema
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (states) {
                      if (states.contains(MaterialState.selected)) {
                        return AppColors.primaryBlue.withOpacity(0.2);
                      }
                      return null; 
                    },
                  ),
                ),
              ),
            ),
          ),
          
          // Lista de Tarefas
          Expanded(
            child: _filteredTasks.isEmpty
                ? EmptyState(
                    icon: Icons.list_alt, // Ícone Material
                    message: _selectedSegment.contains(0)
                        ? "Nenhuma tarefa ativa"
                        : "Nenhuma tarefa concluída",
                    details: "Toque em + para criar uma nova tarefa.",
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: _filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = _filteredTasks[index];
                      
                      return Dismissible(
                        key: Key(task.id.toString()),
                        // Direção do deslize
                        direction: DismissDirection.horizontal,
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.endToStart) {
                            // Arrastar para esquerda: Deletar
                            return _deleteTask(context, task.id!);
                          } else {
                            // Arrastar para direita: Alternar (Completar/Desfazer)
                            return _toggleTask(task.id!, !task.isDone);
                          }
                        },
                        // Fundo ao arrastar para direita (Check)
                        background: Container(
                          color: AppColors.accentGreen,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 20.0),
                          child: const Icon(Icons.check, color: Colors.white),
                        ),
                        // Fundo ao arrastar para esquerda (Delete)
                        secondaryBackground: Container(
                          color: AppColors.accentRed,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20.0),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: TaskCard(
                          task: task,
                          onToggle: () => _toggleTask(task.id!, !task.isDone),
                          onTap: () => _openTaskModal(task),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}