import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tugas_mobile/pages/KategoriPage.dart';

class KategoriWidget extends StatefulWidget {
  const KategoriWidget({Key? key}) : super(key: key);

  @override
  _KategoriWidgetState createState() => _KategoriWidgetState();
}

class _KategoriWidgetState extends State<KategoriWidget> {
  final String apiKey =
      '4a683e097eca54bd3aace2b98db17910'; // Ganti dengan API key Anda
  final String baseUrl = 'https://api.themoviedb.org/3';

  List<Map<String, dynamic>> categories = [];

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/genre/movie/list?api_key=$apiKey'),
      );

      if (response.statusCode == 200) {
        final genres = List<Map<String, dynamic>>.from(
            json.decode(response.body)['genres']);

        for (final genre in genres) {
          final genreId = genre['id'];
          final genreName = genre['name'];

          final movies = await fetchMoviesByCategory(genreId.toString());

          setState(() {
            categories.add({
              'id': genreId,
              'name': genreName,
              'movies': movies,
            });
          });
        }
      } else {
        print('Error fetching categories: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching categories: $error');
    }
  }

  Future<List<Map<String, dynamic>>> fetchMoviesByCategory(
      String category) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/discover/movie?api_key=$apiKey&with_genres=$category',
        ),
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(
          json.decode(response.body)['results'],
        );
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (error) {
      print('Error fetching movies: $error');
      throw error;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        child: Row(
          children: categories.map((category) {
            final genreName = category['name'];

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: InkWell(
                onTap: () async {
                  final genreId = category['id'];
                  final movies =
                      await fetchMoviesByCategory(genreId.toString());

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KategoriPage(
                        kategori: genreName,
                        movies: movies,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _getRandomColor(),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      genreName,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Color _getRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }
}
