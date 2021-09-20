import 'package:flutter/material.dart';
import 'package:movie_search/movie_card.dart';

import 'movie_model.dart';

class MovieWidget extends StatelessWidget {
  const MovieWidget({Key? key, required this.movies, required this.size})
      : super(key: key);
  final Size size;
  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(0),
        physics: const BouncingScrollPhysics(),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return MovieCard(
            movie: movie,
            size: size,
            index:index,
          );
        });
  }
}
