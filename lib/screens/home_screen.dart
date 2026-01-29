import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panel de Mantenimiento')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF005b96)),
              child: Text(
                'Menú Miramar',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Cerrar Sesión'),
              onTap: () async {
                //Firebase cierra sesión
                await FirebaseAuth.instance.signOut();

                //Navegamos al Login
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                }
              },
            ),
          ],
        ),
      ),
      body: const Center(child: Text('¡Bienvenido al sistema de incidencias!')),
    );
  }
}
