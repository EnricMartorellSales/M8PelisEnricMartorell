import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/api/api.dart';
import 'package:movies/api/api_service.dart';
import 'package:movies/controllers/bottom_navigator_controller.dart';
import 'package:movies/controllers/actors_controller.dart';
import 'package:movies/controllers/search_controller.dart';
import 'package:movies/controllers/series_controller.dart';
import 'package:movies/screens/actor_detail_screen.dart';
import 'package:movies/screens/more_content_screen.dart'; // Necesitarás crear este
import 'package:movies/screens/series_detail_screen.dart';
import 'package:movies/widgets/search_box.dart';
import 'package:movies/widgets/tab_builder.dart';
import 'package:movies/widgets/top_rated_actor_item.dart';
import 'package:movies/widgets/series_item.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final ActorsController controller = Get.put(ActorsController());
  final SeriesController seriesController = Get.put(SeriesController());
  final SearchController1 searchController = Get.put(SearchController1());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 42,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Who is your favorite actor?',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 24),
            SearchBox(
              onSumbit: () {
                String search =
                    Get.find<SearchController1>().searchController.text;
                Get.find<SearchController1>().searchController.text = '';
                Get.find<SearchController1>().search(search);
                Get.find<BottomNavigatorController>().setIndex(1);
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
            const SizedBox(height: 34),
            // Top Rated Actors Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Top Rated Actors',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    Get.to(() => MoreContentScreen(
                          title: 'Top Rated Actors',
                          contentType: ContentType.actors,
                        ));
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(
              () => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      height: 300,
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.mainTopRatedActors.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 24),
                        itemBuilder: (_, index) {
                          final actor = controller.mainTopRatedActors[index];
                          return GestureDetector(
                            onTap: () {
                              Get.to(() => ActorDetailScreen(actor: actor));
                            },
                            child: TopRatedActorItem(
                              actor: actor,
                              index: index + 1,
                            ),
                          );
                        },
                      ),
                    ),
            ),
            const SizedBox(height: 34),
            // Popular Series Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Popular Series',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    Get.to(() => MoreContentScreen(
                          title: 'Popular Series',
                          contentType: ContentType.series,
                        ));
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(
              () => seriesController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      height: 300,
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: seriesController.mainTopRatedSeries.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 24),
                        itemBuilder: (_, index) {
                          final series = seriesController.mainTopRatedSeries[index];
                          return GestureDetector(
                            onTap: () {
                              Get.to(() => SeriesDetailScreen(series: series));
                            },
                            child: SeriesItem(
                              series: series,
                              onAddToWatchList: () {
                                seriesController.addToWatchList(series);
                              },
                              isInWatchList: seriesController.isInWatchList(series),
                            ),
                          );
                        },
                      ),
                    ),
            ),
            const SizedBox(height: 34),
            // Movies Tab Section with "See More"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Movies',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    Get.to(() => MoreContentScreen(
                          title: 'Popular Movies',
                          contentType: ContentType.movies,
                        ));
                  },
                ),
              ],
            ),
            DefaultTabController(
              length: 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const TabBar(
                    indicatorWeight: 3,
                    indicatorColor: Color(0xFF3A3F47),
                    labelStyle: TextStyle(fontSize: 11.0),
                    tabs: [
                      Tab(text: 'Now playing'),
                      Tab(text: 'Upcoming'),
                      Tab(text: 'Top rated'),
                      Tab(text: 'Popular'),
                    ],
                  ),
                  SizedBox(
                    height: 400,
                    child: TabBarView(
                      children: [
                        TabBuilder(
                          future: ApiService.getCustomMovies(
                            'now_playing?api_key=${Api.apiKey}&language=en-US&page=1',
                          ),
                        ),
                        TabBuilder(
                          future: ApiService.getCustomMovies(
                            'upcoming?api_key=${Api.apiKey}&language=en-US&page=1',
                          ),
                        ),
                        TabBuilder(
                          future: ApiService.getCustomMovies(
                            'top_rated?api_key=${Api.apiKey}&language=en-US&page=1',
                          ),
                        ),
                        TabBuilder(
                          future: ApiService.getCustomMovies(
                            'popular?api_key=${Api.apiKey}&language=en-US&page=1',
                          ),
                        ),
                      ],
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
}