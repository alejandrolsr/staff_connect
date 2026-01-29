import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_theme.dart';

class SideMenu extends StatelessWidget {
  // 1. Variable para saber en qué pantalla estamos
  final String currentPage;

  const SideMenu({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppTheme.primary),
            accountName: const Text("Panel de Personal", style: TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: Text(user?.email ?? "Invitado"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: AppTheme.primary),
            ),
          ),

          // --- OPCIÓN INICIO ---
          ListTile(
            leading: Icon(Icons.home_outlined, 
              color: currentPage == 'home' ? AppTheme.primary : Colors.grey),
            title: Text('Inicio',
              style: TextStyle(
                color: currentPage == 'home' ? AppTheme.primary : Colors.black87,
                fontWeight: currentPage == 'home' ? FontWeight.bold : FontWeight.normal
              ),
            ),
            selected: currentPage == 'home', // Marca visualmente si estamos aquí
            onTap: () {
              // 1. Siempre cerramos el menú primero
              Navigator.pop(context); 
              
              // 2. EL TRUCO: Solo navegamos si NO estamos ya en Home
              if (currentPage != 'home') {
                Navigator.pushReplacementNamed(context, 'home');
              }
            },
          ),

          // --- OPCIÓN TAREAS ---
          ListTile(
            leading: Icon(Icons.check_circle_outline, 
              color: currentPage == 'tasks' ? AppTheme.primary : Colors.grey),
            title: Text('Tareas Diarias',
              style: TextStyle(
                color: currentPage == 'tasks' ? AppTheme.primary : Colors.black87,
                fontWeight: currentPage == 'tasks' ? FontWeight.bold : FontWeight.normal
              ),
            ),
            selected: currentPage == 'tasks',
            onTap: () {
              Navigator.pop(context);
              // Solo navegamos si NO estamos ya en Tasks
              if (currentPage != 'tasks') {
                Navigator.pushReplacementNamed(context, 'tasks');
              }
            },
          ),

          const Divider(),
          
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                // Usamos pushNamedAndRemoveUntil para borrar todo el historial al salir
                Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
              }
            },
          ),
        ],
      ),
    );
  }
}