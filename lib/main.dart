import 'package:flutter/material.dart';
import 'movie_list.dart';

void main() {
  runApp(const MyMovies());
}

class MyMovies extends StatelessWidget {
  const MyMovies({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Movies',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const MovieList(),
    );
  }
}