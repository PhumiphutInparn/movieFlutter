import 'package:flutter/material.dart';
import 'http_helper.dart';
import 'movie.dart';

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

  // ฟังก์ชันเริ่มดึงข้อมูล
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
      ),
      // เช็คว่ามีข้อมูลไหม ถ้าไม่มีให้แสดงวงกลมหมุนๆ
      body: (moviesCount == null) 
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: moviesCount,
              itemBuilder: (BuildContext context, int position) {
                NetworkImage image;
                // เช็คว่าหนังเรื่องนี้มีรูปไหม
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
                    subtitle: Text('Released: ${movies![position].releaseDate} - Vote: ${movies![position].voteAverage}'),
                    onTap: () {
                      // กดแล้วทำอะไรต่อ (เว้นไว้ก่อน)
                    },
                  ),
                );
              },
            ),
    );
  }
}