import 'dart:core';

class Movie {
  final String title;
  // final String[] category;
  final String year;
  final String imageUrl;
  
  Movie({
    required this.title,
    // required this.category,
    required this.year, 
    required this.imageUrl,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json["Title"],
      // category: json['Genre'],
      year: json["Year"],
      imageUrl: json["Poster"],
    );
  }
}