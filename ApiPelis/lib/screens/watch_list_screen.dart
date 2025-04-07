// Update the watch_list_screen.dart file
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/api/api.dart';
import 'package:movies/controllers/bottom_navigator_controller.dart';
import 'package:movies/controllers/movies_controller.dart';
import 'package:movies/controllers/series_controller.dart'; // Add this import
import 'package:movies/models/actor.dart';
import 'package:movies/models/series.dart'; // Add this import
import 'package:movies/screens/movies_details_screen.dart';
import 'package:movies/screens/series_detail_screen.dart'; // Add this import
import 'package:movies/widgets/infos.dart';

class WatchList extends StatelessWidget {
  const WatchList({super.key});

  @override
  Widget build(BuildContext context) {
    final moviesController = Get.put(MoviesController());
    final seriesController = Get.put(SeriesController()); // Add this
    
    return Obx(() => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(34.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      tooltip: 'Back to home',
                      onPressed: () =>
                          Get.find<BottomNavigatorController>().setIndex(0),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Watch list',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(
                      width: 33,
                      height: 33,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Movies Section (existing)
                if (moviesController.watchListMovies.isNotEmpty) ...[
                  const Text(
                    'Movies',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...moviesController.watchListMovies.map(
                    (movie) => Column(
                      children: [
                        GestureDetector(
                          onTap: () => Get.to(MoviesDetailsScreen(movie: movie)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  Api.imageBaseUrl + movie.posterPath,
                                  height: 180,
                                  width: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.broken_image,
                                    size: 180,
                                  ),
                                  loadingBuilder: (_, __, ___) {
                                    if (___ == null) return __;
                                    return const FadeShimmer(
                                      width: 150,
                                      height: 150,
                                      highlightColor: Color(0xff22272f),
                                      baseColor: Color(0xff20252d),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 5),
                              Infos(movie: movie),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => moviesController.removeFromWatchList(movie),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
                // Series Section (new)
                if (seriesController.watchListSeries.isNotEmpty) ...[
                  const Text(
                    'Series',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...seriesController.watchListSeries.map(
                    (series) => Column(
                      children: [
                        GestureDetector(
                          onTap: () => Get.to(() => SeriesDetailScreen(series: series)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  Api.imageBaseUrl + series.posterPath,
                                  height: 180,
                                  width: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.broken_image,
                                    size: 180,
                                  ),
                                  loadingBuilder: (_, __, ___) {
                                    if (___ == null) return __;
                                    return const FadeShimmer(
                                      width: 150,
                                      height: 150,
                                      highlightColor: Color(0xff22272f),
                                      baseColor: Color(0xff20252d),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    series.title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Rating: ${series.voteAverage.toStringAsFixed(1)}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  if (series.numberOfSeasons > 0)
                                    Text(
                                      'Seasons: ${series.numberOfSeasons}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => seriesController.removeFromWatchList(series),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
                // Actors Section (existing)
                if (moviesController.watchListActors.isNotEmpty) ...[
                  const Text(
                    'Actors',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...moviesController.watchListActors.map(
                    (actor) => Column(
                      children: [
                        GestureDetector(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: actor.profilePath != null
                                    ? Image.network(
                                        Api.imageBaseUrl + actor.profilePath!,
                                        height: 180,
                                        width: 100,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => const Icon(
                                          Icons.broken_image,
                                          size: 180,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.person,
                                        size: 180,
                                        color: Colors.grey,
                                      ),
                              ),
                              const SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    actor.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (actor.popularity != null)
                                    Text(
                                      'Popularity: ${actor.popularity!.toStringAsFixed(1)}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => moviesController.removeActorFromWatchList(actor),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
                // Empty State (updated)
                if (moviesController.watchListMovies.isEmpty &&
                    seriesController.watchListSeries.isEmpty && // Add this condition
                    moviesController.watchListActors.isEmpty)
                  const Column(
                    children: [
                      SizedBox(height: 200),
                      Text(
                        'No items in your watch list',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ));
  }
}