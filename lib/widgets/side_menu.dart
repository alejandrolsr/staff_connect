import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_theme.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          //CABECERA
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppTheme.primary),
            accountName: const Text(
              "Panel de Personal",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(user?.email ?? "Invitado"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: AppTheme.primary),
            ),
          ),

          //OPCIONES
          ListTile(
            leading: const Icon(Icons.home_outlined, color: AppTheme.primary),
            title: const Text('Inicio'),
            onTap: () => Navigator.pop(context), 
          ),
          ListTile(
            leading: const Icon(Icons.history, color: AppTheme.primary),
            title: const Text('Historial'),
            onTap: () {
              // Aquí navegaremos al historial
            },
          ),

          ListTile(
            leading: const Icon(
              Icons.check_circle_outline,
              color: AppTheme.primary,
            ),
            title: const Text('Tareas Diarias'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'tasks');
            },
          ),

          const Divider(),

          //BOTÓN SALIR
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, 'login');
              }
            },
          ),
        ],
      ),
    );
  }
}
