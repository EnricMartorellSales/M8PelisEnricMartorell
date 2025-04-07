import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/api/api.dart';
import 'package:movies/api/api_service.dart';
import 'package:movies/controllers/actors_controller.dart';
import 'package:movies/controllers/series_controller.dart';
import 'package:movies/models/actor.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/models/series.dart';
import 'package:movies/screens/actor_detail_screen.dart';
import 'package:movies/screens/movies_details_screen.dart';
import 'package:movies/screens/series_detail_screen.dart';
import 'package:movies/widgets/infos.dart';
import 'package:movies/widgets/series_item.dart';
import 'package:movies/widgets/top_rated_actor_item.dart';

enum ContentType { movies, series, actors }

class MoreContentScreen extends StatelessWidget {
  final String title;
  final ContentType contentType;

  const MoreContentScreen({
    super.key,
    required this.title,
    required this.contentType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder(
        future: _getContent(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          switch (contentType) {
            case ContentType.actors:
              return _buildActorsList(snapshot.data as List<Actor>);
            case ContentType.series:
              return _buildSeriesList(snapshot.data as List<Series>);
            case ContentType.movies:
              return _buildMoviesList(snapshot.data as List<Movie>);
          }
        },
      ),
    );
  }

  Future<List<dynamic>?> _getContent() async {
    switch (contentType) {
      case ContentType.movies:
        return await ApiService.getPopularMovies();
      case ContentType.series:
        return await ApiService.getPopularTvShows();
      case ContentType.actors:
        return await ApiService.getPopularActors();
    }
  }

  Widget _buildActorsList(List<Actor> actors) {
    return ListView.builder(
      itemCount: actors.length,
      itemBuilder: (context, index) {
        final actor = actors[index];
        return ListTile(
          leading: actor.profilePath != null
              ? Image.network(
                  Api.imageBaseUrl + actor.profilePath!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
              : const Icon(Icons.person, size: 50),
          title: Text(actor.name),
          subtitle: Text('Popularity: ${actor.popularity?.toStringAsFixed(1) ?? 'N/A'}'),
          onTap: () => Get.to(() => ActorDetailScreen(actor: actor)),
        );
      },
    );
  }

  Widget _buildSeriesList(List<Series> series) {
    return ListView.builder(
      itemCount: series.length,
      itemBuilder: (context, index) {
        final serie = series[index];
        return ListTile(
          leading: Image.network(
            Api.imageBaseUrl + serie.posterPath,
            width: 50,
            height: 75,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.tv, size: 50),
          ),
          title: Text(serie.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Rating: ${serie.voteAverage.toStringAsFixed(1)}'),
              if (serie.firstAirDate.isNotEmpty)
                Text('First aired: ${serie.firstAirDate.split('-')[0]}'),
            ],
          ),
          trailing: IconButton(
            icon: Icon(
              Get.find<SeriesController>().isInWatchList(serie)
                  ? Icons.bookmark
                  : Icons.bookmark_border,
              color: Colors.amber,
            ),
            onPressed: () {
              Get.find<SeriesController>().addToWatchList(serie);
            },
          ),
          onTap: () => Get.to(() => SeriesDetailScreen(series: serie)),
        );
      },
    );
  }

  Widget _buildMoviesList(List<Movie> movies) {
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return ListTile(
          leading: Image.network(
            Api.imageBaseUrl + movie.posterPath,
            width: 50,
            height: 75,
            fit: BoxFit.cover,
          ),
          title: Text(movie.title),
          subtitle: Text('Rating: ${movie.voteAverage.toStringAsFixed(1)}'),
          onTap: () => Get.to(() => MoviesDetailsScreen(movie: movie)),
        );
      },
    );
  }
}