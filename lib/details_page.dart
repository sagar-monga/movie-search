import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:movie_search/constants.dart';
import 'package:movie_search/movie_details_model.dart';
import 'package:movie_search/movie_model.dart';

class MovieDetailsWidget extends StatefulWidget {
  const MovieDetailsWidget({Key? key, required this.movie, required this.index})
      : super(key: key);

  final Movie movie;
  final int index;

  @override
  State<MovieDetailsWidget> createState() => _MovieDetailsWidgetState();
}

class _MovieDetailsWidgetState extends State<MovieDetailsWidget> {
  MovieDetails md = MovieDetails('', '', '', '', '', '', '', '');
  Size _size = const Size(0.0, 0.0);
  @override
  initState() {
    super.initState();
    _initialiseDetails();
  }

  _initialiseDetails() async {
    md = await _fetchDetails(widget.movie.movieId);
    print("MD: ${md.toString()}\n");
    // print("Movie: ${widget.movie.toString()}");
  }

  Future<MovieDetails> _fetchDetails(String id) async {
    String url = "https://www.omdbapi.com/?i=$id&apikey=$apiKey";
    final response = await http.get(Uri.parse(url));
    // print(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> result = jsonDecode(response.body);

      if (result["Response"] == "True") {
        return MovieDetails.fromJson(result);
      } else {
        // print("Details not found");
        throw Exception("Details not found");
      }
    } else {
      // print("Some Error Occured");
      throw Exception("Some error Occurred");
    }
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        physics: const ClampingScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.white,
              expandedHeight: 300,
              flexibleSpace: Hero(
                transitionOnUserGestures: true,
                tag: 'posterHero${widget.index}',
                child: Image.network(
                  widget.movie.imageUrl,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ];
        },
        body: FutureBuilder(
          future: _fetchDetails(widget.movie.movieId),
          // future: _initialiseDetails(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.all(0.0),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Center(
                        child: Text(
                          widget.movie.title,
                          style: const TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    _genreRow(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: const Color(0xff750000),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: RatingBar.builder(
                            ignoreGestures: true,
                            initialRating: md.imdbRating != ''
                                ? (double.parse(md.imdbRating)) / 2
                                : 0.0,
                            itemCount: 5,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemSize: 20,
                            unratedColor: Colors.grey[300],
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 1.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {},
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      indent: 20,
                      endIndent: 20,
                      color: Colors.grey[700],
                      thickness: 1.0,
                    ),
                    Text(
                      md.plot,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w400),
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Divider(
                      indent: 20,
                      endIndent: 20,
                      color: Colors.grey[700],
                      thickness: 1.0,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: "Director(s): ",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: md.director,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: "Cast: ",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: md.cast,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: "Language(s): ",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: md.language,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _genreRow() {
    List<String> list = md.genre.split(',');

    return Padding(
      padding: EdgeInsets.only(
          left: _size.width * 0.2, right: _size.width * 0.2, top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(widget.movie.year,
              style: const TextStyle(fontStyle: FontStyle.italic)),
          const Text("•"),
          Text(list[0], style: const TextStyle(fontStyle: FontStyle.italic)),
          const Text("•"),
          Text(md.runtime, style: const TextStyle(fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }
}
