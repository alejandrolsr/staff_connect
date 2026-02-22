import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    //Esperamos 2 segundos para que cargue el logo
    await Future.delayed(const Duration(seconds: 2));

    //Esperamos a que Firebase termine de comprobar el disco
    var user = await FirebaseAuth.instance.authStateChanges().first;

    if (!mounted) return;

    if (user != null) {
      // Si hay usuario va directo al Home
      debugPrint("Sesión recuperada: ${user.email}");
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      // NO hay usuario vuelve al Login
      debugPrint("No hay sesión guardada");
      Navigator.pushReplacementNamed(context, 'login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF005b96),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo_miramar.png', width: 150),
            const SizedBox(height: 20),
            Text(
              'Staff Connect',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 50),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
