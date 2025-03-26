import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/models/actor.dart';
import 'package:movies/api/api_service.dart';
import '../models/movie.dart';
import 'movies_details_screen.dart';
import '../controllers/actors_controller.dart';

class ActorDetailScreen extends StatelessWidget {
  final Actor actor;

  const ActorDetailScreen({super.key, required this.actor});

  @override
  Widget build(BuildContext context) {
    final actorsController = Get.find<ActorsController>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          actor.name, 
          style: const TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xFF242A32),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Obx(() => Icon(
              actorsController.isInActorsList(actor)
                ? Icons.favorite
                : Icons.favorite_border,
              color: Colors.red,
            )),
            onPressed: () {
              actorsController.addToActorsList(actor);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (actor.profilePath != null)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w500${actor.profilePath}',
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                actor.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              if (actor.popularity != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        'Popularity: ${actor.popularity!.toStringAsFixed(1)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              if (actor.biography != null && actor.biography!.isNotEmpty)
                Text(
                  actor.biography!,
                  style: const TextStyle(fontSize: 16),
                ),
              const SizedBox(height: 24),
              const Text(
                'Known For',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 12),
              FutureBuilder<List<Movie>>(
                future: ApiService.getMoviesByActor(actor.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No movies available');
                  } else {
                    List<Movie> movies = snapshot.data!;
                    return SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                Get.to(MoviesDetailsScreen(
                                  movie: movies[index],
                                ));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: movies[index].posterPath.isNotEmpty
                                    ? Image.network(
                                        'https://image.tmdb.org/t/p/w185${movies[index].posterPath}',
                                        width: 120,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        width: 120,
                                        color: Colors.grey[800],
                                        child: const Center(
                                          child: Icon(Icons.movie, size: 50),
                                        ),
                                      ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}