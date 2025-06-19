import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class BuscarScreen extends StatefulWidget {
  const BuscarScreen({super.key});

  @override
  State<BuscarScreen> createState() => _BuscarScreenState();
}

class _BuscarScreenState extends State<BuscarScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<Map<String, dynamic>> _peliculasFiltradas;

  // JSON local embebido directamente
  final Map<String, dynamic> peliculasData = {
    'accion': [
      {
        'titulo': 'Avengers: Endgame',
        'imagen': 'https://m.media-amazon.com/images/I/81ExhpBEbHL._AC_SY679_.jpg',
        'descripcion': 'Los Vengadores se enfrentan a su mayor desafío.',
        'year': 2019,
        'rating': 8.4,
        'duracion': '3h 2m',
        'generos': ['Acción', 'Aventura'],
        'trailer': 'TcMBFSGVi1c'
      },
      {
        'titulo': 'Mad Max: Fury Road',
        'imagen': 'https://m.media-amazon.com/images/I/91zFgZQnqNL._AC_SL1500_.jpg',
        'descripcion': 'En un mundo post-apocalíptico, Max lucha por sobrevivir.',
        'year': 2015,
        'rating': 8.1,
        'duracion': '2h',
        'generos': ['Acción', 'Ciencia ficción'],
        'trailer': 'hEJnMQG9ev8'
      }
    ],
    'drama': [
      {
        'titulo': 'The Pursuit of Happyness',
        'imagen': 'https://m.media-amazon.com/images/I/51eHtkDd5kL.jpg',
        'descripcion': 'La historia de superación de un padre con su hijo.',
        'year': 2006,
        'rating': 8.0,
        'duracion': '1h 57m',
        'generos': ['Drama', 'Biografía'],
        'trailer': '89Kq8SDyvfg'
      }
    ],
    "Ciencia Ficcion": [
    {
      "titulo": "Interstellar",
      "imagen": "https://m.media-amazon.com/images/I/91kFYg4fX3L._AC_SL1500_.jpg",
      "descripcion": "Exploradores viajan más allá de nuestra galaxia para encontrar un nuevo hogar para la humanidad.",
      "rating": 8.6,
      "year": 2014,
      "duracion": "2h 49m",
      "generos": ["Ciencia Ficción", "Drama"],
      "trailer": "zSWdZVtXT7E"
    },
    {
      "titulo": "The Martian",
      "imagen": "https://m.media-amazon.com/images/I/71Swqqe7e8L._AC_SL1181_.jpg",
      "descripcion": "Un astronauta lucha por sobrevivir solo en Marte y encontrar una forma de volver a casa.",
      "rating": 8.0,
      "year": 2015,
      "duracion": "2h 24m",
      "generos": ["Ciencia Ficción", "Aventura"],
      "trailer": "ej3ioOneTy8"
    }
  ],
  "Comedia": [
    {
      "titulo": "Superbad",
      "imagen": "https://m.media-amazon.com/images/I/51c6S4kGFmL._AC_.jpg",
      "descripcion": "Dos amigos intentan conseguir alcohol para una fiesta y tienen una noche inolvidable.",
      "rating": 7.6,
      "year": 2007,
      "duracion": "1h 53m",
      "generos": ["Comedia"],
      "trailer": "4eaZ_48ZYog"
    },
    {
      "titulo": "The Hangover",
      "imagen": "https://m.media-amazon.com/images/I/71Tw3Q6pz0L._AC_SL1200_.jpg",
      "descripcion": "Después de una despedida de soltero, un grupo de amigos debe encontrar al novio desaparecido.",
      "rating": 7.7,
      "year": 2009,
      "duracion": "1h 40m",
      "generos": ["Comedia"],
      "trailer": "vhFVZsk3XEs"
    }
  ]
  };

  @override
  void initState() {
    super.initState();
    _peliculasFiltradas = _convertirPeliculasALista();
    _searchController.addListener(_filtrarPeliculas);
  }

  List<Map<String, dynamic>> _convertirPeliculasALista() {
    List<Map<String, dynamic>> listaPeliculas = [];
    peliculasData.forEach((categoria, peliculas) {
      listaPeliculas.addAll((peliculas as List).cast<Map<String, dynamic>>());
    });
    return listaPeliculas;
  }

  void _filtrarPeliculas() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _peliculasFiltradas = _convertirPeliculasALista();
      } else {
        _peliculasFiltradas = _convertirPeliculasALista().where((pelicula) {
          return pelicula['titulo'].toString().toLowerCase().contains(query) ||
              (pelicula['generos'] as List)
                  .any((genero) => genero.toString().toLowerCase().contains(query)) ||
              pelicula['descripcion'].toString().toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _mostrarDetallesPelicula(BuildContext context, Map<String, dynamic> pelicula) {
    showDialog(
      context: context,
      builder: (context) => _MovieDetailsModal(pelicula: pelicula),
      barrierColor: Colors.black87,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Buscar películas...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
          ),
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.amber,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF121212), Color(0xFF1E1E1E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _peliculasFiltradas.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search_off, size: 50, color: Colors.white54),
                    const SizedBox(height: 16),
                    Text(
                      _searchController.text.isEmpty
                          ? 'Busca tus películas favoritas'
                          : 'No se encontraron resultados',
                      style: const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: _peliculasFiltradas.length,
                itemBuilder: (context, index) {
                  final pelicula = _peliculasFiltradas[index];
                  return _PeliculaSearchItem(
                    pelicula: pelicula,
                    onTap: () => _mostrarDetallesPelicula(context, pelicula),
                  );
                },
              ),
      ),
    );
  }
}

class _PeliculaSearchItem extends StatelessWidget {
  final Map<String, dynamic> pelicula;
  final VoidCallback onTap;

  const _PeliculaSearchItem({
    required this.pelicula,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              child: Image.network(
                pelicula['imagen'],
                width: 80,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 120,
                  color: Colors.grey[800],
                  child: const Icon(Icons.broken_image, color: Colors.white54),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pelicula['titulo'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        pelicula['rating'].toString(),
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        pelicula['year'].toString(),
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    children: (pelicula['generos'] as List<dynamic>)
                        .take(2)
                        .map((genero) => Chip(
                              label: Text(
                                genero.toString(),
                                style: const TextStyle(fontSize: 12),
                              ),
                              backgroundColor: Colors.grey[800],
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.chevron_right, color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }
}

class _MovieDetailsModal extends StatefulWidget {
  final Map<String, dynamic> pelicula;

  const _MovieDetailsModal({required this.pelicula});

  @override
  State<_MovieDetailsModal> createState() => _MovieDetailsModalState();
}

class _MovieDetailsModalState extends State<_MovieDetailsModal> {
  late YoutubePlayerController _controller;
  bool _showTrailer = false;
  bool _isPlayerReady = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.pelicula['trailer'] ?? 'dQw4w9WgXcQ',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        disableDragSeek: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Aquí puedes mantener tu diseño de modal existente si ya lo tienes
    return AlertDialog(
      backgroundColor: Colors.black,
      title: Text(widget.pelicula['titulo'], style: const TextStyle(color: Colors.white)),
      content: Text(widget.pelicula['descripcion'], style: const TextStyle(color: Colors.white70)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cerrar', style: TextStyle(color: Colors.amber)),
        ),
      ],
    );
  }
}
