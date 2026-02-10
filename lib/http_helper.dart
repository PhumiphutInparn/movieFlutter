import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'movie.dart';

class HttpHelper {
  final String urlKey = 'api_key=8d07879b26b999decb0cb26b4933c985';
  final String urlBase = 'https://api.themoviedb.org/3/movie';
  final String urlUpcoming = '/upcoming?';
  final String urlTopRated = '/top_rated?';
  final String urlSearchBase = 'https://api.themoviedb.org/3/search/movie?';

  Future<List<Movie>?> getUpcoming() async {
    final String url = '$urlBase$urlUpcoming$urlKey&language=en-US';
    return _fetch(url);
  }

  Future<List<Movie>?> getTopRated() async {
    final String url = '$urlBase$urlTopRated$urlKey&language=en-US';
    return _fetch(url);
  }

  Future<List<Movie>?> findMovies(String title) async {
    final String url = '$urlSearchBase$urlKey&query=$title';
    return _fetch(url);
  }

  Future<List<Movie>?> _fetch(String url) async {
    try {
      http.Response result = await http.get(Uri.parse(url));
      if (result.statusCode == HttpStatus.ok) {
        final jsonResponse = json.decode(result.body);
        final moviesMap = jsonResponse['results'];
        List<Movie> movies =
            List<Movie>.from(moviesMap.map((i) => Movie.fromJson(i)));
        return movies;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getCast(int movieId) async {
    final String urlCast = '$urlBase/$movieId/credits?$urlKey';
    try {
      http.Response result = await http.get(Uri.parse(urlCast));
      if (result.statusCode == HttpStatus.ok) {
        final jsonResponse = json.decode(result.body);
        final castMap = jsonResponse['cast'];
        return List<Map<String, dynamic>>.from(castMap);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}