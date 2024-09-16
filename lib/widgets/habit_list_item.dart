import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitListItem extends StatelessWidget {
  final Habit habit;
  final VoidCallback onTap;

  const HabitListItem({
    required this.habit,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: habit.isComplete ? Colors.green : Colors.grey, // Usando isComplete
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(
          habit.name,
          style: TextStyle(
            color: habit.isComplete ? Colors.green : Colors.white, // Usando isComplete
            decoration: habit.isComplete ? TextDecoration.lineThrough : null, // Texto riscado se completo
          ),
        ),
        subtitle: Text(
          habit.frequency,
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: Icon(
          habit.isComplete ? Icons.check_circle : Icons.radio_button_unchecked, // Usando isComplete
          color: habit.isComplete ? Colors.green : Colors.grey, // Usando isComplete
        ),
        onTap: onTap,
      ),
    );
  }
}
