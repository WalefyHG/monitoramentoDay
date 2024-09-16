import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/habit_provider.dart';
import 'habit_form_screen.dart';
import 'habit_detail_screen.dart';
import '../services/habit_service.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Hábitos'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: habits.isEmpty
            ? const Center(
          child: Text(
            'Nenhum hábito adicionado ainda.',
            style: TextStyle(color: Colors.green),
          ),
        )
            : ListView.builder(
          itemCount: habits.length,
          itemBuilder: (context, index) {
            final habit = habits[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.green, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text(
                  habit.name,
                  style: TextStyle(
                    color: habit.isComplete ? Colors.green : Colors.white,
                    decoration: habit.isComplete
                        ? TextDecoration.lineThrough
                        : null, // Texto riscado se completo
                  ),
                ),
                subtitle: Text(habit.description),
                trailing: habit.isComplete
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : null, // Exibe um ícone se completo
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HabitDetailScreen(habit: habit),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => HabitFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
