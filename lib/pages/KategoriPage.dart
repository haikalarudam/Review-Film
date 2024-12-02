import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class KategoriPage extends StatelessWidget {
  const KategoriPage({
    Key? key,
    required this.kategori,
    required this.movies,
  }) : super(key: key);

  final String kategori;
  final List<Map<String, dynamic>> movies;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyanAccent[700],
        title: Row(
          children: [
            Text(
              "Kategori: $kategori",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: movies.map<Widget>((data) {
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
                          'https://image.tmdb.org/t/p/w185${data['poster_path']}',
                          height: 120,
                          width: 100,
                        ),
                      ),
                      Container(
                        width: 230,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              data['title'] ?? '',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            Text(
                              kategori,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow[700],
                                  size: 17,
                                ),
                                Text(
                                  '${(data['vote_average'] as num).toString()}%',
                                  style: TextStyle(fontSize: 13),
                                )
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Navigasi ke ItemPage dengan mengirimkan movieId
                                Navigator.pushNamed(
                                  context,
                                  "itemPage",
                                  arguments: {
                                    'movieId': data['id'], // id film dari data
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
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
