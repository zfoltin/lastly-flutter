class Album {
  final int id;
  final String title;

  const Album(this.id, this.title);

  Album.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'];

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title};
  }
}

class Photo {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  const Photo(this.albumId, this.id, this.title, this.url, this.thumbnailUrl);

  Photo.fromJson(Map<String, dynamic> json)
      : albumId = json['albumId'],
        id = json['id'],
        title = json['title'],
        url = json['url'],
        thumbnailUrl = json['thumbnailUrl'];
}
