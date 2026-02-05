import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/weather_screen.dart'; 
import '../screens/credits_screen.dart';
import '../screens/profile_screen.dart';

class AppRoutes {
  static const String splash = 'splash';
  static const String login = 'login';
  static const String task = 'task';
  static const String home = 'home';
  static const String weather = 'weather';
  static const String credits = 'credits';
  static const String profile = 'profile';

  /// Mapa de rutas
  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    home: (context) => const HomeScreen(),
    weather: (context) => const WeatherScreen(),
    credits: (context) => const CreditsScreen(),
    profile: (context) => const ProfileScreen(),
  };
}