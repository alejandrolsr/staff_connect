import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import '../widgets/side_menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _solutionController = TextEditingController(); // NUEVO: Controlador para la solución
  final User? currentUser = FirebaseAuth.instance.currentUser;

  File? _selectedImage;
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _addIncident() async {
    if (_textController.text.isEmpty) return;
    setState(() => _isLoading = true);
    Navigator.pop(context);

    try {
      await FirebaseFirestore.instance.collection('incidencias').add({
        'title': _textController.text,
        'userId': currentUser?.uid,
        'email': currentUser?.email,
        'isDone': false,
        'date': Timestamp.now(),
        'localImagePath': _selectedImage?.path,
        'solution': '', 
      });

      _textController.clear();
      _selectedImage = null;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Incidencia guardada 📂')));
      }
    } catch (e) {
      debugPrint("Error al guardar: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showCompleteDialog(String docId, String currentTitle) {
    _solutionController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Incidencia'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Incidencia: $currentTitle", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("Describe cómo la has solucionado:"),
            const SizedBox(height: 10),
            TextField(
              controller: _solutionController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Ej: Se cambió el fusible...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () async {
              if (_solutionController.text.isNotEmpty) {
                await FirebaseFirestore.instance.collection('incidencias').doc(docId).update({
                  'isDone': true,
                  'solution': _solutionController.text, //Guardamos la solución
                  'completedBy': currentUser?.email, //Guardamos quién lo arregló
                  'completedDate': Timestamp.now(),
                });
                if (mounted) Navigator.pop(context);
              }
            },
            child: const Text('Marcar Solucionada', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  //MÉTODO PARA BORRAR
  Future<void> _deleteIncident(String docId, String? imagePath) async {
    final navigator = Navigator.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar?'),
        content: const Text('Se borrará permanentemente.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                if (imagePath != null) {
                  final file = File(imagePath);
                  if (await file.exists()) await file.delete();
                }
                await FirebaseFirestore.instance.collection('incidencias').doc(docId).delete();
              } catch (e) {
                debugPrint("Error: $e");
              }
              navigator.pop();
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  //DIÁLOGO DE AGREGAR INCIDENCIA
  void _showAddDialog() {
    _selectedImage = null;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Nueva Incidencia'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _textController,
                  decoration: const InputDecoration(hintText: 'Descripción del problema', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                if (_selectedImage != null)
                  SizedBox(height: 100, child: Image.file(_selectedImage!)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(icon: const Icon(Icons.camera_alt), onPressed: () async { await _pickImage(ImageSource.camera); setDialogState(() {}); }),
                    IconButton(icon: const Icon(Icons.photo), onPressed: () async { await _pickImage(ImageSource.gallery); setDialogState(() {}); }),
                  ],
                ),
              ],
            ),
            actions: [
              ElevatedButton(onPressed: _addIncident, child: const Text('Guardar')),
            ],
          );
        },
      ),
    );
  }

  //LISTA DE INCIDENCIAS
  Widget _buildIncidentList({required bool isPendingList}) {
    Query query = FirebaseFirestore.instance.collection('incidencias');

    if (isPendingList) {
      //PENDIENTES: Solo muestra las mías y que NO estén hechas
      query = query.where('userId', isEqualTo: currentUser?.uid).where('isDone', isEqualTo: false);
    } else {
      //COMPLETADAS: Muestra las de TODOS y que estén hechas
      query = query.where('isDone', isEqualTo: true).orderBy('completedDate', descending: true);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) return Center(child: Text(isPendingList ? 'Todo en orden 👍' : 'Aún no hay historial'));

        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final docId = docs[index].id;
            final String? localPath = data['localImagePath'];
            
            return Card(
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 12),
              child: Column(
                children: [
                  //FOTO
                  if (localPath != null && File(localPath).existsSync())
                    SizedBox(height: 150, width: double.infinity, child: Image.file(File(localPath), fit: BoxFit.cover)),
                  
                  ListTile(
                    title: Text(data['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: isPendingList 
                      ? Text(data['email'] ?? "")
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            Text("✅ Solución: ${data['solution'] ?? 'Sin detalles'}", 
                                style: const TextStyle(color: Colors.green, fontStyle: FontStyle.italic)),
                            Text("Por: ${data['completedBy'] ?? 'Anónimo'}", style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                    trailing: isPendingList
                      ? IconButton(
                          icon: const Icon(Icons.check_circle_outline, size: 30, color: Colors.grey),
                          onPressed: () => _showCompleteDialog(docId, data['title']),
                        )
                      : const Icon(Icons.check_circle, color: Colors.green),
                  ),
                  
                  if (data['userId'] == currentUser?.uid)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                        label: const Text("Borrar", style: TextStyle(color: Colors.red)),
                        onPressed: () => _deleteIncident(docId, localPath),
                      ),
                    )
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gestión de Incidencias'),
          centerTitle: false,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            tabs: [
              Tab(icon: Icon(Icons.assignment), text: "Mis Pendientes"),
              Tab(icon: Icon(Icons.history_edu), text: "Historial Global"),
            ],
          ),
        ),
        drawer: const SideMenu(currentPage: 'home'),
        
        body: Stack(
          children: [
            TabBarView(
              children: [
                _buildIncidentList(isPendingList: true),
                _buildIncidentList(isPendingList: false),
              ],
            ),
            if (_isLoading)
              Container(color: Colors.black45, child: const Center(child: CircularProgressIndicator())),
          ],
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: _showAddDialog,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}