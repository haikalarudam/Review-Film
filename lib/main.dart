import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tugas_mobile/pages/HomePage.dart';
import 'package:tugas_mobile/pages/ItemPage.dart';
import 'package:tugas_mobile/pages/KategoriPage.dart';

late final FirebaseApp app;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  app = await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyCrV25SNFkQC6DrY13W9QWx11MmehnGPPw",
          appId: "1:632008770953:android:37f76bd702d8ea3041cd58",
          messagingSenderId: "632008770953",
          projectId: "mobile-50b39"));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.blueGrey),
      home: HomePage(), // Pastikan ada halaman awal
      onGenerateRoute: (settings) {
        if (settings.name == "itemPage") {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
              builder: (context) => ItemPage(movieId: args['movieId']));
        }
        if (settings.name == "kategoriPage") {
          return MaterialPageRoute(
              builder: (context) => KategoriPage(
                    kategori: "",
                    movies: [],
                  ));
        }
        return null; // Rute fallback
      },
    );
  }
}
