import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_theme.dart';

class SideMenu extends StatelessWidget {
  final String currentPage;

  const SideMenu({super.key, required this.currentPage});

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

          //INICIO
          ListTile(
            leading: Icon(
              Icons.home_outlined,
              color: currentPage == 'home' ? AppTheme.primary : Colors.grey,
            ),
            title: Text(
              'Inicio',
              style: TextStyle(
                color: currentPage == 'home'
                    ? AppTheme.primary
                    : Colors.black87,
                fontWeight: currentPage == 'home'
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            selected: currentPage == 'home',
            onTap: () => _navigate(context, 'home'),
          ),

          //PERFIL
          ListTile(
            leading: Icon(
              Icons.person_outline,
              color: currentPage == 'profile' ? AppTheme.primary : Colors.grey,
            ),
            title: Text(
              'Mi Perfil',
              style: TextStyle(
                color: currentPage == 'profile'
                    ? AppTheme.primary
                    : Colors.black87,
                fontWeight: currentPage == 'profile'
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            selected: currentPage == 'profile',
            onTap: () => _navigate(context, 'profile'),
          ),

          //TAREAS
          ListTile(
            leading: Icon(
              Icons.check_circle_outline,
              color: currentPage == 'tasks' ? AppTheme.primary : Colors.grey,
            ),
            title: Text(
              'Tareas',
              style: TextStyle(
                color: currentPage == 'tasks'
                    ? AppTheme.primary
                    : Colors.black87,
                fontWeight: currentPage == 'tasks'
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            selected: currentPage == 'tasks',
            onTap: () => _navigate(context, 'tasks'),
          ),

          //TIEMPO
          ListTile(
            leading: Icon(
              Icons.cloud_outlined,
              color: currentPage == 'weather' ? AppTheme.primary : Colors.grey,
            ),
            title: Text(
              'El Tiempo',
              style: TextStyle(
                color: currentPage == 'weather'
                    ? AppTheme.primary
                    : Colors.black87,
                fontWeight: currentPage == 'weather'
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            selected: currentPage == 'weather',
            onTap: () => _navigate(context, 'weather'),
          ),

          const Divider(),

          //CRÉDITOS
          ListTile(
            leading: Icon(
              Icons.info_outline,
              color: currentPage == 'credits' ? AppTheme.primary : Colors.grey,
            ),
            title: Text(
              'Créditos',
              style: TextStyle(
                color: currentPage == 'credits'
                    ? AppTheme.primary
                    : Colors.black87,
                fontWeight: currentPage == 'credits'
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            selected: currentPage == 'credits',
            onTap: () => _navigate(context, 'credits'),
          ),

          //SALIR
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  'login',
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  //Función para navegar limpio
  void _navigate(BuildContext context, String routeName) {
    Navigator.pop(context);
    if (currentPage != routeName) {
      Navigator.pushReplacementNamed(context, routeName);
    }
  }
}
