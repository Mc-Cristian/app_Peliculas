import 'package:app_peliculas/auth/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_peliculas/navigation/Drawer.dart';
import 'package:app_peliculas/screens/PeliculasScreen.dart';
import 'dart:math' as Math;

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen>
    with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  String? _selectedGender;

  bool _isLoading = false;
  String? _errorMessage;

  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late AnimationController _backgroundController;
  late AnimationController _formController;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _formAnimation;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 25),
      vsync: this,
    );

    _formController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 1.2), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
        );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.linear),
    );

    _formAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _formController, curve: Curves.elasticOut),
    );

    // Inicializar los controladores con valores seguros antes de comenzar las animaciones
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAnimations();
    });
  }

  void _startAnimations() async {
    if (mounted) {
      _backgroundController.repeat();
      _pulseController.repeat(reverse: true);

      await Future.delayed(const Duration(milliseconds: 400));
      if (mounted) _fadeController.forward();

      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) _slideController.forward();

      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) _formController.forward();
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _dateOfBirthController.dispose();
    _slideController.dispose();
    _fadeController.dispose();
    _pulseController.dispose();
    _backgroundController.dispose();
    _formController.dispose();
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
              primary: Color(0xFF1C1C1C),
              onPrimary: Colors.white,
              surface: Color(0xFF2E2E2E),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF121212),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateOfBirthController.text = "${picked.toLocal()}".split(' ')[0];
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

    if (email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        fullName.isEmpty ||
        phoneNumber.isEmpty ||
        dateOfBirth.isEmpty ||
        gender == null) {
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
      final AuthResponse authResponse = await Supabase.instance.client.auth
          .signUp(email: email, password: password);

      if (authResponse.user != null) {
        final String userId = authResponse.user!.id;

        try {
          await Supabase.instance.client.from('profiles').insert({
            'id': userId,
            'full_name': fullName,
            'phone_number': phoneNumber,
            'date_of_birth': dateOfBirth,
            'gender': gender,
            'created_at': DateTime.now().toIso8601String(),
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Registro exitoso. Revisa tu correo para verificar tu cuenta.',
                ),
                backgroundColor: Colors.green.withOpacity(0.8),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (Route<dynamic> route) => false,
            );
          }
        } on PostgrestException catch (e) {
          setState(() {
            _errorMessage =
                'Error al guardar detalles del perfil: ${e.message}';
          });
          return;
        } catch (e) {
          setState(() {
            _errorMessage =
                'Error inesperado al guardar el perfil: ${e.toString()}';
          });
          return;
        }
      } else {
        setState(() {
          _errorMessage = authResponse.session == null
              ? 'Error al registrar usuario: puede que ya exista.'
              : 'Error desconocido durante el registro.';
        });
      }
    } on AuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
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
      extendBodyBehindAppBar: true,
      drawer: const MiDrawer(),
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.white, Colors.grey, Colors.white],
          ).createShader(bounds),
          child: const Text(
            'Regístrate a NoirFlix',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0a0a0a), Color(0xFF1a1a1a)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Fondo dinámico con múltiples capas
          AnimatedBuilder(
            animation: _backgroundAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(
                      0.4 * Math.cos(_backgroundAnimation.value * 2 * Math.pi),
                      0.4 * Math.sin(_backgroundAnimation.value * 2 * Math.pi),
                    ),
                    radius: 1.8,
                    colors: const [
                      Color(0xFF1a1a1a),
                      Color(0xFF000000),
                      Color(0xFF2a2a2a),
                      Color(0xFF000000),
                    ],
                  ),
                ),
              );
            },
          ),

          // Imagen de fondo con efecto parallax
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _backgroundAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale:
                      1.1 +
                      0.08 * Math.sin(_backgroundAnimation.value * 2 * Math.pi),
                  child: Opacity(
                    opacity: 0.3,
                    child: Image.network(
                      'https://st4.depositphotos.com/1536490/21371/v/450/depositphotos_213718594-stock-illustration-icon-black-retro-movie-camera.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),

          // Overlay con gradiente cinematográfico
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xE6000000),
                  Color(0x99000000),
                  Color(0xCC000000),
                  Color(0xE6000000),
                ],
                stops: [0.0, 0.3, 0.7, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Partículas flotantes
          ...List.generate(
            20,
            (index) => AnimatedBuilder(
              animation: _backgroundAnimation,
              builder: (context, child) {
                // Asegurar que la opacidad esté en el rango válido
                double opacity = (0.08 + (index % 4) * 0.05).clamp(0.0, 1.0);
                double shadowOpacity = 0.1.clamp(0.0, 1.0);

                return Positioned(
                  left:
                      (index * 50.0 + _backgroundAnimation.value * 80) %
                      MediaQuery.of(context).size.width,
                  top:
                      (index * 35.0 + _backgroundAnimation.value * 60) %
                      MediaQuery.of(context).size.height,
                  child: Container(
                    width: 2 + (index % 3),
                    height: 2 + (index % 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(opacity),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(shadowOpacity),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Contenido principal
          SafeArea(
            child: AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                // Asegurar que la opacidad esté en el rango válido
                double opacity = _fadeAnimation.value.clamp(0.0, 1.0);

                return Opacity(
                  opacity: opacity,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),

                          // Icono principal con animación
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              // Asegurar que el valor de scale esté en un rango seguro
                              double scale = _pulseController.isAnimating
                                  ? _pulseAnimation.value.clamp(0.5, 2.0)
                                  : 1.0;

                              return Transform.scale(
                                scale: scale,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        blurRadius: 25,
                                        spreadRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.movie_filter,
                                    size: 90,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 25),

                          // Título con efecto shimmer
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Colors.white, Colors.grey, Colors.white],
                            ).createShader(bounds),
                            child: const Text(
                              'Crea tu cuenta para disfrutar de películas',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 1.2,
                                shadows: [
                                  Shadow(
                                    color: Colors.black54,
                                    offset: Offset(2, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          const SizedBox(height: 40),

                          // Campos del formulario con animaciones escalonadas
                          AnimatedBuilder(
                            animation: _formAnimation,
                            builder: (context, child) {
                              return Column(
                                children: [
                                  _buildAnimatedTextField(
                                    controller: _fullNameController,
                                    icon: Icons.person_outline,
                                    label: 'Nombre Completo',
                                    keyboardType: TextInputType.name,
                                    delay: 0,
                                  ),

                                  const SizedBox(height: 20),

                                  _buildAnimatedTextField(
                                    controller: _phoneNumberController,
                                    icon: Icons.phone_outlined,
                                    label: 'Número de Teléfono',
                                    keyboardType: TextInputType.phone,
                                    delay: 100,
                                  ),

                                  const SizedBox(height: 20),

                                  _buildAnimatedDateField(delay: 200),

                                  const SizedBox(height: 20),

                                  _buildAnimatedDropdownField(delay: 300),

                                  const SizedBox(height: 20),

                                  _buildAnimatedTextField(
                                    controller: _emailController,
                                    icon: Icons.email_outlined,
                                    label: 'Correo electrónico',
                                    keyboardType: TextInputType.emailAddress,
                                    delay: 400,
                                  ),

                                  const SizedBox(height: 20),

                                  _buildAnimatedTextField(
                                    controller: _passwordController,
                                    icon: Icons.lock_outline,
                                    label: 'Contraseña',
                                    obscureText: true,
                                    delay: 500,
                                  ),

                                  const SizedBox(height: 20),

                                  _buildAnimatedTextField(
                                    controller: _confirmPasswordController,
                                    icon: Icons.lock_reset,
                                    label: 'Confirmar Contraseña',
                                    obscureText: true,
                                    delay: 600,
                                  ),
                                ],
                              );
                            },
                          ),

                          // Mensaje de error con animación
                          if (_errorMessage != null)
                            TweenAnimationBuilder<double>(
                              duration: const Duration(milliseconds: 500),
                              tween: Tween(begin: 0.0, end: 1.0),
                              builder: (context, value, child) {
                                // Asegurar que el valor de scale esté en un rango válido
                                double scale = value.clamp(0.0, 1.0);

                                return Transform.scale(
                                  scale: scale,
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      border: Border.all(
                                        color: Colors.red.withOpacity(0.5),
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.red.withOpacity(0.2),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      _errorMessage!,
                                      style: const TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              },
                            ),

                          const SizedBox(height: 30),

                          // Botón de registro mejorado
                          TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 1200),
                            tween: Tween(begin: 0.0, end: 1.0),
                            curve: Curves.elasticOut,
                            builder: (context, value, child) {
                              // Asegurar que el valor de scale esté en un rango válido
                              double scale = value.clamp(0.0, 1.0);

                              return Transform.scale(
                                scale: scale,
                                child: _isLoading
                                    ? Container(
                                        height: 65,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF1C1C1C),
                                              Color(0xFF2C2C2C),
                                            ],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.4,
                                              ),
                                              blurRadius: 15,
                                              offset: const Offset(0, 8),
                                            ),
                                          ],
                                        ),
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 3,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF1C1C1C),
                                              Color(0xFF2C2C2C),
                                            ],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.5,
                                              ),
                                              blurRadius: 20,
                                              offset: const Offset(0, 10),
                                            ),
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(
                                                0.2,
                                              ),
                                              blurRadius: 25,
                                              offset: const Offset(0, 15),
                                            ),
                                          ],
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(
                                              18,
                                            ),
                                            onTap: _signUp,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 20,
                                                  ),
                                              child: const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.check_circle_outline,
                                                    color: Colors.white,
                                                    size: 26,
                                                  ),
                                                  SizedBox(width: 15),
                                                  Text(
                                                    'Crear cuenta',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 1.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                              );
                            },
                          ),

                          const SizedBox(height: 20),
                        ],
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

  Widget _buildAnimatedTextField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    TextInputType? keyboardType,
    bool obscureText = false,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 1000 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        // Asegurar que los valores estén en rangos válidos
        double opacity = value.clamp(0.0, 1.0);
        double translateY = (40 * (1 - value)).clamp(-200.0, 200.0);

        return Transform.translate(
          offset: Offset(0, translateY),
          child: Opacity(
            opacity: opacity,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: TextField(
                controller: controller,
                obscureText: obscureText,
                keyboardType: keyboardType,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  prefixIcon: Container(
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: Colors.grey, size: 22),
                  ),
                  labelText: label,
                  labelStyle: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Colors.grey.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.7),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedDateField({required int delay}) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 1000 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        // Asegurar que los valores estén en rangos válidos
        double opacity = value.clamp(0.0, 1.0);
        double translateY = (40 * (1 - value)).clamp(-200.0, 200.0);

        return Transform.translate(
          offset: Offset(0, translateY),
          child: Opacity(
            opacity: opacity,
            child: GestureDetector(
              onTap: () => _selectDateOfBirth(context),
              child: AbsorbPointer(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _dateOfBirthController,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    decoration: InputDecoration(
                      prefixIcon: Container(
                        margin: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.grey,
                          size: 22,
                        ),
                      ),
                      labelText: 'Fecha de Nacimiento (YYYY-MM-DD)',
                      labelStyle: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.7),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedDropdownField({required int delay}) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 1000 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        // Asegurar que los valores estén en rangos válidos
        double opacity = value.clamp(0.0, 1.0);
        double translateY = (40 * (1 - value)).clamp(-200.0, 200.0);

        return Transform.translate(
          offset: Offset(0, translateY),
          child: Opacity(
            opacity: opacity,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedGender,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                },
                items: <String>['Masculino', 'Femenino', 'Otro']
                    .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    })
                    .toList(),
                style: const TextStyle(color: Colors.white, fontSize: 16),
                dropdownColor: const Color(0xFF2C2C2C),
                decoration: InputDecoration(
                  prefixIcon: Container(
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: Colors.grey,
                      size: 22,
                    ),
                  ),
                  labelText: 'Género',
                  labelStyle: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Colors.grey.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.7),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
