import 'package:flutter/material.dart';
import 'package:clippy_flutter/arc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tugas_mobile/widgets/DrawerWidget.dart';
import 'package:tugas_mobile/widgets/ItemNavBar.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({Key? key, required this.movieId}) : super(key: key);

  final int movieId;

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  late Future<Map<String, dynamic>> movieData;

  @override
  void initState() {
    super.initState();
    movieData = fetchMovieData(widget.movieId);
  }

  Future<Map<String, dynamic>> fetchMovieData(int movieId) async {
    final String apiKey = '4a683e097eca54bd3aace2b98db17910';
    final String baseUrl = 'https://api.themoviedb.org/3';
    final response = await http.get(
      Uri.parse(
          '$baseUrl/movie/$movieId?api_key=$apiKey'), //metode asinkron yang mengambil data film dari API menggunakan http.get.
    );

    if (response.statusCode == 200) {
      final dynamic jsonData = json.decode(response.body);

      if (jsonData is Map<String, dynamic>) {
        return jsonData;
      } else {
        throw Exception('Invalid data format');
      }
    } else {
      throw Exception('Failed to load movie data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 5),
        child: FutureBuilder<Map<String, dynamic>>(
          future: movieData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final movie = snapshot.data!;

            return ListView(
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                    height: 300,
                  ),
                ),
                Arc(
                  edge: Edge.TOP,
                  arcType: ArcType.CONVEY,
                  height: 30,
                  child: Container(
                    width: double.infinity,
                    color: Colors.grey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 40, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellow[700],
                                      size: 19,
                                    ),
                                    Text(
                                      '${(movie['vote_average'] as num).toString()}%',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Icon(
                                      Icons.access_alarm,
                                      size: 20,
                                    ),
                                    Text(
                                      "Release Date: ${movie['release_date']}",
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 10,
                              bottom: 20,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  movie['title'],
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: Text(
                              movie['overview'],
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.design_services_outlined),
                                Text(
                                  "Detail :",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.justify,
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 5,
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.language),
                                Text(
                                  "Original Language : ${movie['original_language'] ?? 'Unknown'}",
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.people),
                                Expanded(
                                  child: Text(
                                    "number of viewers : ${movie['popularity'] ?? 'Unknown'}",
                                    textAlign: TextAlign.justify,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.category_outlined),
                                Expanded(
                                  child: Text(
                                    "Genre : ${movie['genres'].map((genre) => genre['name']).join(', ')}",
                                    textAlign: TextAlign.justify,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
      drawer: DrawerWidget(),
      bottomNavigationBar: ItemNavBar(),
    );
  }
}
