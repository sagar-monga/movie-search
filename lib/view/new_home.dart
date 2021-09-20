import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:movie_search/model/movie_model.dart';
import 'package:movie_search/view/constants.dart';
import 'initial_body.dart';
import 'movies_widget.dart';

class NewHome extends StatefulWidget {
  const NewHome({Key? key}) : super(key: key);

  @override
  _NewHomeState createState() => _NewHomeState();
}

class _NewHomeState extends State<NewHome> {
  final TextEditingController _searchController = TextEditingController();

  Future<List<Movie>> _fetchAllMovies(String term) async {
    _firstLoad = false;
    String url =
        "https://www.omdbapi.com/?s=$term&page=1&type=movie&apikey=$apiKey";
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
          _errorSnackbar(),
        );
        // throw Exception("Invalid search string!");
        return [];
      }
    } else {
      return [];
      // throw Exception("Failed to lead Movies");
    }
  }

  SnackBar _errorSnackbar() {
    return const SnackBar(
      content: Text("No movies found with the given name!"),
      backgroundColor: Colors.teal,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
  }

  bool _firstLoad = true;

  @override
  initState() {
    super.initState();
    // _fetchAllMovies("Fast");
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
        backgroundColor: Colors.white,
        body: NestedScrollView(
          physics: const ClampingScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              searchBar(),
            ];
          },
          body: _firstLoad
              ? const InitialBody()
              : FutureBuilder(
                  future: _fetchAllMovies(_searchController.text),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length == 0) {
                        return Center(
                          child: Column(
                            children: const [
                              SizedBox(
                                height: 50,
                              ),
                              Text(
                                "Uh-oh",
                                style: TextStyle(fontSize: 36),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "No Movies found with this name",
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        );
                      }
                      return MovieWidget(movies: snapshot.data, size: _size);
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          children: const [
                            Text("Uh-oh"),
                            Text("No Movies Found"),
                          ],
                        ),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
        ),
      ),
    );
  }

  SliverAppBar searchBar() {
    return SliverAppBar(
      title: Column(
        children: const [
          Padding(
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
                        setState(() {
                          _fetchAllMovies(_searchController.text);
                        });
                      },
                    ),
                  ),
                  onSubmitted: (String value) {
                    setState(() {
                      _fetchAllMovies(_searchController.text);
                    });
                  },
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
    return const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),
    );
  }
}
