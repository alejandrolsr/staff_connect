import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Controladores para leer lo que escribe el usuario
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  //Validar el formulario
  final _formKey = GlobalKey<FormState>();

  void _doLogin() {
    if (_formKey.currentState!.validate()) {
      if (_userController.text == 'usuario' &&
          _passController.text == 'usuario') {
        Navigator.pushReplacementNamed(context, 'home');
      } else {
        //Mensaje de error si falla
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Credenciales incorrectas (Prueba: usuario / usuario)',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Evito con SingleChildScrollView el error de píxeles por si sale el teclado
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // LOGO
                Image.asset('assets/images/logo_miramar.png', height: 120),
                const SizedBox(height: 20),

                Text(
                  'Acceso Personal',
                  style: GoogleFonts.lato(
                    fontSize: 28,
                    color: const Color(0xFF005b96),
                  ),
                ),
                const SizedBox(height: 40),

                // CAMPO USUARIO
                TextFormField(
                  controller: _userController,
                  decoration: const InputDecoration(
                    labelText: 'Usuario / Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Escribe el usuario';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // CAMPO CONTRASEÑA
                TextFormField(
                  controller: _passController,
                  obscureText: true, // Ocultar texto
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Escribe la contraseña';
                    return null;
                  },
                ),
                const SizedBox(height: 40),

                // BOTÓN ENTRAR
                SizedBox(
                  width: double.infinity, // Que ocupe todo el ancho
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _doLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF005b96),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('ENTRAR', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
