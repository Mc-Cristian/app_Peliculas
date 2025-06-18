import 'package:flutter/material.dart';

class CategoriasScreen extends StatelessWidget {
  final List<Map<String, dynamic>> peliculas;

  const CategoriasScreen({super.key, required this.peliculas});

  List<String> _obtenerCategoriasUnicas() {
    final categorias = <String>{};
    for (final pelicula in peliculas) {
      categorias.addAll((pelicula['generos'] as List).cast<String>());
    }
    return categorias.toList();
  }

  @override
  Widget build(BuildContext context) {
    final categorias = _obtenerCategoriasUnicas();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
      ),
      body: ListView.builder(
        itemCount: categorias.length,
        itemBuilder: (context, index) {
          final categoria = categorias[index];
          final peliculasEnCategoria = peliculas.where((p) => 
              (p['generos'] as List).contains(categoria)).toList();
              
          return ExpansionTile(
            title: Text(categoria),
            children: peliculasEnCategoria.map((pelicula) => ListTile(
              leading: Image.network(pelicula['imagen'], width: 40),
              title: Text(pelicula['titulo']),
              onTap: () {
                // Mostrar detalles de la película
              },
            )).toList(),
          );
        },
      ),
    );
  }
}