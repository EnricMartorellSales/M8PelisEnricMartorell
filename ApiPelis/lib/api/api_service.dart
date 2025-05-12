import 'dart:convert';
import 'package:movies/api/api.dart';
import 'package:movies/models/movie.dart';
import 'package:http/http.dart' as http;
import 'package:movies/models/review.dart';
import 'package:movies/models/actor.dart';
import 'package:movies/models/series.dart';
import 'api_end_points.dart';

class ApiService {
  // ==================== MÉTODOS PARA PELÍCULAS ====================
  static Future<List<Movie>?> getTopRatedMovies() async {
    List<Movie> movies = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}movie/top_rated?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);
      res['results'].skip(6).take(5).forEach(
            (m) => movies.add(
              Movie.fromMap(m),
            ),
          );
      return movies;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Movie>?> getPopularMovies() async {
    List<Movie> movies = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}movie/popular?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);
      res['results'].take(6).forEach(
            (m) => movies.add(
              Movie.fromMap(m),
            ),
          );
      return movies;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Movie>?> getCustomMovies(String url) async {
    List<Movie> movies = [];
    try {
      http.Response response =
          await http.get(Uri.parse('${Api.baseUrl}movie/$url'));
      var res = jsonDecode(response.body);
      res['results'].take(6).forEach(
            (m) => movies.add(
              Movie.fromMap(m),
            ),
          );
      return movies;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Movie>?> getSearchedMovies(String query) async {
    List<Movie> movies = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}search/movie?api_key=${Api.apiKey}&language=en-US&query=$query&page=1&include_adult=false'));
      var res = jsonDecode(response.body);
      res['results'].forEach(
        (m) => movies.add(
          Movie.fromMap(m),
        ),
      );
      return movies;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Review>?> getMovieReviews(int movieId) async {
    List<Review> reviews = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}movie/$movieId/reviews?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);
      res['results'].forEach(
        (r) {
          reviews.add(
            Review(
                author: r['author'],
                comment: r['content'],
                rating: r['author_details']['rating']?.toDouble() ?? 0.0),
          );
        },
      );
      return reviews;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Actor>> getCast(int movieId) async {
    List<Actor> actors = [];
    try {
      final response = await http.get(Uri.parse(
          '${Api.baseUrl}movie/$movieId/credits?api_key=${Api.apiKey}&language=en-US'));
      var data = jsonDecode(response.body);
      if (data['cast'] != null) {
        for (var actor in data['cast']) {
          actors.add(Actor.fromMap(actor));
        }
      }
    } catch (e) {
      print("Error fetching cast: $e");
    }
    return actors;
  }

  // ==================== MÉTODOS PARA ACTORES ====================
  static Future<List<Actor>> getPopularActors() async {
    List<Actor> actors = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}${ApiEndPoints.popularActors}?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);
      for (var a in res['results']) {
        try {
          http.Response actorDetailsResponse = await http.get(Uri.parse(
              '${Api.baseUrl}person/${a['id']}?api_key=${Api.apiKey}&language=en-US'));
          var actorDetails = jsonDecode(actorDetailsResponse.body);
          actors.add(
            Actor(
              id: a['id'],
              name: a['name'],
              profilePath: a['profile_path'],
              popularity: a['popularity'],
              biography: actorDetails['biography'], 
              knownForMovies: [],
            ),
          );
        } catch (actorError) {
          print("Error fetching details for actor ${a['id']}: $actorError");
        }
      }
    } catch (e) {
      print("Error fetching popular actors: $e");
    }
    return actors;
  }

  static Future<List<Movie>> getMoviesByActor(int actorId) async {
    List<Movie> movies = [];
    try {
      final response = await http.get(Uri.parse(
          '${Api.baseUrl}person/$actorId/movie_credits?api_key=${Api.apiKey}&language=en-US'));
      var data = jsonDecode(response.body);
      if (data['cast'] != null && data['cast'].isNotEmpty) {
        for (var movie in data['cast']) {
          movies.add(Movie.fromMap(movie));
        }
      } else {
        print('No movies found for this actor');
      }
    } catch (e) {
      print("Error fetching movies by actor: $e");
    }
    return movies;
  }

  static Future<List<Actor>> searchActors(String query) async {
    List<Actor> actors = [];
    try {
      final response = await http.get(Uri.parse(
          '${Api.baseUrl}search/person?api_key=${Api.apiKey}&language=en-US&query=$query&page=1'));
      
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['results'] != null) {
          for (var actorData in data['results']) {
            actors.add(Actor.fromMap(actorData));
          }
        }
      } else {
        print('Error en la búsqueda de actores: ${response.statusCode}');
      }
    } catch (e) {
      print("Error searching actors: $e");
    }
    return actors;
  }

  // ==================== MÉTODOS PARA SERIES ====================
  static Future<List<Series>> getPopularTvShows() async {
    List<Series> series = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}${ApiEndPoints.popularTvShows}?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);
      for (var s in res['results']) {
        series.add(Series.fromMap(s));
      }
    } catch (e) {
      print("Error fetching popular TV shows: $e");
    }
    return series;
  }

  static Future<List<Series>> getTopRatedTvShows() async {
    List<Series> series = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}${ApiEndPoints.topRatedTvShows}?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);
      for (var s in res['results']) {
        series.add(Series.fromMap(s));
      }
    } catch (e) {
      print("Error fetching top rated TV shows: $e");
    }
    return series;
  }

  static Future<Series?> getTvShowDetails(int tvShowId) async {
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}${ApiEndPoints.tvShowDetails}/$tvShowId?api_key=${Api.apiKey}&language=en-US'));
      return Series.fromMap(jsonDecode(response.body));
    } catch (e) {
      print("Error fetching TV show details: $e");
      return null;
    }
  }

  static Future<List<Actor>> getTvShowCast(int tvShowId) async {
    List<Actor> actors = [];
    try {
      final response = await http.get(Uri.parse(
          '${Api.baseUrl}tv/$tvShowId/credits?api_key=${Api.apiKey}&language=en-US'));
      var data = jsonDecode(response.body);
      if (data['cast'] != null) {
        for (var actor in data['cast']) {
          actors.add(Actor.fromMap(actor));
        }
      }
    } catch (e) {
      print("Error fetching TV show cast: $e");
    }
    return actors;
  }

  static Future<List<Series>> searchTvShows(String query) async {
    List<Series> series = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}search/tv?api_key=${Api.apiKey}&language=en-US&query=$query&page=1'));
      var res = jsonDecode(response.body);
      for (var s in res['results']) {
        series.add(Series.fromMap(s));
      }
    } catch (e) {
      print("Error searching TV shows: $e");
    }
    return series;
  }
}