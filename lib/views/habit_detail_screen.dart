import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/habit_provider.dart';
import '../models/habit.dart';
import 'habit_form_screen.dart';

class HabitDetailScreen extends ConsumerWidget {
  final Habit habit;

  const HabitDetailScreen({required this.habit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitNotifier = ref.read(habitProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(habit.name),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Descrição: ' + habit.description,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                habit.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              
              LinearProgressIndicator(
                value: habitNotifier.calculationPorcentage("daily"),// Adiciona a barra de progresso
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                minHeight: 10.0,
              ),
              const SizedBox(height: 20),
              Text(
                DateFormat('dd/MM/yyyy').format(habit.alarmTime!),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  habitNotifier.markHabitAsComplete(habit.id);
                  Navigator.of(context).pop(); // Volta para a tela inicial
                },
                child: Text(habit.isComplete ? 'Marcar como Incompleto' : 'Marcar como Concluído'), // Usando isComplete
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HabitFormScreen(habit: habit),
                    ),
                  );
                },
                child: const Text('Editar Hábito'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  habitNotifier.deleteHabit(habit.id);
                  Navigator.of(context).pop(); // Volta para a tela inicial
                },
                child: const Text('Excluir Hábito'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Cor para exclusão
                  foregroundColor: Colors.white, // Cor do texto
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
