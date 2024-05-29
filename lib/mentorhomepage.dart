import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllQueriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Queries'),
      ),
      body: QuerySnapshotListView(),
    );
  }
}


class AllUsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Error');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Loading indicator
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['name']), // Assuming 'name' is the field for user's name
                subtitle: Text(data['email']), // Assuming 'email' is the field for user's email
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
class QuerySnapshotListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('queries').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        final List<DocumentSnapshot> documents = snapshot.data!.docs;
        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final Map<String, dynamic> data = documents[index].data() as Map<String, dynamic>;
            final String queryType = data['queryType'] ?? 'No type';
            final String queryExplanation = data['queryExplanation'] ?? 'No explanation';
            return ListTile(
              title: Text(queryType),
              subtitle: Text(queryExplanation),
              onTap: () {
                _showConfirmationDialog(context, documents[index].reference);
              },
            );
          },
        );
      },
    );
  }

  void _showConfirmationDialog(BuildContext context, DocumentReference queryRef) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: Text('Will you solve this query?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                // Delete the query from Firestore
                queryRef.delete();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}

class MentorHomepage extends StatefulWidget {
  const MentorHomepage({Key? key}) : super(key: key);

  @override
  _MentorHomepageState createState() => _MentorHomepageState();
}

class _MentorHomepageState extends State<MentorHomepage> {
  int _selectedIndex = 0;

  static  List<Widget> _screens = [
    AllQueriesScreen(),
    AllUsersScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'All Queries',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'All Users',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: const Color(0xFF73AEF5),
      scaffoldBackgroundColor: const Color(0xFF73AEF5),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF73AEF5),
      ),
    ),
    home: const MentorHomepage(),
  ));
}
