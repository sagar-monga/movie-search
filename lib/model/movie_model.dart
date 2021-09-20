import 'dart:core';

class Movie {
  final String title;
  final String year;
  final String imageUrl;
  final String movieId;

  Movie({
    required this.title,
    required this.year,
    required this.imageUrl,
    required this.movieId,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json["Title"],
      year: json["Year"],
      imageUrl: json["Poster"],
      movieId: json["imdbID"],
    );
  }
  @override
  String toString() {
    return ("title: $title, year: $year, id: $movieId");
  }
}
