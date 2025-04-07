import 'package:get/get.dart';
import 'package:movies/api/api_service.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/models/actor.dart';
import 'package:movies/models/series.dart';

class SeriesController extends GetxController{
  var isLoading = false.obs;
  var mainTopRatedSeries = <Series>[].obs;
  var watchListSeries = <Series>[].obs;
  var watchListActors = <Actor>[].obs;
  
  @override

  void onInit() async{
    await fetchTopRatedSeries();
    super.onInit();
  }

  Future<void> fetchTopRatedSeries() async{
    try{
      isLoading.value = true;
      mainTopRatedSeries.value =(await ApiService.getTopRatedTvShows())!;
    } finally{
      isLoading.value = false ;
    }

    }
    
  bool isInWatchList(Series serie) {
    return watchListSeries.any((m) => m.id == serie.id);
  }
    
    void addToWatchList(Series serie){
      if(isInWatchList(serie)){
        removeFromWatchList(serie);
      }
      else{
        watchListSeries.add(serie);
        Get.snackbar('Added','${serie.title} added to watchlist',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
        );
      }
    }
    void removeFromWatchList(Series serie) {
    watchListSeries.remove(serie);
    Get.snackbar(
      'Removed',
      '${serie.title} removed from watchlist',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }
  
  void clearSeriesWatchList(){
    watchListSeries.clear();
  }

  }
