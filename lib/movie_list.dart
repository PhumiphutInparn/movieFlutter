import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'http_helper.dart';
import 'movie.dart';
import 'movie_detail.dart';

class MovieList extends StatefulWidget {
  const MovieList({super.key});

  @override
  State<MovieList> createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  HttpHelper? helper;
  List<Movie>? movies;
  int _selectedIndex = 0;

  @override
  void initState() {
    helper = HttpHelper();
    initialize();
    super.initState();
  }

  Future<void> initialize() async {
    List<Movie>? result;
    if (_selectedIndex == 0) {
      result = await helper?.getUpcoming();
    } else {
      result = await helper?.getTopRated();
    }
    setState(() {
      movies = result;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Upcoming Movies' : 'Top Rated'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: MovieSearchDelegate());
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: initialize,
        child: (movies == null)
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: movies!.length,
                itemBuilder: (BuildContext context, int position) {
                  return Card(
                    color: Colors.white,
                    elevation: 2.0,
                    child: ListTile(
                      leading: Hero(
                        tag: movies![position].id.toString(),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          backgroundImage: (movies![position].posterPath != null)
                              ? CachedNetworkImageProvider('https://image.tmdb.org/t/p/w92${movies![position].posterPath}')
                              : null,
                          child: (movies![position].posterPath == null) ? const Icon(Icons.movie) : null,
                        ),
                      ),
                      title: Text(movies![position].title ?? ""),
                      subtitle: Text('Rating: ${movies![position].voteAverage}'),
                      onTap: () {
                        MaterialPageRoute route = MaterialPageRoute(
                            builder: (_) => MovieDetail(movies![position]));
                        Navigator.push(context, route);
                      },
                    ),
                  );
                },
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Upcoming'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Top Rated'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepOrange,
        onTap: _onItemTapped,
      ),
    );
  }
}

class MovieSearchDelegate extends SearchDelegate {
  HttpHelper helper = HttpHelper();

  @override
  List<Widget>? buildActions(BuildContext context) => [IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, null));

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
        future: helper.findMovies(query),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          List<Movie> found = snapshot.data as List<Movie>;
          return ListView.builder(
              itemCount: found.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(found[index].title ?? ''),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => MovieDetail(found[index])));
                  },
                );
              });
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) => const Center(child: Text("Search movies..."));
}