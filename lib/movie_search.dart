import 'package:flutter/material.dart';
import 'http_helper.dart';
import 'movie.dart';
import 'movie_detail.dart';

class MovieSearch extends SearchDelegate<Movie?> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: const Icon(Icons.clear), onPressed: () { query = ''; })];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(icon: const Icon(Icons.arrow_back), onPressed: () { close(context, null); });
  }

  @override
  Widget buildResults(BuildContext context) {
    HttpHelper helper = HttpHelper();
    return FutureBuilder<List<Movie>?>(
      future: helper.findMovies(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("No movies found"));
        final movies = snapshot.data!;
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(movies[index].title ?? ""),
              leading: (movies[index].posterPath != null)
                  ? Image.network('https://image.tmdb.org/t/p/w92/${movies[index].posterPath}')
                  : const Icon(Icons.movie),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetail(movies[index])));
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.search, size: 100, color: Colors.grey), Text('Search movies...')]));
  }
}