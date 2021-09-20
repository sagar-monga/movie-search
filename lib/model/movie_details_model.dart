import 'dart:core';

class MovieDetails {
  MovieDetails(this.id, this.director, this.imdbRating, this.genre, this.cast,
      this.language, this.runtime, this.plot);

  final String id;
  final String director;
  final String imdbRating;
  final String genre;
  final String cast;
  final String language;
  final String runtime;
  final String plot;
  factory MovieDetails.fromJson(Map<String, dynamic> json) {
    return MovieDetails(
      json["imdbID"] as String,
      json["Director"] as String,
      json["imdbRating"] as String,
      json["Genre"] as String,
      json["Actors"] as String,
      json["Language"] as String,
      json["Runtime"] as String,
      json["Plot"] as String,
    );
  }

  @override
  String toString() {
    return ("id: $id, Runtime: $runtime, Director: $director,"
        "Rating: $imdbRating, Genre: $genre, Cast: $cast,"
        "Language: $language");
  }
}
