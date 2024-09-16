import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/habit_provider.dart';
import '../models/habit.dart';
import 'package:uuid/uuid.dart';

class HabitFormScreen extends ConsumerWidget {
  final Habit? habit;

  HabitFormScreen({this.habit});

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _frequency = 'Diário';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (habit != null) {
      _nameController.text = habit!.name;
      _descriptionController.text = habit!.description;
      _frequency = habit!.frequency;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(habit == null ? 'Adicionar Hábito' : 'Editar Hábito'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nome do Hábito'),
                  style: const TextStyle(color: Colors.green),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um nome';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                  style: const TextStyle(color: Colors.green),
                ),
                DropdownButtonFormField<String>(
                  value: _frequency,
                  items: ['Diário', 'Semanal', 'Mensal']
                      .map((frequency) => DropdownMenuItem(
                    value: frequency,
                    child: Text(frequency),
                  ))
                      .toList(),
                  onChanged: (value) {
                    _frequency = value!;
                  },
                  decoration: const InputDecoration(labelText: 'Frequência'),
                  style: const TextStyle(color: Colors.green),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newHabit = Habit(
                        id: habit?.id ?? Uuid().v4(),
                        name: _nameController.text,
                        description: _descriptionController.text,
                        frequency: _frequency,
                        isComplete: habit?.isComplete ?? false,
                      );

                      if (habit == null) {
                        ref.read(habitProvider.notifier).addHabit(newHabit);
                      } else {
                        ref.read(habitProvider.notifier).updateHabit(newHabit);
                      }

                      Navigator.of(context).popUntil((route) => route.isFirst); // Volta para a tela inicial
                    }
                  },
                  child: Text(habit == null ? 'Adicionar Hábito' : 'Atualizar Hábito'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
