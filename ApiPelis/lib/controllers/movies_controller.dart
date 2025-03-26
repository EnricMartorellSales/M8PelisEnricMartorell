import 'package:get/get.dart';
import 'package:movies/api/api_service.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/models/actor.dart';

class MoviesController extends GetxController {
  var isLoading = false.obs;
  var mainTopRatedMovies = <Movie>[].obs;
  var watchListMovies = <Movie>[].obs;
  var watchListActors = <Actor>[].obs;

  @override
  void onInit() async {
    await fetchTopRatedMovies();
    super.onInit();
  }

  Future<void> fetchTopRatedMovies() async {
    try {
      isLoading.value = true;
      mainTopRatedMovies.value = (await ApiService.getTopRatedMovies())!;
    } finally {
      isLoading.value = false;
    }
  }

  // Métodos para películas
  bool isInWatchList(Movie movie) {
    return watchListMovies.any((m) => m.id == movie.id);
  }

  void addToWatchList(Movie movie) {
    if (isInWatchList(movie)) {
      removeFromWatchList(movie);
    } else {
      watchListMovies.add(movie);
      Get.snackbar(
        'Added',
        '${movie.title} added to watchlist',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
      );
    }
  }

  void removeFromWatchList(Movie movie) {
    watchListMovies.remove(movie);
    Get.snackbar(
      'Removed',
      '${movie.title} removed from watchlist',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  // Métodos para actores
  bool isActorInWatchList(Actor actor) {
    return watchListActors.any((a) => a.id == actor.id);
  }

  void addActorToWatchList(Actor actor) {
    if (isActorInWatchList(actor)) {
      removeActorFromWatchList(actor);
    } else {
      watchListActors.add(actor);
      Get.snackbar(
        'Added',
        '${actor.name} added to watchlist',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
      );
    }
  }

  void removeActorFromWatchList(Actor actor) {
    watchListActors.remove(actor);
    Get.snackbar(
      'Removed',
      '${actor.name} removed from watchlist',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  // Métodos para limpiar las listas
  void clearMoviesWatchList() {
    watchListMovies.clear();
  }

  void clearActorsWatchList() {
    watchListActors.clear();
  }
}