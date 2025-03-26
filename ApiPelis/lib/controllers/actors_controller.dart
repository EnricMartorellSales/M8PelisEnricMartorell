import 'package:get/get.dart';
import 'package:movies/api/api_service.dart';
import 'package:movies/models/actor.dart';
import 'package:movies/controllers/movies_controller.dart';

class ActorsController extends GetxController {
  var isLoading = false.obs;
  var mainTopRatedActors = <Actor>[].obs;

  @override
  void onInit() async {
    await fetchPopularActors();
    super.onInit();
  }

  Future<void> fetchPopularActors() async {
    try {
      isLoading.value = true;
      mainTopRatedActors.value = await ApiService.getPopularActors();
    } finally {
      isLoading.value = false;
    }
  }

  bool isInActorsList(Actor actor) {
    return Get.find<MoviesController>().isActorInWatchList(actor);
  }

  void addToActorsList(Actor actor) {
    final moviesController = Get.find<MoviesController>();
    if (moviesController.isActorInWatchList(actor)) {
      moviesController.removeActorFromWatchList(actor);
      Get.snackbar(
        'Removed',
        '${actor.name} removed from watchlist',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } else {
      moviesController.addActorToWatchList(actor);
      Get.snackbar(
        'Added',
        '${actor.name} added to watchlist',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }
}