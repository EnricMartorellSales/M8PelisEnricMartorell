// Create a new file series_item.dart
import 'package:flutter/material.dart';
import 'package:movies/models/series.dart';

class SeriesItem extends StatelessWidget {
  final Series series;
  final VoidCallback onAddToWatchList;
  final bool isInWatchList;

  const SeriesItem({
    super.key,
    required this.series,
    required this.onAddToWatchList,
    required this.isInWatchList,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500${series.posterPath}',
                  height: 200,
                  width: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.broken_image,
                    size: 200,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(
                    isInWatchList ? Icons.bookmark : Icons.bookmark_border,
                    color: Colors.yellow,
                    size: 30,
                  ),
                  onPressed: onAddToWatchList,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            series.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Colors.yellow, size: 16),
              const SizedBox(width: 4),
              Text(series.voteAverage.toStringAsFixed(1)),
            ],
          ),
        ],
      ),
    );
  }
}