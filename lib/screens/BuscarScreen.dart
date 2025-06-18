import 'package:flutter/material.dart';

class BuscarScreen extends StatefulWidget {
  final List<Map<String, dynamic>> peliculas;

  const BuscarScreen({super.key, required this.peliculas});

  @override
  State<BuscarScreen> createState() => _BuscarScreenState();
}

class _BuscarScreenState extends State<BuscarScreen> {
  late List<Map<String, dynamic>> _peliculasFiltradas;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _peliculasFiltradas = widget.peliculas;
    _searchController.addListener(_filtrarPeliculas);
  }

  void _filtrarPeliculas() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _peliculasFiltradas = widget.peliculas.where((pelicula) {
        return pelicula['titulo'].toLowerCase().contains(query) ||
               pelicula['generos'].any((genero) => genero.toLowerCase().contains(query));
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Buscar películas...',
            border: InputBorder.none,
          ),
        ),
      ),
      body: _peliculasFiltradas.isEmpty
          ? const Center(child: Text('No se encontraron resultados'))
          : ListView.builder(
              itemCount: _peliculasFiltradas.length,
              itemBuilder: (context, index) {
                final pelicula = _peliculasFiltradas[index];
                return ListTile(
                  leading: Image.network(pelicula['imagen'], width: 50),
                  title: Text(pelicula['titulo']),
                  subtitle: Text(pelicula['generos'].join(', ')),
                  onTap: () {
                    // Mostrar detalles de la película
                  },
                );
              },
            ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}