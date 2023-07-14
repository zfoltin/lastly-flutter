import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../settings/settings_view.dart';
import '../models.dart';
import '../details_screen/details_view.dart';

/// Main screen loading all the albums from jsonplaceholder
class MainScreenView extends StatefulWidget {
  const MainScreenView({super.key});

  static const routeName = '/';

  @override
  State<MainScreenView> createState() => _MainScreenViewState();
}

class _MainScreenViewState extends State<MainScreenView> {
  late Future<List<Album>> futureAlbums;

  @override
  void initState() {
    super.initState();
    futureAlbums = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Lastly Flutter'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Navigate to the settings page. If the user leaves and returns
                // to the app after it has been killed while running in the
                // background, the navigation stack is restored.
                Navigator.restorablePushNamed(context, SettingsView.routeName);
              },
            ),
          ],
        ),
        body: FutureBuilder<List<Album>>(
            future: futureAlbums,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var albums = snapshot.data!;
                return ListView.builder(
                  // Providing a restorationId allows the ListView to restore the
                  // scroll position when a user leaves and returns to the app after it
                  // has been killed while running in the background.
                  restorationId: 'sampleItemListView',
                  itemCount: albums.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = albums[index];

                    return ListTile(
                        title: Text(item.title),
                        leading: const CircleAvatar(
                          // Display the Flutter Logo image asset.
                          foregroundImage:
                              AssetImage('assets/images/flutter_logo.png'),
                        ),
                        onTap: () {
                          // Navigate to the details page. If the user leaves and returns to
                          // the app after it has been killed while running in the
                          // background, the navigation stack is restored.
                          Navigator.restorablePushNamed(
                              context, SampleItemDetailsView.routeName,
                              arguments: item.toJson());
                        });
                  },
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const Center(child: CircularProgressIndicator());
            }));
  }

  Future<List<Album>> loadData() async {
    var dataURL = Uri.parse('https://jsonplaceholder.typicode.com/albums');
    http.Response response = await http.get(dataURL);
    // TODO: remove - for now, pretend it takes a little longer
    await Future.delayed(const Duration(milliseconds: 500));
    if (response.statusCode == 200) {
      List<dynamic> result = jsonDecode(response.body);
      return result.map((json) => Album.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load albums');
    }
  }
}
