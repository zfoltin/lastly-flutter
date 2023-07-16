import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models.dart';

class PhotoListItemView extends StatelessWidget {
  const PhotoListItemView({super.key, required this.photo});

  final Photo photo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: CachedNetworkImage(
                imageUrl: photo.thumbnailUrl,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(photo.title),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
