import 'package:flutter/material.dart';
import 'package:app_peliculas/navigation/Drawer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PeliculasScreen extends StatelessWidget {
  final List<Map<String, dynamic>> peliculas = [
    {
      'titulo': 'Avatar',
      'imagen': 'https://m.media-amazon.com/images/M/MV5BZDA0OGQxNTItMDZkMC00N2UyLTg3MzMtYTJmNjg3Nzk5MzRiXkEyXkFqcGdeQXVyMjUzOTY1NTc@._V1_.jpg',
      'descripcion': 'Un marine parapléjico es enviado a la luna Pandora en una misión única, pero se enfrenta a un dilema cuando se enamora de una princesa Na\'vi.',
      'rating': 4.8,
      'year': 2009,
      'generos': ['Acción', 'Aventura', 'Ciencia ficción'],
      'duracion': '2h 42m'
    },
    {
      'titulo': 'Deadpool',
      'imagen': 'https://m.media-amazon.com/images/M/MV5BYzE5MjY1ZDgtMTkyNC00MTMyLThhMjAtZGI5OTE1NzFlZGJjXkEyXkFqcGdeQXVyNjU0OTQ0OTY@._V1_.jpg',
      'descripcion': 'Un ex-operativo de las fuerzas especiales se somete a un experimento que le deja con poderes de curación acelerada y adopta el alter ego Deadpool.',
      'rating': 4.5,
      'year': 2016,
      'generos': ['Acción', 'Comedia', 'Superhéroes'],
      'duracion': '1h 48m'
    },
    {
      'titulo': 'Logan',
      'imagen': 'https://m.media-amazon.com/images/M/MV5BYzc5MTU4N2EtYTkyMi00NjdhLTg3NWEtMTY4OTEyMzJhZTAzXkEyXkFqcGdeQXVyNjc1NTYyMjg@._V1_.jpg',
      'descripcion': 'En un futuro cercano, un envejecido Logan cuida de un enfermo Profesor X en un escondite en la frontera mexicana.',
      'rating': 4.7,
      'year': 2017,
      'generos': ['Acción', 'Drama', 'Superhéroes'],
      'duracion': '2h 17m'
    },
    {
      'titulo': 'Alien: Covenant',
      'imagen': 'https://m.media-amazon.com/images/M/MV5BYzVkMjRhNzctOGQxMC00OGE2LWJhN2EtNmYyODRiMDNlM2ZmXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_.jpg',
      'descripcion': 'La tripulación de la nave colonizadora Covenant descubre lo que creen que es un paraíso inexplorado, pero en realidad es un mundo oscuro y peligroso.',
      'rating': 3.9,
      'year': 2017,
      'generos': ['Terror', 'Ciencia ficción', 'Thriller'],
      'duracion': '2h 2m'
    },
    {
      'titulo': 'The Martian',
      'imagen': 'https://m.media-amazon.com/images/M/MV5BMTc2MTQ3MDA1Nl5BMl5BanBnXkFtZTgwODA3OTI4NjE@._V1_.jpg',
      'descripcion': 'Un astronauta es dejado por muerto en Marte por su tripulación, pero él sobrevive y debe encontrar la manera de comunicar que todavía está vivo.',
      'rating': 4.3,
      'year': 2015,
      'generos': ['Aventura', 'Drama', 'Ciencia ficción'],
      'duracion': '2h 24m'
    },
    {
      'titulo': 'Kingsman',
      'imagen': 'https://m.media-amazon.com/images/M/MV5BMTkxMjgwMDM4Ml5BMl5BanBnXkFtZTgwMTk3NTIwNDE@._V1_.jpg',
      'descripcion': 'Una organización de espías recluta a un chico de la calle poco convencional para un programa de entrenamiento ultra competitivo.',
      'rating': 4.2,
      'year': 2014,
      'generos': ['Acción', 'Aventura', 'Comedia'],
      'duracion': '2h 9m'
    },
  ];

  PeliculasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MiDrawer(),
      appBar: AppBar(
        title: const Text(
          'PELÍCULAS DE ACCIÓN',
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF121212), Color(0xFF1E1E1E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.65,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final pelicula = peliculas[index];
                    return _MovieCard(pelicula: pelicula);
                  },
                  childCount: peliculas.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 20),
            ),
          ],
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
      child: Hero(
        tag: 'poster-${pelicula['titulo']}',
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Poster de la película
                Image.network(
                  pelicula['imagen'],
                  fit: BoxFit.cover,
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
                
                // Gradiente para mejor legibilidad
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
                
                // Badge de rating
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber[700],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, 
                          color: Colors.white, 
                          size: 14),
                        const SizedBox(width: 4),
                        Text(
                          pelicula['rating'].toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Información de la película
                Positioned(
                  left: 10,
                  right: 10,
                  bottom: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        pelicula['titulo'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                        )],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        pelicula['year'].toString(),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13,
                          shadows: const [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                        )],
                        ),
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
    final trailerIds = {
      'Avatar': 'd9MyW72ELq0',
      'Deadpool': 'ONHBaC-pfsk',
      'Logan': 'Div0iP65aZo',
      'Alien: Covenant': 'svnAD0TApb8',
      'The Martian': 'ej3ioOneTy8',
      'Kingsman': 'kl8F-8tR8to',
    };
    final videoId = trailerIds[widget.pelicula['titulo']] ?? 'dQw4w9WgXcQ';
    
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
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
                // Encabezado con imagen/trailer
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
                    
                    // Botón de cerrar
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
                    
                    // Botón de favoritos
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
                
                // Contenido
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título y rating
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
                      
                      // Año y duración
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
                      
                      // Géneros
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: (widget.pelicula['generos'] as List<String>)
                            .map((genero) => Chip(
                                  label: Text(genero,
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
                      
                      // Descripción
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
                      
                      // Botones principales
                      Row(
                        children: [
                          // Botón Ver Película
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
                          
                          // Botón Tráiler
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