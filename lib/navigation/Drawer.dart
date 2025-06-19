import 'dart:convert';

import 'package:app_peliculas/screens/BuscarScreen.dart';
import 'package:app_peliculas/screens/CategoriasScreen.dart';
import 'package:app_peliculas/screens/PeliculasScreen.dart';
import 'package:flutter/material.dart';
import 'package:app_peliculas/main.dart';

class MiDrawer extends StatelessWidget {
  final bool isLoggedIn;
  final String? userName;

  const MiDrawer({super.key, this.isLoggedIn = false, this.userName});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1A1A1A), // Fondo oscuro del Drawer
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF101010), Color(0xFF2E2E2E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    isLoggedIn ? 'Hola, $userName!' : 'Bienvenido',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          _buildDrawerItem(
            icon: Icons.movie,
            text: 'Películas',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PeliculasScreen()),
              );
            },
          ),

          _buildDrawerItem(
            icon: Icons.search,
            text: 'Buscar',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const BuscarScreen(), // ya no se pasan datos
                ),
              );
            },
          ),

          _buildDrawerItem(
            icon: Icons.category,
            text: 'Categorías',
            onTap: () {
              Navigator.pop(context);
              // Aquí puedes agregar la navegación a la pantalla de categorías
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoriasScreen(peliculas: []),
                ),
              );
            },
          ),

          // Opción de cerrar sesión si está logueado
          if (isLoggedIn)
            _buildDrawerItem(
              icon: Icons.logout,
              text: 'Cerrar Sesión',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProyectoF()),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(text, style: const TextStyle(color: Colors.white)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      hoverColor: Colors.grey.withOpacity(0.1),
      onTap: onTap,
    );
  }
}
