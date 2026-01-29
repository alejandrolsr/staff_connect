import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_theme.dart';
import '../widgets/side_menu.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  String _timeString = "";
  String _dateString = "";
  late Timer _timer;

  // Lista de tareas
  List<Map<String, dynamic>> tasks = [
    {
      "title": "Inspección cuadros eléctricos Planta 1",
      "done": false,
      "time": "07:00",
    },
    {"title": "Revisar pH Piscina Principal", "done": false, "time": "08:00"},
    {
      "title": "Engrasar puertas giratorias Hall",
      "done": false,
      "time": "9:00",
    },
    {"title": "Revisión Calderas Edificio B", "done": false, "time": "11:00"},
    {"title": "Comprobar luces de emergencia", "done": false, "time": "14:00"},
    {"title": "Revisar canales TV", "done": false, "time": "15:00"},
  ];

  @override
  void initState() {
    super.initState();
    _timeString = _formatTime(DateTime.now());
    _dateString = _formatDate(DateTime.now());
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) => _getTime(),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    if (mounted) {
      setState(() {
        _timeString = _formatTime(now);
        _dateString = _formatDate(now);
      });
    }
  }

  String _formatTime(DateTime time) =>
      "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  String _formatDate(DateTime time) =>
      "${time.day.toString().padLeft(2, '0')}/${time.month.toString().padLeft(2, '0')}/${time.year}";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas Diarias', style: TextStyle(fontSize: 18)),
        centerTitle: false,
      ),
      drawer: const SideMenu(currentPage: 'tasks'),
      body: Column(
        children: [
          // CABECERA HORA/FECHA
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  _timeString,
                  style: const TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  _dateString,
                  style: const TextStyle(fontSize: 18, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // LISTA
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    leading: Checkbox(
                      activeColor: AppTheme.primary,
                      value: tasks[index]['done'],
                      onChanged: (bool? value) {
                        setState(() => tasks[index]['done'] = value!);
                      },
                    ),
                    title: Text(
                      tasks[index]['title'],
                      style: TextStyle(
                        fontSize: 16,
                        decoration: tasks[index]['done']
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: tasks[index]['done']
                            ? Colors.grey
                            : Colors.black87,
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tasks[index]['time'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
