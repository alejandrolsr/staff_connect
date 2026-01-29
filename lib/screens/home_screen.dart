import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/side_menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Lista donde guardamos las incidencias (Simulación local)
  final List<Map<String, dynamic>> _incidents = [];

  // Controlador para leer lo que escribes en el diálogo
  final TextEditingController _textController = TextEditingController();

  // --- LÓGICA: AÑADIR ---
  void _addIncident() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _incidents.add({
          'title': _textController.text,
          'isDone': false, // Por defecto nace pendiente
          'date': DateTime.now(),
        });
      });
      _textController.clear(); // Limpiamos el campo
      Navigator.pop(context); // Cerramos el diálogo
    }
  }

  // --- LÓGICA: MARCAR COMO HECHA/PENDIENTE ---
  void _toggleStatus(int index) {
    setState(() {
      _incidents[index]['isDone'] = !_incidents[index]['isDone'];
    });
  }

  // --- LÓGICA: ELIMINAR CON CONFIRMACIÓN CONDICIONAL ---
  void _deleteIncident(int index) {
    bool isDone = _incidents[index]['isDone'];

    if (isDone) {
      // CASO A: Ya está hecha -> Se borra directo sin preguntar
      setState(() {
        _incidents.removeAt(index);
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Incidencia eliminada')));
    } else {
      // CASO B: Está pendiente -> PREGUNTAMOS PRIMERO
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('¿Estás seguro?'),
          content: const Text(
            'Esta incidencia aún está pendiente de resolver.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancelar
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                setState(() {
                  _incidents.removeAt(index);
                });
                Navigator.pop(context); // Cerrar diálogo
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Incidencia eliminada')),
                );
              },
              child: const Text(
                'Eliminar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }
  }

  // --- DIÁLOGO PARA CREAR ---
  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva Incidencia'),
        content: TextField(
          controller: _textController,
          decoration: const InputDecoration(
            hintText: 'Ej: Fuga de agua hab. 204',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: _addIncident,
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
            child: const Text('Guardar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Mantenimiento Gran Hotel Miramar',
          style: TextStyle(fontSize: 16),
        ),
      ),
      drawer: const SideMenu(currentPage: 'home'),

      // CUERPO DE LA PANTALLA
      body: _incidents.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assignment_turned_in_outlined,
                    size: 100,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No hay incidencias activas',
                    style: TextStyle(fontSize: 18, color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _incidents.length,
              itemBuilder: (context, index) {
                final item = _incidents[index];
                final bool isDone = item['isDone'];

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 10),
                  // Si está hecha, ponemos el fondo un poco grisáceo
                  color: isDone ? Colors.grey[100] : Colors.white,
                  child: ListTile(
                    // 1. ICONO DE ESTADO (Izquierda)
                    leading: IconButton(
                      icon: Icon(
                        isDone
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: isDone ? Colors.green : AppTheme.primary,
                        size: 30,
                      ),
                      onPressed: () => _toggleStatus(index),
                    ),

                    // 2. TÍTULO DE LA INCIDENCIA
                    title: Text(
                      item['title'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        // Tachamos el texto si está terminada
                        decoration: isDone ? TextDecoration.lineThrough : null,
                        color: isDone ? Colors.grey : Colors.black87,
                      ),
                    ),

                    subtitle: Text(
                      isDone ? "Completada" : "Pendiente de revisión",
                      style: TextStyle(
                        color: isDone ? Colors.green : Colors.orange,
                        fontSize: 12,
                      ),
                    ),

                    // 3. BOTÓN ELIMINAR (Derecha)
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _deleteIncident(index),
                    ),
                  ),
                );
              },
            ),

      // BOTÓN FLOTANTE (+)
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
