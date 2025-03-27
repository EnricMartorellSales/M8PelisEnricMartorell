import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/api/api_service.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/models/actor.dart';
import 'package:movies/models/series.dart';

class SearchController1 extends GetxController {
  final searchController = TextEditingController();
  var foundedMovies = <Movie>[].obs;
  var foundedSeries = <Series>[].obs;
  var foundedActors = <Actor>[].obs;
  var isLoading = false.obs;

  Future<void> search(String query) async {
    if (query.isEmpty) {
      clearResults();
      return;
    }

    isLoading.value = true;
    clearResults();

    try {
      // Realizamos las búsquedas por separado para mantener tu estructura
      final movies = await ApiService.getSearchedMovies(query);
      final series = await ApiService.searchTvShows(query);
      final actors = await ApiService.searchActors(query);

      // Asignamos los resultados (manejando posibles nulls)
      if (movies != null) foundedMovies.value = movies;
      if (series != null) foundedSeries.value = series;
      if (actors != null) foundedActors.value = actors;

    } catch (e) {
      Get.snackbar('Error', 'Failed to perform search: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void clearResults() {
    foundedMovies.clear();
    foundedSeries.clear();
    foundedActors.clear();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}