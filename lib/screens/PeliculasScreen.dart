import 'package:flutter/material.dart';
import 'package:app_peliculas/navigation/Drawer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:convert';

class PeliculasScreen extends StatefulWidget {
  const PeliculasScreen({super.key});

  @override
  State<PeliculasScreen> createState() => _PeliculasScreenState();
}

class _PeliculasScreenState extends State<PeliculasScreen> {
  late Map<String, dynamic> _peliculasData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPeliculasData();
  }

  Future<void> _loadPeliculasData() async {
    final jsonString = '''
    {
      "Películas Populares": [
        {
          "titulo": "Avatar",
          "imagen": "https://m.media-amazon.com/images/M/MV5BZDA0OGQxNTItMDZkMC00N2UyLTg3MzMtYTJmNjg3Nzk5MzRiXkEyXkFqcGdeQXVyMjUzOTY1NTc@._V1_.jpg",
          "descripcion": "Un marine parapléjico es enviado a la luna Pandora en una misión única, pero se enfrenta a un dilema cuando se enamora de una princesa Na'vi.",
          "rating": 4.8,
          "year": 2009,
          "generos": ["Acción", "Aventura", "Ciencia ficción"],
          "duracion": "2h 42m",
          "trailer": "d9MyW72ELq0"
        },
        {
          "titulo": "Deadpool",
          "imagen": "https://m.media-amazon.com/images/M/MV5BYzE5MjY1ZDgtMTkyNC00MTMyLThhMjAtZGI5OTE1NzFlZGJjXkEyXkFqcGdeQXVyNjU0OTQ0OTY@._V1_.jpg",
          "descripcion": "Un ex-operativo de las fuerzas especiales se somete a un experimento que le deja con poderes de curación acelerada y adopta el alter ego Deadpool.",
          "rating": 4.5,
          "year": 2016,
          "generos": ["Acción", "Comedia", "Superhéroes"],
          "duracion": "1h 48m",
          "trailer": "ONHBaC-pfsk"
        },
        {
          "titulo": "Logan",
          "imagen": "https://m.media-amazon.com/images/M/MV5BYzc5MTU4N2EtYTkyMi00NjdhLTg3NWEtMTY4OTEyMzJhZTAzXkEyXkFqcGdeQXVyNjc1NTYyMjg@._V1_.jpg",
          "descripcion": "En un futuro cercano, un envejecido Logan cuida de un enfermo Profesor X en un escondite en la frontera mexicana.",
          "rating": 4.7,
          "year": 2017,
          "generos": ["Acción", "Drama", "Superhéroes"],
          "duracion": "2h 17m",
          "trailer": "Div0iP65aZo"
        }
      ],
      "Ciencia Ficción y Terror": [
        {
          "titulo": "Alien: Covenant",
          "imagen": "https://m.media-amazon.com/images/M/MV5BYzVkMjRhNzctOGQxMC00OGE2LWJhN2EtNmYyODRiMDNlM2ZmXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_.jpg",
          "descripcion": "La tripulación de la nave colonizadora Covenant descubre lo que creen que es un paraíso inexplorado, pero en realidad es un mundo oscuro y peligroso.",
          "rating": 3.9,
          "year": 2017,
          "generos": ["Terror", "Ciencia ficción", "Thriller"],
          "duracion": "2h 2m",
          "trailer": "svnAD0TApb8"
        },
        {
          "titulo": "The Martian",
          "imagen": "https://m.media-amazon.com/images/M/MV5BMTc2MTQ3MDA1Nl5BMl5BanBnXkFtZTgwODA3OTI4NjE@._V1_.jpg",
          "descripcion": "Un astronauta es dejado por muerto en Marte por su tripulación, pero él sobrevive y debe encontrar la manera de comunicar que todavía está vivo.",
          "rating": 4.3,
          "year": 2015,
          "generos": ["Aventura", "Drama", "Ciencia ficción"],
          "duracion": "2h 24m",
          "trailer": "ej3ioOneTy8"
        }
      ],
      "Acción y Aventura": [
        {
          "titulo": "Kingsman",
          "imagen": "https://m.media-amazon.com/images/M/MV5BMTkxMjgwMDM4Ml5BMl5BanBnXkFtZTgwMTk3NTIwNDE@._V1_.jpg",
          "descripcion": "Una organización de espías recluta a un chico de la calle poco convencional para un programa de entrenamiento ultra competitivo.",
          "rating": 4.2,
          "year": 2014,
          "generos": ["Acción", "Aventura", "Comedia"],
          "duracion": "2h 9m",
          "trailer": "kl8F-8tR8to"
        }
      ],
      "Clásicos del Cine": [
        {
          "titulo": "Forrest Gump",
          "imagen": "https://m.media-amazon.com/images/M/MV5BNWIwODAxNTktNjRlOS00ZjQ4LTg0ZjAtYjM1ZjFmZjA2N2VjXkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_.jpg",
          "descripcion": "La historia de un hombre con un coeficiente intelectual bajo que, sin embargo, vive una vida extraordinaria.",
          "rating": 4.9,
          "year": 1994,
          "generos": ["Drama", "Romance"],
          "duracion": "2h 22m",
          "trailer": "bLvqoHBptjg"
        },
        {
          "titulo": "El Padrino",
          "imagen": "https://m.media-amazon.com/images/I/41+eK8zBwQL._AC_.jpg",
          "descripcion": "La crónica de la familia Corleone, una poderosa dinastía mafiosa en Nueva York.",
          "rating": 4.9,
          "year": 1972,
          "generos": ["Crimen", "Drama"],
          "duracion": "2h 55m",
          "trailer": "sY1S34973zA"
        }
      ],
      "Comedias para Reír": [
        {
          "titulo": "The Hangover",
          "imagen": "https://m.media-amazon.com/images/M/MV5BMTQ1NjcwODc4MV5BMl5BanBnXkFtZTcwMjQyNjcyMw@@._V1_.jpg",
          "descripcion": "Un grupo de amigos pierde al novio durante una despedida de soltero en Las Vegas y debe reconstruir lo sucedido.",
          "rating": 4.1,
          "year": 2009,
          "generos": ["Comedia"],
          "duracion": "1h 40m",
          "trailer": "vhFVZsk3XaI"
        },
        {
          "titulo": "Superbad",
          "imagen": "https://m.media-amazon.com/images/M/MV5BMTY1NTY4MzIxN15BMl5BanBnXkFtZTcwNzg1MTQzMw@@._V1_.jpg",
          "descripcion": "Dos amigos de secundaria buscan disfrutar su último año antes de la universidad.",
          "rating": 4.0,
          "year": 2007,
          "generos": ["Comedia", "Coming-of-age"],
          "duracion": "1h 53m",
          "trailer": "4eaZ_48ZYog"
        }
      ],
      "Thrillers y Suspenso": [
        {
          "titulo": "Gone Girl",
          "imagen": "https://m.media-amazon.com/images/M/MV5BN2Y4YmZmNGEtYzVlOS00NmM1LTg2YzAtYmU3NjRhMGMxNjljXkEyXkFqcGdeQXVyNjU0OTQ0OTY@._V1_.jpg",
          "descripcion": "La desaparición de una mujer desencadena una intensa investigación y secretos ocultos.",
          "rating": 4.3,
          "year": 2014,
          "generos": ["Thriller", "Drama", "Misterio"],
          "duracion": "2h 29m",
          "trailer": "2-_-1nJf8Vg"
        },
        {
          "titulo": "Shutter Island",
          "imagen": "https://m.media-amazon.com/images/M/MV5BMTUxMjUyOTM2Ml5BMl5BanBnXkFtZTcwNTI3NjYzMw@@._V1_.jpg",
          "descripcion": "Un agente federal investiga la desaparición de una paciente en un hospital psiquiátrico aislado.",
          "rating": 4.4,
          "year": 2010,
          "generos": ["Thriller", "Misterio", "Drama"],
          "duracion": "2h 18m",
          "trailer": "5iaYLCiq5RM"
        }
      ],
      "Animación para Toda la Familia": [
        {
          "titulo": "Coco",
          "imagen": "https://m.media-amazon.com/images/M/MV5BMTQ5NzI4NTM3OF5BMl5BanBnXkFtZTgwNzg5MDcyOTE@._V1_.jpg",
          "descripcion": "Un joven aspirante a músico viaja al mundo de los muertos para descubrir el legado de su familia.",
          "rating": 4.7,
          "year": 2017,
          "generos": ["Animación", "Aventura", "Familiar"],
          "duracion": "1h 45m",
          "trailer": "Ga6RYejo6Hk"
        },
        {
          "titulo": "Toy Story",
          "imagen": "https://m.media-amazon.com/images/M/MV5BMTk0NTU0NDUzMV5BMl5BanBnXkFtZTgwNjM1OTY0MTE@._V1_.jpg",
          "descripcion": "Las aventuras de juguetes que cobran vida cuando no hay humanos presentes.",
          "rating": 4.8,
          "year": 1995,
          "generos": ["Animación", "Comedia", "Familiar"],
          "duracion": "1h 21m",
          "trailer": "KYz2wyBy3kc"
        }
      ]
    }
    ''';

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _peliculasData = json.decode(jsonString);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MiDrawer(),
      appBar: AppBar(
        title: const Text(
          'CATÁLOGO DE PELÍCULAS',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF121212), Color(0xFF2A2A2A)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Acción de búsqueda
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF121212), Color(0xFF1E1E1E)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: _peliculasData.length,
                itemBuilder: (context, categoryIndex) {
                  final category = _peliculasData.keys.elementAt(categoryIndex);
                  final peliculas = _peliculasData[category] as List<dynamic>;
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                        child: Text(
                          category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 220,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemCount: peliculas.length,
                          itemBuilder: (context, index) {
                            final pelicula = peliculas[index];
                            return Container(
                              width: 140,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              child: _MovieCard(pelicula: pelicula),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
    );
  }
}

class _MovieCard extends StatelessWidget {
  final Map<String, dynamic> pelicula;

  const _MovieCard({required this.pelicula});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => _MovieDetailsModal(pelicula: pelicula),
          barrierColor: Colors.black87,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                pelicula['imagen'],
                fit: BoxFit.cover,
                width: double.infinity,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[900],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[800],
                    child: const Center(
                      child: Icon(Icons.broken_image, 
                        color: Colors.white54, 
                        size: 40),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            pelicula['titulo'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            children: [
              const Icon(Icons.star, 
                color: Colors.amber, 
                size: 14),
              const SizedBox(width: 4),
              Text(
                pelicula['rating'].toString(),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: size.height * 0.85,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                blurRadius: 25,
                spreadRadius: 5,
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    if (!_showTrailer)
                      Hero(
                        tag: 'poster-${widget.pelicula['titulo']}',
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16)),
                          child: Image.network(
                            widget.pelicula['imagen'],
                            height: 220,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    if (_showTrailer)
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16)),
                        child: Container(
                          height: 220,
                          color: Colors.black,
                          child: YoutubePlayer(
                            controller: _controller,
                            aspectRatio: 16 / 9,
                            showVideoProgressIndicator: true,
                            progressIndicatorColor: Colors.amber,
                            progressColors: const ProgressBarColors(
                              playedColor: Colors.amber,
                              handleColor: Colors.amberAccent,
                            ),
                            onReady: () {
                              setState(() {
                                _isPlayerReady = true;
                              });
                            },
                          ),
                        ),
                      ),
                    
                    Positioned(
                      top: 10,
                      right: 10,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: const Icon(Icons.close, 
                            color: Colors.white, 
                            size: 20),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ),
                    
                    Positioned(
                      top: 10,
                      left: 10,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: Icon(
                            _isFavorite 
                              ? Icons.favorite 
                              : Icons.favorite_border,
                            color: _isFavorite ? Colors.red : Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _isFavorite = !_isFavorite;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.pelicula['titulo'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Chip(
                            backgroundColor: Colors.amber.withOpacity(0.2),
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star, 
                                  color: Colors.amber, 
                                  size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  widget.pelicula['rating'].toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Text(
                              widget.pelicula['year'].toString(),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 15),
                            const Icon(Icons.timer_outlined, 
                              color: Colors.white70, 
                              size: 16),
                            const SizedBox(width: 4),
                            Text(
                              widget.pelicula['duracion'],
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: (widget.pelicula['generos'] as List<dynamic>)
                            .map((genero) => Chip(
                                  label: Text(genero.toString(),
                                      style: const TextStyle(
                                          color: Colors.white70)),
                                  backgroundColor: Colors.grey[800],
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ))
                            .toList(),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      const Text(
                        'Sinopsis:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.pelicula['descripcion'],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 20),
                      
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // Acción para ver la película
                              },
                              icon: const Icon(Icons.play_arrow, size: 20),
                              label: const Text('Ver ahora'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber[700],
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _showTrailer = !_showTrailer;
                                  if (_showTrailer && _isPlayerReady) {
                                    _controller.play();
                                  }
                                });
                              },
                              icon: Icon(
                                _showTrailer ? Icons.image : Icons.video_library,
                                size: 20,
                              ),
                              label: Text(_showTrailer ? 'Póster' : 'Tráiler'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2A2A2A),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(
                                    color: Colors.grey, 
                                    width: 0.5),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}