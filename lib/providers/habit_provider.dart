import 'dart:convert';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monitor_habitos/widgets/notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';

final habitProvider = StateNotifierProvider<HabitNotifier, List<Habit>>(
      (ref) => HabitNotifier(),
);

class HabitNotifier extends StateNotifier<List<Habit>> {

  static const String _habitsKey = 'habits';
  late SharedPreferences _prefs;

   HabitNotifier() : super([]){
    init();
   }
   
   

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    loadHabits();
  }

  void addHabit(Habit habit) {
    state = [...state, habit];
    saveHabits();
  }

  void updateHabit(Habit updatedHabit) {
    state = [
      for (final habit in state)
        if (habit.id == updatedHabit.id) updatedHabit else habit
    ];
    saveHabits();
  }

  void deleteHabit(String id) {
    state = state.where((habit) => habit.id != id).toList();
    saveHabits();
  }

  void markHabitAsComplete(String id) {
    state = [
      for (final habit in state)
        if (habit.id == id)
          habit.copyWith(isComplete: !habit.isComplete) // Alterna o estado de isComplete
        else
          habit
    ];
    saveHabits();

  }

   void toggleHabitComplete(String id) {
    state = [
      for (final habit in state)
        if (habit.id == id) habit.copyWith(isComplete: !habit.isComplete) else habit
    ];
    saveHabits();
  }

  void clearCompletedHabits() {
    state = state.where((habit) => !habit.isComplete).toList();
    saveHabits();
  }

  void clearAllHabits() {
    state = [];
    saveHabits();
  }

  Future<void> setAlarm(TimeOfDay time, String habitId) async {
    final habit = state.firstWhere((habit) => habit.id == habitId);
    final now = DateTime.now();
    final alarmTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    state = [
      for (final h in state)
        if (h.id == habitId) h.copyWith(alarmTime: alarmTime) else h
    ];

    habit.hasAlarm = true;

    saveHabits();

    if(habit.hasAlarm){
      await AndroidAlarmManager.oneShotAt(
        alarmTime,
        int.parse(habitId),
        callback,
      );
    }
  }

  void cancelAlarm(String habitId) async {
    final habit = state.firstWhere((habit) => habit.id == habitId);
    state = [
      for (final h in state)
        if (h.id == habitId) h.copyWith(alarmTime: null) else h
    ];

    await AndroidAlarmManager.cancel(int.parse(habitId));
    habit.hasAlarm = false;
    saveHabits();
  }


 static void callback(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? habitsString = prefs.getString(_habitsKey);
    if (habitsString != null) {
      final List<dynamic> habitsMap = jsonDecode(habitsString);
      final habit = habitsMap.firstWhere((h) => h['id'] == id.toString());
      final Habit habitObj = Habit.fromMap(habit);
      NotificationHelper.showNotification(
        id: id,
        title: 'Hora de cumprir seu hábito!',
        body: habitObj.name,
        scheduledDate: habitObj.alarmTime!,
      );
    }
  }
  

  Future<void> loadHabits() async {
    final String? habitsString = _prefs.getString(_habitsKey);
    if (habitsString != null) {
      final List<dynamic> habitsMap = jsonDecode(habitsString);
      state = habitsMap.map((h) => Habit.fromMap(h)).toList();
    }
    }

  // Salva os hábitos no armazenamento local
   Future<void> saveHabits() async {
    final habitsString = jsonEncode(state.map((h) => h.toMap()).toList());
    await _prefs.setString(_habitsKey, habitsString);
  }

  void clearHabits() {
    _prefs.remove(_habitsKey);
  }
  
}

