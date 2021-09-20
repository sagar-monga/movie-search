import 'package:flutter/material.dart';
import 'package:movie_search/details_page.dart';

import 'movie_model.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final Size size;
  final int index;
  const MovieCard(
      {Key? key, required this.movie, required this.size, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MovieDetailsWidget(
                      movie: movie,
                      index: index,
                    )));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Container(
          // padding: const EdgeInsets.only(bottom: 10.0),
          // padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          margin: const EdgeInsets.only(bottom: 20, left: 5, right: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.grey, //Card shadow
                offset: Offset(1.0, 5.0),
                blurRadius: 2.0,
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Hero(
                    tag: 'posterHero$index',
                    child: Container(
                      margin: const EdgeInsets.all(16.0),
                      child: const SizedBox(
                        width: 120.0,
                        height: 160.0,
                      ),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(movie.imageUrl),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black, // Poster shadow
                            blurRadius: 10.0,
                            offset: Offset(5.0, 5.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                    child: Column(
                      children: [
                        Text(
                          movie.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.all(2.0)),
                        // Text(
                        //   movie['Year'],
                        //   maxLines: 3,
                        //   style: const TextStyle(
                        //       color: Color(0xff8785A4), fontFamily: 'Arvo'),
                        // ),
                        const Padding(padding: EdgeInsets.all(5.0)),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          child: Text(
                            movie.year,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  )),
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
