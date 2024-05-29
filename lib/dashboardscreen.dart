import 'package:flutter/material.dart';
import 'package:pshgtask2/allqueries.dart';
import 'package:pshgtask2/loginscreen.dart';
import 'package:pshgtask2/profile.dart';
import 'package:pshgtask2/query.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
            fontFamily: 'OpenSans',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF6CA8F1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF6CA8F1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
                    radius: 30,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Username', // Replace with Firebase username
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: const Text('Profile', style: TextStyle(color: Colors.blue)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.query_builder, color: Colors.blue),
              title: const Text('Add Query', style: TextStyle(color: Colors.blue)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QueriesPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.query_stats, color: Colors.blue),
              title: const Text('All Queries', style: TextStyle(color: Colors.blue)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AllQueriesPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.blue),
              title: const Text('Settings', style: TextStyle(color: Colors.blue)),
              onTap: () {
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.blue),
              title: const Text('Sign Out', style: TextStyle(color: Colors.blue)),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()), // Replace YourProfilePage with your profile page widget
                );
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF73AEF5),
                  Color(0xFF61A4F1),
                  Color(0xFF478DE0),
                  Color(0xFF398AE5),
                ],
                stops: [0.1, 0.4, 0.7, 0.9],
              ),
            ),
          ),
          const SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 120.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Welcome to the Homepage',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
