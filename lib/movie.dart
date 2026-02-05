class Movie {
  int? id;
  String? title;
  double? voteAverage;
  String? releaseDate;
  String? overview;
  String? posterPath;

  Movie(this.id, this.title, this.voteAverage, this.releaseDate, this.overview,
      this.posterPath);

  // ตัวแปลงข้อมูลจาก JSON ของเว็บ มาเป็นตัวแปรของเรา
  Movie.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'];
    title = parsedJson['title'];
    // แปลงเป็น double ให้ปลอดภัย เพราะบางทีค่าคะแนนมาเป็น int
    voteAverage = (parsedJson['vote_average'] as num?)?.toDouble();
    releaseDate = parsedJson['release_date'];
    overview = parsedJson['overview'];
    posterPath = parsedJson['poster_path'];
  }
}