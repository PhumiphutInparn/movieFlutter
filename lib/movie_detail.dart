import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'movie.dart';
import 'http_helper.dart';

class MovieDetail extends StatefulWidget {
  final Movie movie;
  const MovieDetail(this.movie, {super.key});

  @override
  State<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  HttpHelper helper = HttpHelper();
  List<Map<String, dynamic>>? castList;

  @override
  void initState() {
    super.initState();
    helper.getCast(widget.movie.id!).then((value) {
      setState(() {
        castList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text(widget.movie.title ?? 'Detail')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              height: height / 1.5,
              width: double.infinity,
              child: Hero(
                tag: widget.movie.id.toString(),
                child: (widget.movie.posterPath != null)
                    ? CachedNetworkImage(
                        imageUrl: 'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                        fit: BoxFit.cover,
                      )
                    : Container(color: Colors.grey),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(widget.movie.overview ?? '', style: const TextStyle(fontSize: 16)),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16, bottom: 10),
              child: Align(alignment: Alignment.centerLeft, child: Text('Cast', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
            ),
            SizedBox(
              height: 120,
              child: (castList == null)
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: castList!.length > 10 ? 10 : castList!.length,
                      itemBuilder: (context, index) {
                        var actor = castList![index];
                        return Container(
                          width: 80,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: (actor['profile_path'] != null)
                                    ? CachedNetworkImageProvider('https://image.tmdb.org/t/p/w200${actor['profile_path']}')
                                    : null,
                                child: (actor['profile_path'] == null) ? const Icon(Icons.person) : null,
                              ),
                              const SizedBox(height: 5),
                              Text(actor['name'], textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12))
                            ],
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}