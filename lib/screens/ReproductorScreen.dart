import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ReproductorScreen extends StatefulWidget {
  final String videoUrl;
  final Map<String, dynamic> pelicula;

  const ReproductorScreen({
    super.key,
    required this.videoUrl,
    required this.pelicula,
  });

  @override
  State<ReproductorScreen> createState() => _ReproductorScreenState();
}

class _ReproductorScreenState extends State<ReproductorScreen> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    
    // Extraer el ID del video de YouTube
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl) ?? 'dQw4w9WgXcQ';
    
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
        disableDragSeek: false,
        loop: false,
      ),
    )..addListener(_listener);
  }

  void _listener() {
    if (_isPlayerReady && !_controller.value.isFullScreen) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pelicula['titulo']),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.fullscreen),
            onPressed: () => _controller.toggleFullScreenMode(),
          ),
        ],
      ),
      body: Column(
        children: [
          YoutubePlayer(
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
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        widget.pelicula['rating'].toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      Text(
                        '${widget.pelicula['year']} • ${widget.pelicula['duracion']}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Sinopsis:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.pelicula['descripcion'],
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}