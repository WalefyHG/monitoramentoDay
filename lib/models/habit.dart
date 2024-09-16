class Habit {
  final String id;
  final String name;
  final String description;
  final String frequency;
  final DateTime? alarmTime; // Adiciona o campo alarmTime
  late final bool hasAlarm;
  bool isComplete; // Usando isComplete

  Habit({
    required this.id,
    required this.name,
    required this.description,
    required this.frequency,
    this.alarmTime, // Define o alarmTime como obrigatório
    this.isComplete = false, // Define false como padrão
    this.hasAlarm = false,
  });

  // Método copyWith para atualizar valores sem quebrar o estado original
  Habit copyWith({
    String? id,
    String? name,
    String? description,
    String? frequency,
    DateTime? alarmTime, // Adiciona o campo alarmTime
    bool? hasAlarm,
    bool? isComplete,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      frequency: frequency ?? this.frequency,
      alarmTime: alarmTime ?? this.alarmTime, // Usa o valor atual se não estiver definido
      isComplete: isComplete ?? this.isComplete,
      hasAlarm: hasAlarm ?? this.hasAlarm,
    );
  }

  // Função para converter o Habit para Map (para persistência)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'frequency': frequency,
      'alarmTime': alarmTime?.toIso8601String(), // Converte o alarmTime para String
      'isComplete': isComplete, // Inclui o campo isComplete
      'hasAlarm': hasAlarm,
    };
  }

  // Função para criar um Habit a partir de um Map
  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      frequency: map['frequency'],
      alarmTime: DateTime.parse(map['alarmTime']), // Converte a String para DateTime
      isComplete: map['isComplete'] ?? false, // Usa false como padrão se não estiver definido
      hasAlarm: map['hasAlarm'] ?? false,
    );
  }
}
