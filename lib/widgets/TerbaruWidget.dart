import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TerbaruWidget extends StatefulWidget {
  final String? searchQuery;

  const TerbaruWidget({Key? key, this.searchQuery}) : super(key: key);

  @override
  _TerbaruWidgetState createState() => _TerbaruWidgetState();
}

class _TerbaruWidgetState extends State<TerbaruWidget> {
  final String apiKey = '4a683e097eca54bd3aace2b98db17910';
  final String baseUrl = 'https://api.themoviedb.org/3';

  List<Map<String, dynamic>> movies = [];
  Map<int, String> genreMap = {};

  Future<void> fetchTerbaruMovies() async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/popular?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      setState(() {
        movies = List<Map<String, dynamic>>.from(
          json.decode(response.body)['results'],
        );
      });
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  Future<void> fetchGenres() async {
    final response = await http.get(
      Uri.parse('$baseUrl/genre/movie/list?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final genres = json.decode(response.body)['genres'];
      genreMap = Map.fromIterable(
        genres,
        key: (genre) => genre['id'],
        value: (genre) => genre['name'],
      );
    } else {
      print('Error fetching genres: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTerbaruMovies();
    fetchGenres();
  }

  @override
  Widget build(BuildContext context) {
    // Filter movies berdasarkan searchQuery
    List<Map<String, dynamic>> filteredMovies = movies.where((movie) {
      // Gunakan data yang diinginkan untuk filtering, misalnya 'title'
      String title = movie['title'] ?? '';
      return widget.searchQuery == null ||
          title.toLowerCase().contains(widget.searchQuery!.toLowerCase());
    }).toList();

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: filteredMovies.map((movie) {
            List<int>? genreIds = movie['genre_ids']?.cast<int>();

            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Container(
                width: 380,
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w185${movie['poster_path']}',
                        height: 120,
                        width: 100,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: 230,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              movie['title'],
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              genreIds != null && genreIds.isNotEmpty
                                  ? genreIds
                                      .map((genreId) =>
                                          genreMap[genreId] ?? 'Unknown Genre')
                                      .join(', ')
                                  : 'Unknown Genre',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow[700],
                                  size: 17,
                                ),
                                Text(
                                  '${(movie['vote_average'] as num).toString()}%',
                                  style: TextStyle(fontSize: 13),
                                )
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  "itemPage",
                                  arguments: {
                                    'movieId': movie['id'], // id film dari data
                                  },
                                );
                              },
                              child: Text("Lihat Detail ->"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey,
                                fixedSize: Size(130, 7),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
