import 'package:flutter/material.dart';
import 'package:movie_search/movie_card.dart';

import 'movie_model.dart';

class MovieWidget extends StatelessWidget {
  const MovieWidget({Key? key, required this.movies}) : super(key: key);

  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          // return MovieCard();
          final movie = movies[index];
          return MovieCard(movie: movie);
        });
  }
}
