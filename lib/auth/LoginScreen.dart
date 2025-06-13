import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_peliculas/navigation/Drawer.dart';
import 'package:app_peliculas/screens/PeliculasScreen.dart'; // Asegúrate de que la ruta sea correcta

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage; // Para mostrar mensajes de error en la UI

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Limpiar mensaje de error anterior
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, ingresa tu correo y contraseña.';
        _isLoading = false;
      });
      return;
    }

    try {
      // Intentar iniciar sesión con Supabase
      final AuthResponse response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // Inicio de sesión exitoso, navegar a la pantalla de películas
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => PeliculasScreen()),
            (Route<dynamic> route) => false,
          );
        }
      } else {
        // Esto puede ocurrir si el usuario no existe o las credenciales son incorrectas
        setState(() {
          _errorMessage = 'Error al iniciar sesión: Credenciales inválidas.';
        });
      }
    } on AuthException catch (e) {
      // Manejar errores específicos de autenticación de Supabase
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      // Manejar otros errores inesperados
      setState(() {
        _errorMessage = 'Ocurrió un error inesperado: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MiDrawer(), // Asegúrate de que MiDrawer esté disponible
      appBar: AppBar(
        title: const Text(
          'Iniciar Sesión a 20th Century Studios',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF101010),
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Imagen de fondo que ocupa toda la pantalla
          SizedBox.expand(
            child: Image.network(
              'https://resizer.glanacion.com/resizer/v2/logos-originales-de-estudios-de-hollywood-20th-HLSV22NJHFFCDDL5OQ47YB7EJ4.JPG?auth=872c7a2272149bce1813ea83cf3087718fb97f5d8659989490e0a4409bc2c2f4&width=420&height=280&quality=70&smart=true',
              fit: BoxFit.cover,
            ),
          ),

          // Degradado encima de la imagen para mejor visibilidad
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xCC121212), Color(0xCC2E2E2E)], // Colores semi-translúcidos
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Contenido scrollable
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.play_circle_fill,
                  size: 80,
                  color: Colors.grey,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Bienvenido a 20th Century Studios',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _emailController, // Controlador para el correo
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
                    labelText: 'Correo electrónico',
                    labelStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    filled: true,
                    fillColor: Colors.black87,
                  ),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Colors.white,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController, // Controlador para la contraseña
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                    labelText: 'Contraseña',
                    labelStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    filled: true,
                    fillColor: Colors.black87,
                  ),
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                ),
                if (_errorMessage != null) // Mostrar mensaje de error si existe
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 30),
                _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.white))
                    : ElevatedButton.icon(
                        onPressed: _signIn, // Llamar a la función de inicio de sesión
                        icon: const Icon(
                          Icons.play_circle_fill,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Ingresar',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1C1C1C),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Colors.grey),
                          ),
                          elevation: 4,
                          shadowColor: Colors.black.withOpacity(0.5),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
