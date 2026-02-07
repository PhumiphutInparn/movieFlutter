import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'movie.dart';

class HttpHelper {
  // Key ของคุณ ใส่ให้แล้วครับ
  final String urlKey = 'api_key=8d07879b26b999decb0cb26b4933c985';
  final String urlBase = 'https://api.themoviedb.org/3/movie';
  final String urlUpcoming = '/upcoming?';
  final String urlLanguage = '&language=en-US';

  Future<List<Movie>?> getUpcoming() async {
    final String upcoming = urlBase + urlUpcoming + urlKey + urlLanguage;
    http.Response result = await http.get(Uri.parse(upcoming));

    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      final moviesMap = jsonResponse['results'];
      List<Movie> movies =
          List<Movie>.from(moviesMap.map((i) => Movie.fromJson(i)));
      return movies;
    } else {
      return null;
    }
  }
  // -----------------------------------------------------------
  // เพิ่มส่วนนี้ต่อท้ายฟังก์ชัน getUpcoming ได้เลยครับ
  // -----------------------------------------------------------
  Future<List<Movie>?> findMovies(String title) async {
    final String urlSearchBase = 'https://api.themoviedb.org/3/search/movie?api_key=';
    final String query = '&query=$title';
    // ใช้ Key เดิมของคุณ
    final String urlSearch = urlSearchBase + '8d07879b26b999decb0cb26b4933c985' + query;

    http.Response result = await http.get(Uri.parse(urlSearch));
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      final moviesMap = jsonResponse['results'];
      List<Movie> movies =
          List<Movie>.from(moviesMap.map((i) => Movie.fromJson(i)));
      return movies;
    } else {
      return null;
    }
  }
}