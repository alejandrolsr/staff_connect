import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';

import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/task_screen.dart';
import 'screens/weather_screen.dart';
import 'screens/credits_screen.dart';
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Inicialización de Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Miramar Maintenance',

      theme: AppTheme.lightTheme,

      initialRoute: 'splash',
      routes: {
        'splash': (context) => const SplashScreen(),
        'login': (context) => const LoginScreen(),
        'home': (context) => const HomeScreen(),
        'tasks': (context) => const TaskScreen(),
        'weather': (context) => const WeatherScreen(),
        'credits': (context) => const CreditsScreen(),
        'profile': (context) => const ProfileScreen(),
      },
    );
  }
}
