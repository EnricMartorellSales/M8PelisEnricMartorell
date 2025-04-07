class Series {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final String firstAirDate;
  final List<int> genreIds;
  final int numberOfSeasons;
  final int numberOfEpisodes;

  Series({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.firstAirDate,
    required this.genreIds,
    this.numberOfSeasons = 0,
    this.numberOfEpisodes = 0,
  });

  factory Series.fromMap(Map<String, dynamic> map) {
    return Series(
      id: map['id'] as int,
      title: map['name'] ?? '',
      overview: map['overview'] ?? '',
      posterPath: map['poster_path'] ?? '',
      backdropPath: map['backdrop_path'] ?? '',
      voteAverage: map['vote_average']?.toDouble() ?? 0.0,
      firstAirDate: map['first_air_date'] ?? '',
      genreIds: List<int>.from(map['genre_ids'] ?? []),
      numberOfSeasons: map['number_of_seasons'] ?? 0,
      numberOfEpisodes: map['number_of_episodes'] ?? 0,
    );
  }
}