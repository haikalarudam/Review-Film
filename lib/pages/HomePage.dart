import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tugas_mobile/widgets/AppBarWidget.dart';
import 'package:tugas_mobile/widgets/DrawerWidget.dart';
import 'package:tugas_mobile/widgets/Kategoriwidget.dart';
import 'package:tugas_mobile/widgets/PopulerWidget.dart';
import 'package:tugas_mobile/widgets/TerbaruWidget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          AppBarWidget(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 252, 254, 255),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: const Color.fromARGB(255, 41, 17, 146)
                            .withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0, 3))
                  ]),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.search,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                    Container(
                      height: 50,
                      width: 300,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        child: TextFormField(
                          controller: _searchController,
                          onChanged: (value) {
                            // setState diperlukan untuk memberitahu Flutter bahwa state telah berubah
                            setState(() {});
                          },
                          decoration: InputDecoration(
                              hintText: "Silahkan cari apa yang anda cari",
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // kategori
          Padding(
            padding: EdgeInsets.only(top: 20, left: 10),
            child: Text(
              "Kategori",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),

          KategoriWidget(),

          // Populer item
          Padding(
            padding: EdgeInsets.only(top: 20, left: 10),
            child: Text(
              "Populer",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),

          PopulerWidget(),

          Padding(
            padding: EdgeInsets.only(top: 20, left: 10),
            child: Text(
              "Terbaru",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),

          TerbaruWidget(searchQuery: _searchController.text),
        ],
      ),
      drawer: DrawerWidget(),
    );
  }
}
