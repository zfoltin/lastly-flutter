import 'package:flutter/material.dart';
import 'package:lastly_flutter/src/models.dart';

/// Displays detailed information about an Album.
class SampleItemDetailsView extends StatelessWidget {
  const SampleItemDetailsView({required this.album, super.key});

  static const routeName = '/album';

  final Album album;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Album details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TODO: improve styling here
          Text('Id: ${album.id.toString()}'),
          Text('Title: ${album.title}')
          // TODO: show all the pictures for the album once loaded
        ],
      ),
    );
  }
}
