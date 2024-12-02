import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tugas_mobile/pages/HomePage.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget({super.key});

  @override
  FirebaseAuth _auth = FirebaseAuth.instance;
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
              ),
              accountName: Text(
                user?.displayName ?? "",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(user?.email ?? ""),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("assets/images/5556468.png"),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
            child: ListTile(
              leading: Icon(
                CupertinoIcons.home,
                color: const Color.fromARGB(255, 24, 171, 245),
              ),
              title: Text(
                "Home",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
