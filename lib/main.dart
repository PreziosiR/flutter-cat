import 'dart:convert';

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
  late Future<Cat> futureCat;

  @override
  void initState() {
    super.initState();
    futureCat = fetchCat();
  }

  Future<Cat> fetchCat() async {
    final url = Uri.parse('https://api.thecatapi.com/v1/images/search');
    final response = await http.get(url,
        headers: {"x-api-key": "1a65013e-779b-409c-a466-3572ea6cd452"});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List<dynamic> list = json.decode(response.body);
      print(list);
      Cat cat = Cat.fromJson(list[0]);
      return cat;
      //return Cat.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load cat');
    }
  }

  Future<Cat> updateCat(String image) async {
    final response = await http.get(
        Uri.parse('https://api.thecatapi.com/v1/images/search'),
        headers: {"x-api-key": "1a65013e-779b-409c-a466-3572ea6cd452"});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List<dynamic> list = json.decode(response.body);
      print(list);
      Cat cat = Cat.fromJson(list[0]);
      return cat;
      //return Cat.fromJson(jsonDecode(response.body));
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
            title: const Text("Flutter Cat"),
          ),
          // floatingActionButton: FloatingActionButton(
          //   child: const Icon(Icons.add),
          //   onPressed: () => {futureCat = fetchCat()},
          // ),
          body: FutureBuilder<Cat>(
              future: futureCat,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(snapshot.data!.url, width: 500.0,height: 500.0,),
                        ElevatedButton(
                            onPressed: () => {
                                  setState(() {
                                    futureCat = updateCat(snapshot.data!.url);
                                  })
                                },
                            child: const Icon(Icons.refresh))
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                }
                  return const CircularProgressIndicator();
              })),
    );
  }
}

class Cat {
  List<dynamic> breeds;
  late final String id;
  late final String url;
  final int width;
  final int height;

  Cat(
      {required this.breeds,
      required this.id,
      required this.url,
      required this.width,
      required this.height});

  factory Cat.fromJson(Map<String, dynamic> json) {
    return Cat(
      breeds: json['breeds'],
      id: json['id'],
      url: json['url'],
      width: json['width'],
      height: json['height'],
    );
  }
}
