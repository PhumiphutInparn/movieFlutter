import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'movie.dart';

class HttpHelper {
  // ---------------------------------------------------------
  // ใส่ API Key ที่คุณได้มา ตรงเลข 1234... นี้เลยครับ
  // อย่าลบ 'api_key=' ข้างหน้าทิ้งนะครับ
  final String urlKey = 'api_key=8d07879b26b999decb0cb26b4933c985'; 
  // ---------------------------------------------------------
  
  final String urlBase = 'https://api.themoviedb.org/3/movie';
  final String urlUpcoming = '/upcoming?';
  final String urlLanguage = '&language=en-US';

  Future<List<Movie>?> getUpcoming() async {
    // รวมร่าง URL ทั้งหมดเข้าด้วยกัน
    final String upcoming = urlBase + urlUpcoming + urlKey + urlLanguage;
    
    // เชื่อมต่ออินเทอร์เน็ตเพื่อดึงข้อมูล (ใช้ Uri.parse ตามแบบใหม่)
    http.Response result = await http.get(Uri.parse(upcoming));

    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      final moviesMap = jsonResponse['results'];
      
      // แปลงข้อมูลที่ได้มาเป็น List ของ Movie
      List<Movie> movies = List<Movie>.from(
          moviesMap.map((i) => Movie.fromJson(i)));
      return movies;
    } else {
      // ถ้าเชื่อมต่อไม่ได้ ให้ส่งค่าว่างกลับไป
      return null;
    }
  }
}