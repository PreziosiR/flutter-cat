import 'dart:convert';
import 'dart:io';

import "package:flutter/material.dart";
import 'package:http/http.dart' as http;

void main() {
  runApp(const Core());
}

class Core extends StatefulWidget {
  const Core({Key? key}) : super(key: key);

  @override
  State<Core> createState() => _CoreState();
}

class _CoreState extends State<Core> {
  late Future<Album> futureAlbum;
  late Future<Cat> futureCat;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
    futureCat = fetchCat();
  }

  Future<Album> fetchAlbum() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print('success');
      return Album.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<Cat> fetchCat() async {
    const String url = "https://api.thecatapi.com/v1/images/search";
    final response = await http.get(
        Uri.parse('https://api.thecatapi.com/v1/images/search'),
        headers: {"x-api-key":"1a65013e-779b-409c-a466-3572ea6cd452"});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print('cat success');
      return Cat.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load cat');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            title: const Text("A cool app"),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => {futureCat = fetchCat()},
          ),
          body: FutureBuilder<Cat>(
              future: futureCat,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data!.width.toString());
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              })),
    );
  }
}

class Cat {
  final breeds = <String>[];
  late final String id;
  late final String url;
  final int width;
  final int height;

  Cat(
      {
      //required this.breeds,
      required this.id,
      required this.url,
      required this.width,
      required this.height});

  factory Cat.fromJson(Map<String, dynamic> json) {
    return Cat(
      id: json['id'],
      url: json['url'],
      width: json['width'],
      height: json['height'],
    );
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}
