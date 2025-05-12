class Actor {
  final int id;
  final String name;
  final String? profilePath;
  final double? popularity;
  final String? biography;
  final List<String>? knownForMovies;

  Actor({
    required this.id,
    required this.name,
    this.profilePath,
    this.popularity,
    this.biography,
    this.knownForMovies,
  });

  factory Actor.fromMap(Map<String, dynamic> map) {
    // Procesar known_for correctamente (puede contener películas o series)
    List<String> knownFor = [];
    if (map['known_for'] != null) {
      for (var item in map['known_for']) {
        knownFor.add(item['title'] ?? item['name'] ?? 'Unknown');
      }
    }

    return Actor(
      id: map['id'] ?? 0,
      name: map['name'] ?? 'Unknown',
      profilePath: map['profile_path'],
      popularity: (map['popularity'] as num?)?.toDouble(),
      biography: map['biography'],
      knownForMovies: knownFor.isNotEmpty ? knownFor : null,
    );
  }
}