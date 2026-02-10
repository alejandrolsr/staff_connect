import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
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
  String _currentShiftName = "";
  List<Map<String, dynamic>> _currentTasks = [];
  late Timer _timer;

  //TURNOS Y TAREAS
  final List<Map<String, dynamic>> _morningTasks = [
    {"title": "Inspección cuadros eléctricos", "done": false, "time": "07:00"},
    {"title": "Revisar pH Piscina Principal", "done": false, "time": "08:00"},
    {"title": "Engrasar puertas giratorias", "done": false, "time": "09:00"},
    {"title": "Revisión Calderas Edificio B", "done": false, "time": "11:00"},
    {"title": "Comprobar Osmosis", "done": false, "time": "13:00"},
  ];

  final List<Map<String, dynamic>> _afternoonTasks = [
    {"title": "Comprobar luces de emergencia", "done": false, "time": "15:30"},
    {"title": "Revisar canales TV Salón", "done": false, "time": "16:00"},
    {"title": "Riego jardines zona norte", "done": false, "time": "18:00"},
    {"title": "Supervisión cierre piscina", "done": false, "time": "20:00"},
  ];

  final List<Map<String, dynamic>> _nightTasks = [
    {"title": "Apagado iluminación decorativa", "done": false, "time": "23:30"},
    {"title": "Comprobar cierre Spa", "done": false, "time": "01:00"},
    {"title": "Revisión bombas de agua", "done": false, "time": "03:00"},
    {"title": "Informe incidencias nocturnas", "done": false, "time": "06:00"},
  ];

  @override
  void initState() {
    super.initState();
    _updateTimeAndShift();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) => _updateTimeAndShift(),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _loadTaskStatus() async {
    final prefs = await SharedPreferences.getInstance();
    
    for (var task in _currentTasks) {
      String key = "task_${_dateString}_${_currentShiftName}_${task['title']}";     
      bool isDone = prefs.getBool(key) ?? false;
      task['done'] = isDone;
    }
    
    if (mounted) setState(() {}); 
  }

  Future<void> _saveTaskStatus(int index, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final task = _currentTasks[index];
    
    String key = "task_${_dateString}_${_currentShiftName}_${task['title']}";
    
    await prefs.setBool(key, value);
  }

  void _updateTimeAndShift() {
    final DateTime now = DateTime.now();
    final int hour = now.hour;
    
    String newDateString = "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}";
    String newTimeString = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    String newShift;
    List<Map<String, dynamic>> newTaskList;

    if (hour >= 7 && hour < 15) {
      newShift = "Turno de Mañana (07:00 - 15:00)";
      newTaskList = _morningTasks;
    } else if (hour >= 15 && hour < 23) {
      newShift = "Turno de Tarde (15:00 - 23:00)";
      newTaskList = _afternoonTasks;
    } else {
      newShift = "Turno de Noche (23:00 - 07:00)";
      newTaskList = _nightTasks;
    }

    //CAMBIO DE TURNO
    if (_currentShiftName != newShift || _dateString != newDateString) {
      _currentTasks = newTaskList;
      _currentShiftName = newShift;
      _dateString = newDateString;
    
      _loadTaskStatus(); 
    }

    if (mounted) {
      setState(() {
        _timeString = newTimeString;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas Diarias'),
      ),
      drawer: const SideMenu(currentPage: 'tasks'),
      body: Column(
        children: [
          // CABECERA HORA y FECHA
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.3),
                  blurRadius: 10,
                  offset: Offset(0, 5),
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
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 255, 255, 0.2), 
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _currentShiftName,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),

          // LISTA DE TAREAS
          Expanded(
            child: _currentTasks.isEmpty
              ? const Center(child: Text("No hay tareas asignadas"))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: _currentTasks.length,
                  itemBuilder: (context, index) {
                    final task = _currentTasks[index];
                    final bool isDone = task['done'];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      elevation: 2,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        leading: Checkbox(
                          activeColor: AppTheme.primary,
                          value: isDone,
                          onChanged: (bool? value) {
                            setState(() => task['done'] = value!);
                            _saveTaskStatus(index, value!);
                          },
                        ),
                        title: Text(
                          task['title'],
                          style: TextStyle(
                            fontSize: 16,
                            decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,
                            color: isDone 
                                ? Colors.grey 
                                : (isDarkMode ? Colors.white : Colors.black87),
                          ),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            task['time'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: isDarkMode ? Colors.white70 : Colors.black87,
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