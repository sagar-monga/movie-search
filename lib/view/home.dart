import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:movie_search/model/movie_model.dart';

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
    // print(response.body);
    if (response.statusCode == 200) {
      // print('Successful fetch');
      final result = jsonDecode(response.body);
      if (result["Response"] == "True") {
        Iterable list = result["Search"];

        return list.map((movie) => Movie.fromJson(movie)).toList();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No movies found with the given name!"),
            backgroundColor: Colors.teal,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        );
        // throw Exception("Invalid search string!");
        return [];
      }
    } else {
      throw Exception("Failed to lead Movies");
    }
  }

  void _listMovies(String term) async {
    if (term != "") {
      final movies = await _fetchAllMovies(term);
      setState(() {
        _movies = movies;
      });
    }
  }

  @override
  initState() {
    super.initState();
    _listMovies("Fast");
  }

  Size _size = const Size(0, 0);
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
      ),
      child: Scaffold(
        body: NestedScrollView(
          physics: const ClampingScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              searchBar(),
            ];
          },
          body: _movies != []
              ? MovieWidget(
                  movies: _movies,
                  size: _size,
                )
              : const Center(child: Text("No Movies Found")),
        ),
      ),
    );
  }

  SliverAppBar searchBar() {
    return SliverAppBar(
      title: Column(
        children: const [
          Padding(
            // padding: EdgeInsets.only(left: _size.width * 0.01),
            padding: EdgeInsets.only(left: 5),
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
            SizedBox(height: _size.height * 0.15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: _size.width * 0.05),
              child: Container(
                height: 60,
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
      toolbarHeight: _size.height * 0.1,
      expandedHeight: _size.height * 0.3,
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
