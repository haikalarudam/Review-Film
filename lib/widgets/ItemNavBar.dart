import 'package:flutter/material.dart';
import 'package:tugas_mobile/pages/HomePage.dart';

class ItemNavBar extends StatelessWidget {
  const ItemNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 70,
        color: Colors.blueGrey,
        child: Row(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
                ;
              },
              child: Row(
                children: [Icon(Icons.home_outlined), Text("Kembali")],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
