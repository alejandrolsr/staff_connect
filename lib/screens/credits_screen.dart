import 'package:flutter/material.dart';
import '../widgets/side_menu.dart';
import '../theme/app_theme.dart';

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Créditos')),
      drawer: const SideMenu(currentPage: 'credits'),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Spacer(),

              //CONTENIDO PRINCIPAL
              const Icon(Icons.handyman, size: 60, color: AppTheme.primary),
              const SizedBox(height: 20),
              const Text(
                'Staff Connect',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text('Sistema de Gestión de Mantenimiento'),
              const SizedBox(height: 30),

              const Text(
                'Desarrollado por:',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 5),
              const Text(
                'Alejandro López-Salvatierra Ruiz',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 20),
              const Text('Versión 1.2.5'),

              //Empujamos todo lo que hay debajo al final de la pantalla
              const Spacer(),

              //COPYRIGHT
              const Text(
                '© 2026 StaffConnect. Todos los derechos reservados.',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
