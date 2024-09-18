import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monitor_habitos/widgets/notifications.dart';
import '../views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  await NotificationHelper().requestPermissions();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monitor de Hábitos',
      theme: ThemeData(
        // Usando o ColorScheme para configurar as cores
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark, // Tema escuro
        ),
        // Configuração da AppBar com Material 3
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black, // Fundo da AppBar
          titleTextStyle: TextStyle(
            color: Colors.green,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.green),
          centerTitle: true,
        ),
        // Configuração do texto com o novo TextTheme
        textTheme: const TextTheme(
          headlineLarge: TextStyle(color: Colors.green, fontSize: 22),
          bodyLarge: TextStyle(color: Colors.green, fontSize: 16),
          bodyMedium: TextStyle(color: Colors.green, fontSize: 14),
        ),
        // Estilo de botão com ButtonStyle
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green, // Cor de fundo do botão
            foregroundColor: Colors.black, // Cor do texto do botão
          ),
        ),
        useMaterial3: true, // Habilitar Material You
      ),
      home: HomeScreen(),
    );
  }
}
