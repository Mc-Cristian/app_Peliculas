import 'package:flutter/material.dart';
import 'package:app_peliculas/navigation/Drawer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetallePeliculaScreen extends StatefulWidget {
  final Map<String, dynamic> pelicula;

  const DetallePeliculaScreen({super.key, required this.pelicula});

  @override
  State<DetallePeliculaScreen> createState() => _DetallePeliculaScreenState();
}

class _DetallePeliculaScreenState extends State<DetallePeliculaScreen> {
  YoutubePlayerController? _controller;
  bool _showTrailer = false;
  bool _isPlayerReady = false;
  bool _controllerInitialized = false;

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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Precache la imagen del video
    precacheImage(NetworkImage('https://img.youtube.com/vi/$videoId/0.jpg'), context);
  }

  void _initYoutubeController() {
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: false,
        disableDragSeek: false,
        loop: false,
      ),
    )..addListener(_listener);
    _controllerInitialized = true;
  }

  void _listener() {
    if (_controller != null && _isPlayerReady && !_controller!.value.isFullScreen) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_listener);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MiDrawer(),
      appBar: AppBar(
        title: Text(
          widget.pelicula['titulo'],
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF101010),
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF121212), Color(0xFF2E2E2E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!_showTrailer)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.pelicula['imagen'],
                      height: 300,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 300,
                          color: Colors.grey[800],
                          child: const Center(
                            child: Icon(Icons.error, color: Colors.red, size: 50),
                          ),
                        );
                      },
                    ),
                  ),
                if (_showTrailer && _controller != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: YoutubePlayer(
                        controller: _controller!,
                        aspectRatio: 16 / 9,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.blueAccent,
                        progressColors: const ProgressBarColors(
                          playedColor: Colors.blue,
                          handleColor: Colors.blueAccent,
                        ),
                        onReady: () {
                          _isPlayerReady = true;
                          _controller!.play();
                        },
                        onEnded: (data) {
                          _controller!.seekTo(Duration.zero);
                        },
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                Text(
                  widget.pelicula['titulo'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  widget.pelicula['descripcion'],
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // Acción para ver la película (puedes abrir otro screen o usar un video local)
                      },
                      icon: const Icon(Icons.play_arrow, color: Colors.white),
                      label: const Text(
                        'Ver Película',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1C1C1C),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _showTrailer = !_showTrailer;
                          if (_showTrailer && !_controllerInitialized) {
                            _initYoutubeController();
                          } else if (_showTrailer && _isPlayerReady) {
                            _controller?.play();
                          }
                        });
                      },
                      icon: Icon(
                        _showTrailer ? Icons.image : Icons.video_library,
                        color: Colors.white,
                      ),
                      label: Text(
                        _showTrailer ? 'Ocultar' : 'Tráiler',
                        style: const TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1C1C1C),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
