import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';
import 'package:flutter/material.dart';

class HabitService extends ChangeNotifier {
  static const String _habitsKey = 'habits';
  final SharedPreferences _prefs;
  late List<Habit> habits;
  HabitService(this._prefs){
    habits = [];
    loadHabits();
  }

  // Carrega os hábitos do armazenamento local
  void loadHabits() async {
    final String? habitsString = _prefs.getString(_habitsKey);
    if (habitsString != null) {
      final List<dynamic> habitsMap = jsonDecode(habitsString);
      habits = habitsMap.map((h) => Habit.fromMap(h)).toList();
    }
    notifyListeners();
  }

  // Salva os hábitos no armazenamento local
  static Future<void> saveHabits(List<Habit> habits) async {
    final prefs = await SharedPreferences.getInstance();
    final habitsString = jsonEncode(habits.map((h) => h.toMap()).toList());
    prefs.setString(_habitsKey, habitsString);
  }

  void clearHabits() {
    _prefs.remove(_habitsKey);
    notifyListeners();
  }

  void addHabit(Habit habit) {
    habits.add(habit);
    saveHabits(habits);
    notifyListeners();
  }

  void removeHabit(Habit habit) {
    habits.remove(habit);
    saveHabits(habits);
    notifyListeners();
  }

  void updateHabit(Habit habit) {
    final index = habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      habits[index] = habit;
      saveHabits(habits);
      notifyListeners();
    }
  }

  void toggleHabitToIndex(int index) {
    habits[index].isComplete = !habits[index].isComplete;
    saveHabits(habits);
    notifyListeners();
  }

  void removeHabitAtIndex(int index) {
    habits.removeAt(index);
    saveHabits(habits);
    notifyListeners();
  }
  
  void clearCompletedHabits() {
    habits.removeWhere((h) => h.isComplete);
    saveHabits(habits);
    notifyListeners();
  }

  void clearAllHabits() {
    habits.clear();
    saveHabits(habits);
    notifyListeners();
  }

  @override
  Future<void> notifyListeners() async {
    super.notifyListeners();
  }

}


