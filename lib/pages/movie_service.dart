import 'package:cloud_firestore/cloud_firestore.dart';

class MovieService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addMovie({
    required String title,
    required String genre,
    required double rating,
    required String description,
  }) async {
    try {
      await _db.collection('movies').add({
        'title': title,
        'genre': genre,
        'rating': rating,
        'description': description,
        'created_at': Timestamp.now(),
      });
    } catch (e) {
      print("Error adding movie: $e");
    }
  }
}
