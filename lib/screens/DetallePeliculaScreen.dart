import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetallePeliculaModal extends StatefulWidget {
  final Map<String, dynamic> pelicula;

  const DetallePeliculaModal({super.key, required this.pelicula});

  @override
  State<DetallePeliculaModal> createState() => _DetallePeliculaModalState();
}

class _DetallePeliculaModalState extends State<DetallePeliculaModal> {
  late YoutubePlayerController _controller;
  bool _showTrailer = false;
  bool _isPlayerReady = false;
  bool _isFavorite = false;

  late String videoId;

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
    videoId = trailerIds[widget.pelicula['titulo']] ?? 'dQw4w9WgXcQ';
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: false,
        disableDragSeek: false,
        loop: false,
      ),
    );
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        width: size.width * 0.9,
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 2,
            )
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header con imagen/trailer
              Stack(
                children: [
                  if (!_showTrailer)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16)),
                      child: Image.network(
                        widget.pelicula['imagen'],
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 220,
                            color: Colors.grey[900],
                            child: const Center(
                              child: Icon(Icons.error, color: Colors.red),
                            ),
                          );
                        },
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
                          aspectRatio: 16/9,
                          showVideoProgressIndicator: true,
                          progressIndicatorColor: Colors.blueAccent,
                          progressColors: const ProgressBarColors(
                            playedColor: Colors.blue,
                            handleColor: Colors.blueAccent,
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
                        icon: const Icon(Icons.close, color: Colors.white),
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
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorite ? Colors.red : Colors.white,
                        ),
                        onPressed: _toggleFavorite,
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
                              const Icon(Icons.star, color: Colors.amber, size: 18),
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
                          const Icon(Icons.timer_outlined, color: Colors.white70, size: 16),
                          const SizedBox(width: 4),
                          const Text(
                            '2h 30m',
                            style: TextStyle(
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
                      children: const [
                        Chip(
                          label: Text('Acción', style: TextStyle(color: Colors.white70))),
                        Chip(
                          label: Text('Aventura', style: TextStyle(color: Colors.white70))),
                        Chip(
                          label: Text('Ciencia ficción', style: TextStyle(color: Colors.white70))),
                      ],
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
                        fontSize: 15,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20),

                    // Botones principales
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Botón Ver Película
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.play_arrow, size: 20),
                            label: const Text('Ver Película'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2A2A2A),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(color: Colors.grey, width: 0.5),
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
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(color: Colors.grey, width: 0.5),
                              ),
                            ),
                          ),
                    ))],
                      ),
                    
                    // Botones secundarios
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.share, color: Colors.white70),
                          label: const Text('Compartir', style: TextStyle(color: Colors.white70)),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.info_outline, color: Colors.white70),
                          label: const Text('Más info', style: TextStyle(color: Colors.white70)),
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
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}