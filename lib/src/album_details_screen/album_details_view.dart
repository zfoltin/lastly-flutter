import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models.dart';
import 'photo_list_item_view.dart';

/// Displays detailed information about an Album.
class AlbumDetailsView extends StatefulWidget {
  const AlbumDetailsView({super.key, required this.album});

  static const routeName = '/album';

  final Album album;

  @override
  State<AlbumDetailsView> createState() => _AlbumDetailsViewState();
}

class _AlbumDetailsViewState extends State<AlbumDetailsView> {
  late Future<List<Photo>> futurePhotos;

  @override
  void initState() {
    super.initState();
    futurePhotos = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Album details'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
        child: Column(
          children: [
            _AlbumDetailsHeader(
              id: widget.album.id,
              title: widget.album.title,
              rating: widget.album.rating,
            ),
            Expanded(
              child: FutureBuilder(
                  future: futurePhotos,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var photos = snapshot.data!;
                      return ListView.builder(
                        padding: const EdgeInsets.only(top: 4.0),
                        itemCount: photos.length,
                        itemBuilder: (BuildContext context, int index) {
                          return PhotoListItemView(photo: photos[index]);
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    // By default, show a loading spinner.
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: const CircularProgressIndicator(),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Photo>> loadData() async {
    var dataURL = Uri.parse(
        'https://jsonplaceholder.typicode.com/albums/${widget.album.id}/photos');
    http.Response response = await http.get(dataURL);
    if (response.statusCode == 200) {
      List<dynamic> result = jsonDecode(response.body);
      return result.map((json) => Photo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load photos');
    }
  }
}

class _AlbumDetailsHeader extends StatelessWidget {
  const _AlbumDetailsHeader(
      {Key? key, required this.id, required this.title, required this.rating})
      : super(key: key);

  final int id;
  final String title;
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Id: ${id.toString()}',
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(width: 8.0),
            _generateStars(rating),
          ],
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }

  static final _redWholeStar = Icon(
    Icons.star,
    color: Colors.red[500],
  );
  static final _redHalfStar = Icon(
    Icons.star_half,
    color: Colors.red[500],
  );
  static const _emptyStar = Icon(
    Icons.star_border,
    color: Colors.black26,
  );

  Widget _generateStars(double num) {
    num = max(min(num, 5), 0);
    var wholeStars = num.floor();
    var halfStars = num % 1 >= 0.5 ? 1 : 0;
    var emptyStars = 5 - wholeStars - halfStars;

    return Row(children: [
      ...List.generate(wholeStars, (i) => _redWholeStar),
      ...List.generate(halfStars, (i) => _redHalfStar),
      ...List.generate(emptyStars, (i) => _emptyStar),
    ]);
  }
}
