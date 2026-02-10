import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_theme.dart';

class SideMenu extends StatelessWidget {
  final String currentPage;

  const SideMenu({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // CABECERA (Header)
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppTheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: AppTheme.primary),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Bienvenido,',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                Text(
                  FirebaseAuth.instance.currentUser?.email ?? 'Usuario',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          //TAREAS
          ListTile(
            leading: const Icon(Icons.check_circle_outline),
            title: const Text('Tareas Diarias'),
            selected: currentPage == 'tasks',
            selectedColor: AppTheme.primary,
            onTap: () {
              Navigator.pushReplacementNamed(context, 'tasks');
            },
          ),

          //INCIDENCIAS
          ListTile(
            leading: const Icon(Icons.build_circle_outlined),
            title: const Text('Incidencias'),
            selected: currentPage == 'home',
            selectedColor: AppTheme.primary,
            onTap: () {
              Navigator.pushReplacementNamed(context, 'home');
            },
          ),

          //TIEMPO
          ListTile(
            leading: const Icon(Icons.wb_sunny_outlined),
            title: const Text('El Tiempo'),
            selected: currentPage == 'weather',
            selectedColor: AppTheme.primary,
            onTap: () {
              Navigator.pushReplacementNamed(context, 'weather');
            },
          ),

          const Divider(),

          //AJUSTES
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Ajustes'),
            selected: currentPage == 'settings',
            selectedColor: AppTheme.primary,
            onTap: () {
              Navigator.pushReplacementNamed(context, 'settings');
            },
          ),

          //CRÉDITOS
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Créditos'),
            selected: currentPage == 'credits',
            selectedColor: AppTheme.primary,
            onTap: () {
              Navigator.pushReplacementNamed(context, 'credits');
            },
          ),

          const Divider(),

          //SALIR
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
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