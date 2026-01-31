import 'dart:io'; // Necesario para borrar archivos del móvil
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
  final User? currentUser = FirebaseAuth.instance.currentUser;

  //Variables para la creación de nueva incidencia
  File? _selectedImage;
  bool _isLoading = false;

  //SELECCIONAR FOTO
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    //Calidad 50 para ahorrar espacio
    final pickedFile = await picker.pickImage(source: source, imageQuality: 50);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  //GUARDAR INCIDENCIA
  Future<void> _addIncident() async {
    if (_textController.text.isEmpty) return;

    setState(() => _isLoading = true);
    Navigator.pop(context);
    try {
      // Guardamos en Firestore
      await FirebaseFirestore.instance.collection('incidencias').add({
        'title': _textController.text,
        'userId': currentUser?.uid,
        'email': currentUser?.email,
        'isDone': false,
        'date': Timestamp.now(),
        // Guardamos la ruta interna del archivo en el móvil
        'localImagePath': _selectedImage?.path,
      });

      _textController.clear();
      _selectedImage = null;

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Incidencia guardada 📂')));
      }
    } catch (e) {
      debugPrint("Error al guardar: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  //BORRAR INCIDENCIA Y FOTO LOCAL
  Future<void> _deleteIncident(
    String docId,
    bool isDone,
    String? imagePath,
  ) async {
    Future<void> deleteData() async {
      try {
        if (imagePath != null) {
          final file = File(imagePath);
          if (await file.exists()) {
            await file.delete();
            debugPrint("🗑️ Foto eliminada del dispositivo: $imagePath");
          }
        }

        //Borramos el documento de la base de datos
        await FirebaseFirestore.instance
            .collection('incidencias')
            .doc(docId)
            .delete();
      } catch (e) {
        debugPrint("Error al borrar: $e");
      }
    }

    // Si ya está hecha, borramos directo. Si no, preguntamos.
    if (isDone) {
      await deleteData();
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('¿Eliminar?'),
          content: const Text(
            'Se borrará la incidencia y su foto asociada del dispositivo.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                await deleteData();
                if (mounted) Navigator.pop(context);
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

  void _showAddDialog() {
    _selectedImage = null; // Reseteamos la imagen al abrir
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
                  decoration: const InputDecoration(
                    hintText: 'Ej: Puerta atascada hab. 101',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),

                // Previsualización en el diálogo
                if (_selectedImage != null)
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: FileImage(_selectedImage!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.camera_alt,
                        color: AppTheme.primary,
                      ),
                      onPressed: () async {
                        await _pickImage(ImageSource.camera);
                        setDialogState(() {});
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.photo, color: AppTheme.primary),
                      onPressed: () async {
                        await _pickImage(ImageSource.gallery);
                        setDialogState(() {});
                      },
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: _addIncident,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                ),
                child: const Text(
                  'Guardar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mantenimiento (Local)',
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: false,
      ),
      drawer: const SideMenu(currentPage: 'home'),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('incidencias')
            .where('userId', isEqualTo: currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(
              child: Text('No tienes incidencias registradas.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final docId = docs[index].id;
              final bool isDone = data['isDone'] ?? false;

              // Recuperamos la ruta local de la foto
              final String? localPath = data['localImagePath'];
              File? imageFile;
              if (localPath != null) {
                imageFile = File(localPath);
              }

              return Card(
                color: isDone ? Colors.grey[200] : Colors.white,
                child: Column(
                  children: [
                    // Muestra la foto SI existe el archivo en el móvil
                    if (imageFile != null && imageFile.existsSync())
                      SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: Image.file(imageFile, fit: BoxFit.cover),
                      )
                    // Si hay ruta pero se borró el archivo, mostramos icono roto
                    else if (localPath != null)
                      Container(
                        height: 60,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.broken_image, color: Colors.grey),
                        ),
                      ),

                    ListTile(
                      leading: IconButton(
                        icon: Icon(
                          isDone
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: isDone ? Colors.green : AppTheme.primary,
                        ),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('incidencias')
                              .doc(docId)
                              .update({'isDone': !isDone});
                        },
                      ),
                      title: Text(
                        data['title'],
                        style: TextStyle(
                          decoration: isDone
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // PASAMOS LA RUTA DE LA FOTO PARA BORRARLA
                          _deleteIncident(docId, isDone, localPath);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
