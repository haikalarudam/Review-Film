import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PopulerWidget extends StatefulWidget {
  const PopulerWidget({Key? key}) : super(key: key);

  @override
  _PopulerWidgetState createState() => _PopulerWidgetState();
}

class _PopulerWidgetState extends State<PopulerWidget> {
  final String apiKey = '4a683e097eca54bd3aace2b98db17910';
  final String baseUrl = 'https://api.themoviedb.org/3';

  Map<int, String> genreMap = {};
  List<Map<String, dynamic>> trendingMovies = [];

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

  Future<void> fetchTrendingMovies() async {
    final response = await http.get(
      Uri.parse('$baseUrl/trending/movie/week?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      setState(() {
        trendingMovies = List<Map<String, dynamic>>.from(
          json.decode(response.body)['results'],
        );
      });
    } else {
      print('Error fetching trending movies: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchGenres();
    fetchTrendingMovies();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: trendingMovies.map((movie) {
          List<int>? genreIds = movie['genre_ids']?.cast<int>();

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 7),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  "itemPage",
                  arguments: {
                    'movieId': movie['id'], // id film dari data
                  },
                );
              },
              child: Container(
                width: 150,
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
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w185${movie['poster_path']}',
                            height: 140,
                            width: 90,
                          ),
                        ),
                      ),
                      Text(
                        movie['title'],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
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
                      SizedBox(height: 7),
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
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
