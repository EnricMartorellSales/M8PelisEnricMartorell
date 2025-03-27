import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/api/api.dart';
import 'package:movies/controllers/bottom_navigator_controller.dart';
import 'package:movies/controllers/search_controller.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/models/actor.dart';
import 'package:movies/models/series.dart';
import 'package:movies/screens/details_screen.dart';
import 'package:movies/screens/actor_detail_screen.dart';
import 'package:movies/screens/series_detail_screen.dart';
import 'package:movies/widgets/search_box.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 34),
        child: Column(
          children: [
            // Encabezado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Get.find<BottomNavigatorController>().setIndex(0),
                ),
                const Text('Search', style: TextStyle(fontSize: 24)),
                const Icon(Icons.search, color: Colors.white), // Icono decorativo
              ],
            ),
            const SizedBox(height: 30),

            // Barra de búsqueda
            SearchBox(
              onSumbit: () {
                final query = Get.find<SearchController1>().searchController.text;
                if (query.isNotEmpty) {
                  Get.find<SearchController1>().search(query);
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              },
            ),
            const SizedBox(height: 30),

            // Resultados (mezclados)
            Obx(() {
              final controller = Get.find<SearchController1>();
              
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final results = [
                ...controller.foundedMovies.map((m) => _ResultItem.movie(m)),
                ...controller.foundedSeries.map((s) => _ResultItem.series(s)),
                ...controller.foundedActors.map((a) => _ResultItem.actor(a)),
              ];

              if (results.isEmpty) {
                return const Column(
                  children: [
                    Icon(Icons.search_off, size: 80, color: Colors.grey),
                    Text('No results found', style: TextStyle(fontSize: 20)),
                  ],
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: results.length,
                itemBuilder: (_, index) => results[index],
              );
            }),
          ],
        ),
      ),
    );
  }
}

// Widget auxiliar para mostrar ítems de resultados
class _ResultItem extends StatelessWidget {
  final dynamic item;
  final String type; // 'movie', 'series' o 'actor'

  const _ResultItem.movie(this.item) : type = 'movie';
  const _ResultItem.series(this.item) : type = 'series';
  const _ResultItem.actor(this.item) : type = 'actor';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (type == 'movie') {
          Get.to(DetailsScreen(movie: item as Movie));
        } else if (type == 'series') {
          Get.to(SeriesDetailScreen(series: item as Series));
        } else {
          Get.to(ActorDetailScreen(actor: item as Actor));
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            // Poster/Foto
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildImage(),
            ),
            const SizedBox(width: 15),
            
            // Información básica
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type == 'movie' 
                      ? (item as Movie).title
                      : type == 'series'
                        ? (item as Series).name
                        : (item as Actor).name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    type.toUpperCase(),
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    final String imageUrl = type == 'movie'
        ? (item as Movie).posterPath
        : type == 'series'
            ? (item as Series).posterPath
            : (item as Actor).profilePath ?? '';

    final double width = 80;
    final double height = 120;

    if (imageUrl.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[800],
        child: Icon(
          type == 'actor' ? Icons.person : Icons.movie,
          size: 40,
        ),
      );
    }

    return Image.network(
      Api.imageBaseUrl + imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: Colors.grey[800],
        child: const Icon(Icons.broken_image),
      ),
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return const FadeShimmer(
          width: 80,
          height: 120,
          highlightColor: Color(0xff22272f),
          baseColor: Color(0xff20252d),
        );
      },
    );
  }
}