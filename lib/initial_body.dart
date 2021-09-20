import 'package:flutter/material.dart';

class InitialBody extends StatelessWidget {
  const InitialBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: ListView(physics: const NeverScrollableScrollPhysics(), children: [
        const Center(
          child: Text(
            "Welcome to movies search app",
            style: TextStyle(fontSize: 24),
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Center(child: Text("Search for any movie you like")),
        const SizedBox(
          height: 20,
        ),
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('assets/images/movie_logo.jpg'),
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          child: SizedBox(),
        ),
      ]),
    );
  }
}
