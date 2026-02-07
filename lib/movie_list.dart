import 'package:flutter/material.dart';
import 'http_helper.dart';
import 'movie.dart';
import 'movie_detail.dart';
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
  int _selectedIndex = 0; // ตัวแปรเก็บว่าเลือกเมนูไหนอยู่

  final String iconBase = 'https://image.tmdb.org/t/p/w92/';
  final String defaultImage = 'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';

  @override
  void initState() {
    helper = HttpHelper();
    initialize();
    super.initState();
  }

  // ฟังก์ชันดึงข้อมูลที่ฉลาดขึ้น เลือกได้ว่าจะเอาหนังอะไร
  Future<void> initialize() async {
    if (_selectedIndex == 0) {
      movies = await helper?.getUpcoming(); // เมนูแรก: หนังใหม่
    } else {
      movies = await helper?.getTopRated(); // เมนูสอง: หนังดัง
    }
    setState(() {
      moviesCount = movies?.length;
    });
  }

  // ฟังก์ชันเมื่อกดเปลี่ยนเมนู
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    initialize(); // โหลดข้อมูลใหม่ทันที
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Upcoming Movies' : 'Top Rated Movies'), // เปลี่ยนชื่อหัวข้อตามเมนู
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: MovieSearch());
            },
          )
        ],
      ),
      // เพิ่ม RefreshIndicator ครอบ ListView เพื่อให้ดึงจอลงมาแล้วโหลดใหม่ได้
      body: RefreshIndicator(
        onRefresh: initialize,
        child: (moviesCount == null)
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
                        MaterialPageRoute route = MaterialPageRoute(
                            builder: (_) => MovieDetail(movies![position]));
                        Navigator.push(context, route);
                      },
                    ),
                  );
                },
              ),
      ),
      // แถบเมนูด้านล่างสุดเท่
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Upcoming',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Top Rated',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepOrange,
        onTap: _onItemTapped,
      ),
    );
  }
}