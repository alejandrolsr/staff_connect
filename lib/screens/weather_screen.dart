import 'package:flutter/material.dart';
import '../widgets/side_menu.dart';
import '../theme/app_theme.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('El Tiempo')),
      drawer: const SideMenu(currentPage: 'weather'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.cloud, size: 80, color: AppTheme.primary),
            SizedBox(height: 20),
            Text('Próximamente: API del Tiempo'),
          ],
        ),
      ),
    );
  }
}
