import 'package:flutter/material.dart';
import '../widgets/side_menu.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 10,
        title: const FittedBox(
      
          fit: BoxFit.scaleDown,
          child: Text('Mantenimiento Gran Hotel Miramar'),
        ),
      ),

      drawer: const SideMenu(),

      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.build_circle_outlined, size: 100, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              'Bienvenido al Sistema',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Añadir Incidencia');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
