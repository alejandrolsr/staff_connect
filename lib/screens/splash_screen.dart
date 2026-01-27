import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    //Esperamos 3 segundos y navegamos hacia el Login
    _navigateToLogin();
  }

  _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 3), () {});

    // Verificamos si el widget sigue montado antes de navegar
    if (!mounted) return;

    // Usamos pushReplacementNamed para que NO se pueda retroceder al Splash
    Navigator.pushReplacementNamed(context, 'login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF005b96),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Logo del hotel
            Image.asset('assets/images/logo_miramar.png', width: 150),
            const SizedBox(height: 20),

            //Nombre del Hotel con Google Fonts
            Text(
              'Staff Connect',
              style: GoogleFonts.lato(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 50),

            //Indicador de carga tipo Spinner
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
