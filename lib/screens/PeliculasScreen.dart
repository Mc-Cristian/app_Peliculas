import 'package:app_peliculas/navigation/Drawer.dart';
import 'package:app_peliculas/screens/DetallePeliculaScreen.dart';
import 'package:flutter/material.dart';

class PeliculasScreen extends StatelessWidget {
  final List<Map<String, dynamic>> peliculas = [
    {
      'titulo': 'Avatar',
      'imagen': 'https://m.media-amazon.com/images/M/MV5BZDA0OGQxNTItMDZkMC00N2UyLTg3MzMtYTJmNjg3Nzk5MzRiXkEyXkFqcGdeQXVyMjUzOTY1NTc@._V1_.jpg',
      'descripcion': 'Un marine parapléjico es enviado a la luna Pandora en una misión única, pero se enfrenta a un dilema cuando se enamora de una princesa Na\'vi.'
    },
    {
      'titulo': 'Deadpool',
      'imagen': 'https://m.media-amazon.com/images/M/MV5BYzE5MjY1ZDgtMTkyNC00MTMyLThhMjAtZGI5OTE1NzFlZGJjXkEyXkFqcGdeQXVyNjU0OTQ0OTY@._V1_.jpg',
      'descripcion': 'Un ex-operativo de las fuerzas especiales se somete a un experimento que le deja con poderes de curación acelerada y adopta el alter ego Deadpool.'
    },
    {
      'titulo': 'Logan',
      'imagen': 'https://m.media-amazon.com/images/M/MV5BYzc5MTU4N2EtYTkyMi00NjdhLTg3NWEtMTY4OTEyMzJhZTAzXkEyXkFqcGdeQXVyNjc1NTYyMjg@._V1_.jpg',
      'descripcion': 'En un futuro cercano, un envejecido Logan cuida de un enfermo Profesor X en un escondite en la frontera mexicana.'
    },
    {
      'titulo': 'Alien: Covenant',
      'imagen': 'https://m.media-amazon.com/images/M/MV5BYzVkMjRhNzctOGQxMC00OGE2LWJhN2EtNmYyODRiMDNlM2ZmXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_.jpg',
      'descripcion': 'La tripulación de la nave colonizadora Covenant descubre lo que creen que es un paraíso inexplorado, pero en realidad es un mundo oscuro y peligroso.'
    },
    {
      'titulo': 'The Martian',
      'imagen': 'https://m.media-amazon.com/images/M/MV5BMTc2MTQ3MDA1Nl5BMl5BanBnXkFtZTgwODA3OTI4NjE@._V1_.jpg',
      'descripcion': 'Un astronauta es dejado por muerto en Marte por su tripulación, pero él sobrevive y debe encontrar la manera de comunicar que todavía está vivo.'
    },
    {
      'titulo': 'Kingsman',
      'imagen': 'https://m.media-amazon.com/images/M/MV5BMTkxMjgwMDM4Ml5BMl5BanBnXkFtZTgwMTk3NTIwNDE@._V1_.jpg',
      'descripcion': 'Una organización de espías recluta a un chico de la calle poco convencional para un programa de entrenamiento ultra competitivo.'
    },
  ];

  PeliculasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MiDrawer(),
      appBar: AppBar(
        title: const Text(
          'Películas de Acción',
          style: TextStyle(color: Colors.white),
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
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: peliculas.map((pelicula) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetallePeliculaScreen(pelicula: pelicula),
                    ),
                  );
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 24, // Aproximadamente 2 columnas
                  child: Card(
                    color: Colors.black87,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.network(
                            pelicula['imagen'],
                            height: 180,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(Icons.error, color: Colors.red),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            pelicula['titulo'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
