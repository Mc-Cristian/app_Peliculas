import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_peliculas/navigation/Drawer.dart';
import 'package:app_peliculas/screens/PeliculasScreen.dart'; // Asegúrate de que la ruta sea correcta

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController(); // Nuevo campo
  final TextEditingController _phoneNumberController = TextEditingController(); // Nuevo campo
  final TextEditingController _dateOfBirthController = TextEditingController(); // Nuevo campo
  String? _selectedGender; // Nuevo campo para selección

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  Future<void> _selectDateOfBirth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF1C1C1C), // Color principal del calendario
              onPrimary: Colors.white,
              surface: Color(0xFF2E2E2E), // Color de fondo del calendario
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF121212), // Fondo del diálogo del calendario
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateOfBirthController.text = "${picked.toLocal()}".split(' ')[0]; // Formato YYYY-MM-DD
      });
    }
  }

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final fullName = _fullNameController.text.trim();
    final phoneNumber = _phoneNumberController.text.trim();
    final dateOfBirth = _dateOfBirthController.text.trim();
    final gender = _selectedGender;

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty ||
        fullName.isEmpty || phoneNumber.isEmpty || dateOfBirth.isEmpty || gender == null) {
      setState(() {
        _errorMessage = 'Por favor, completa todos los campos.';
        _isLoading = false;
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        _errorMessage = 'Las contraseñas no coinciden.';
        _isLoading = false;
      });
      return;
    }

    try {
      // 1. Registrar al usuario con correo y contraseña en Supabase Auth
      final AuthResponse authResponse = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      if (authResponse.user != null) {
        final String userId = authResponse.user!.id; // Obtener el ID de usuario de Supabase Auth

        // 2. Insertar los datos adicionales en la tabla 'profiles'
        try {
          await Supabase.instance.client.from('profiles').insert({
            'id': userId, // Vinculamos el perfil con el ID de usuario de autenticación
            'full_name': fullName,
            'phone_number': phoneNumber,
            'date_of_birth': dateOfBirth,
            'gender': gender,
            'created_at': DateTime.now().toIso8601String(), // O puedes usar un default en Supabase
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registro exitoso. Revisa tu correo para verificar tu cuenta.')),
            );
            // Navegar a la pantalla de películas y eliminar la pila de navegación anterior
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => PeliculasScreen()),
              (Route<dynamic> route) => false,
            );
          }
        } on PostgrestException catch (e) {
          // Manejar errores específicos de la base de datos (ej. RLS, constraint violations)
          setState(() {
            _errorMessage = 'Error al guardar detalles del perfil en la base de datos: ${e.message}';
          });
          // Opcional: Si la inserción del perfil falla, podrías considerar eliminar el usuario de auth
          // para evitar tener usuarios sin perfil. Esto depende de tu lógica de negocio.
          // await Supabase.instance.client.auth.admin.deleteUser(userId);
          return;
        } catch (e) {
          // Manejar otros errores inesperados durante la inserción del perfil
          setState(() {
            _errorMessage = 'Ocurrió un error inesperado al guardar el perfil: ${e.toString()}';
          });
          // Opcional: Eliminar usuario de auth si el perfil falla
          // await Supabase.instance.client.auth.admin.deleteUser(userId);
          return;
        }
      } else {
        // Esto se ejecuta si authResponse.user es null, indicando un problema con el registro de autenticación
        setState(() {
          _errorMessage = authResponse.session == null
              ? 'Error al registrar usuario: Posiblemente ya existe o credenciales inválidas.'
              : 'Error desconocido durante el registro de autenticación.';
        });
      }
    } on AuthException catch (e) {
      // Manejar errores específicos de autenticación de Supabase (ej. correo inválido, contraseña débil)
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      // Manejar otros errores inesperados
      setState(() {
        _errorMessage = 'Ocurrió un error inesperado durante el registro: ${e.toString()}';
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
      extendBodyBehindAppBar: true,
      drawer: const MiDrawer(),
      appBar: AppBar(
        title: const Text(
          'Regístrate a 20th Century Studios',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF121212), Color(0xFF2E2E2E)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.movie_filter,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Crea tu cuenta para disfrutar de películas',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  _buildTextField(
                    controller: _fullNameController,
                    labelText: 'Nombre Completo',
                    icon: Icons.person_outline,
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _phoneNumberController,
                    labelText: 'Número de Teléfono',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => _selectDateOfBirth(context),
                    child: AbsorbPointer(
                      child: _buildTextField(
                        controller: _dateOfBirthController,
                        labelText: 'Fecha de Nacimiento (YYYY-MM-DD)',
                        icon: Icons.calendar_today_outlined,
                        keyboardType: TextInputType.datetime,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildDropdownField(),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _emailController,
                    labelText: 'Correo electrónico',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _passwordController,
                    labelText: 'Contraseña',
                    icon: Icons.lock_outline,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _confirmPasswordController,
                    labelText: 'Confirmar Contraseña',
                    icon: Icons.lock_reset,
                    obscureText: true,
                  ),
                  if (_errorMessage != null)
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
                          onPressed: _signUp,
                          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                          label: const Text(
                            'Crear cuenta',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1C1C1C),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
          ),
        ],
      ),
    );
  }

  // Funciones auxiliares para construir los campos de texto y dropdown
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey),
        labelText: labelText,
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
      keyboardType: keyboardType,
      cursorColor: Colors.white,
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.wc_outlined, color: Colors.grey),
        labelText: 'Género',
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
      ),
      dropdownColor: const Color(0xFF1C1C1C), // Color de fondo del desplegable
      style: const TextStyle(color: Colors.white),
      iconEnabledColor: Colors.grey,
      onChanged: (String? newValue) {
        setState(() {
          _selectedGender = newValue;
        });
      },
      items: <String>['Masculino', 'Femenino', 'Otro']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}