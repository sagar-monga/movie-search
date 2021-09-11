import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_search/movie_model.dart';

import 'movies_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // late Future<Movie> movies;

  // var movies1;
  // Future<Map> getJson() async {
  //   var url = "http://www.omdbapi.com/?apikey=bfb026bf&t=fast";
  //   http.Response response = await (http.get(Uri.parse(url)));
  //   debugPrint("Response is " + response.body);
  //   // return Movie.fromJson(jsonDecode(response.body));

  //   return json.decode(response.body);
  // }

  // Future<void> getData() async {
  //   var data = await getJson();
  //   setState(() {
  //     movies1 = data['results'];
  //   });
  // }

  final TextEditingController _searchController = TextEditingController();
  List<Movie> _movies = [];

  Future<List<Movie>> _fetchAllMovies(String term) async {
    String url =
        "https://www.omdbapi.com/?s=$term&page=1&type=movie&apikey=bfb026bf";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // print('Successful fetch');
      final result = jsonDecode(response.body);
      Iterable list = result["Search"];
      return list.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception("Failed to lead Movies");
    }
  }

  void _listMovies(String term) async {
    final movies = await _fetchAllMovies(term);
    setState(() {
      _movies = movies;
    });
  }

  @override
  initState() {
    super.initState();
    _listMovies("Fast");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            searchBar(),
          ];
        },
        body: _movies != []
            ? MovieWidget(movies: _movies)
            : const Center(child: Text("No Movies Found")),
      ),
    );
  }

  SliverAppBar searchBar() {
    return SliverAppBar(
      title: Column(
        children: const [
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              "Home",
              style: TextStyle(
                color: Colors.black,
                fontSize: 52,
              ),
            ),
          ),
        ],
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          children: <Widget>[
            const SizedBox(height: 120.0),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 16.0),
              child: Container(
                height: 70.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.only(left: 32, right: 8),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(fontSize: 22, height: 1.6),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Search for movies",
                    focusedBorder: textfieldOutline(),
                    enabledBorder: textfieldOutline(),
                    errorBorder: textfieldOutline(),
                    disabledBorder: textfieldOutline(),
                    focusedErrorBorder: textfieldOutline(),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.search,
                        size: 36,
                      ),
                      color: Colors.black,
                      onPressed: () {
                        // print(_searchController.text);
                        _listMovies(_searchController.text);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      toolbarHeight: 120,
      expandedHeight: 250,
      floating: true,
      backgroundColor: Colors.white,
    );
  }

  OutlineInputBorder textfieldOutline() {
    // ignore: prefer_const_constructors
    return OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
    );
  }
}
