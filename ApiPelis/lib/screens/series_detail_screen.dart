// Create a new file series_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/api/api.dart';
import 'package:movies/controllers/series_controller.dart';
import 'package:movies/models/series.dart';

class SeriesDetailScreen extends StatelessWidget {
  final Series series;

  const SeriesDetailScreen({super.key, required this.series});

  @override
  Widget build(BuildContext context) {
    final seriesController = Get.find<SeriesController>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                '${Api.imageBaseUrl}${series.backdropPath}',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Center(
                  child: Icon(Icons.broken_image, size: 100),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          series.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          seriesController.isInWatchList(series)
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: Colors.yellow,
                          size: 30,
                        ),
                        onPressed: () {
                          seriesController.addToWatchList(series);
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.yellow),
                      const SizedBox(width: 4),
                      Text(series.voteAverage.toStringAsFixed(1)),
                      const SizedBox(width: 16),
                      Text(series.firstAirDate),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (series.numberOfSeasons > 0)
                    Text(
                      'Seasons: ${series.numberOfSeasons} | Episodes: ${series.numberOfEpisodes}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  const SizedBox(height: 16),
                  const Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(series.overview),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}