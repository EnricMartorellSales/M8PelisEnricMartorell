import 'package:get/get.dart';
import 'package:movies/api/api_service.dart';
import 'package:movies/models/actor.dart';

class ActorsController extends GetxController {
  var isLoading = false.obs;
  var mainTopRatedActors = <Actor>[].obs;
  var watchListActors = <Actor>[].obs;

  @override
  void onInit() async {
    isLoading.value = true;
    mainTopRatedActors.value = (await ApiService.getPopularActors());
    isLoading.value = false;
    super.onInit();
  }

  bool isInActorsList(Actor actor) {
    return watchListActors.any((m) => m.id == actor.id);
  }

  void addToActorsList(Actor actor) {
    if (watchListActors.any((m) => m.id == actor.id)) {
      watchListActors.remove(actor);
      Get.snackbar('Success', 'removed from actors list',
        snackPosition: SnackPosition.BOTTOM,
        animationDuration: const Duration(seconds: 1),
        duration: const Duration(seconds: 1));
    } else {
      watchListActors.add(actor);
      Get.snackbar('Success', 'added to actors list',
        snackPosition: SnackPosition.BOTTOM,
        animationDuration: const Duration(seconds: 1),
        duration: const Duration(seconds: 1));
    }
  }
}
