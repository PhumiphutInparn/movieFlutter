import 'package:flutter/material.dart';
import 'http_helper.dart';
import 'movie.dart';
import 'movie_detail.dart'; // เชื่อมกับหน้า Detail
import 'movie_search.dart';

class MovieList extends StatefulWidget {
  const MovieList({super.key});

  @override
  State<MovieList> createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  HttpHelper? helper;
  List<Movie>? movies;
  int? moviesCount;
  final String iconBase = 'https://image.tmdb.org/t/p/w92/';
  final String defaultImage = 'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';

  @override
  void initState() {
    helper = HttpHelper();
    initialize();
    super.initState();
  }

  Future initialize() async {
    movies = await helper?.getUpcoming();
    setState(() {
      moviesCount = movies?.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
    title: const Text('Upcoming Movies'),
    actions: [
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () {
          showSearch(context: context, delegate: MovieSearch());
        },
      )
    ],
  ),
      body: (moviesCount == null)
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: moviesCount,
              itemBuilder: (BuildContext context, int position) {
                NetworkImage image;
                if (movies![position].posterPath != null) {
                  image = NetworkImage(iconBase + movies![position].posterPath!);
                } else {
                  image = NetworkImage(defaultImage);
                }

                return Card(
                  color: Colors.white,
                  elevation: 2.0,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: image,
                    ),
                    title: Text(movies![position].title ?? ""),
                    subtitle: Text(
                        'Released: ${movies![position].releaseDate} - Vote: ${movies![position].voteAverage}'),
                    onTap: () {
                      // กดแล้วเด้งไปหน้า Detail
                      MaterialPageRoute route = MaterialPageRoute(
                          builder: (_) => MovieDetail(movies![position]));
                      Navigator.push(context, route);
                    },
                  ),
                );
              },
            ),
    );
  }
}