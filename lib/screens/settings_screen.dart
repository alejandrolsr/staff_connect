import 'package:flutter/material.dart';
import '../widgets/side_menu.dart';
import '../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = MyApp.themeNotifier.value == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      drawer: const SideMenu(currentPage: 'settings'),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Apariencia",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text("Modo Oscuro"),
            subtitle: const Text("Activar interfaz nocturna"),
            secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
            value: isDark,
            activeThumbColor: const Color(0xFF005b96),
            onChanged: (bool value) {
              setState(() {
                MyApp.themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
              });
            },
          ),
        ],
      ),
    );
  }
}