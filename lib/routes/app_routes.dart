import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';
import '../screens/task_screen.dart';
import '../screens/weather_screen.dart';
import '../screens/credits_screen.dart';
import '../screens/settings_screen.dart'; // <--- IMPORTA LA NUEVA

class AppRoutes {
  static const initialRoute = 'splash';

  // Nombres de rutas (constantes para evitar errores)
  static const home = 'home';
  static const login = 'login';
  static const splash = 'splash';
  static const tasks = 'tasks';
  static const weather = 'weather';
  static const credits = 'credits';
  static const settings = 'settings'; // <--- NUEVA RUTA

  static Map<String, Widget Function(BuildContext)> routes = {
    'login': (BuildContext context) => const LoginScreen(),
    'splash': (BuildContext context) => const SplashScreen(),
    'home': (BuildContext context) => const HomeScreen(),
    'tasks': (BuildContext context) => const TaskScreen(),
    'weather': (BuildContext context) => const WeatherScreen(),
    'credits': (BuildContext context) => const CreditsScreen(),
    'settings': (BuildContext context) => const SettingsScreen(), // <--- AÑADIDA
  };
}