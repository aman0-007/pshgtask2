import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/mybusinessverifications/v1.dart';
import 'package:pshgtask2/querysolvingscreen.dart';

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

class SolvedQueriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solved Queries'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('solved_queries').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No solved queries yet.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text('Query Type: ${data['queryType']}'),
                subtitle: Text('User ID: ${data['userId']}'),
                trailing: Icon(Icons.check_circle, color: Colors.green),
                onTap: () {
                  // Add functionality to view details if needed
                },
              );
            },
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
            final String userId = data['userId'];
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return ListTile(
                    title: Text(queryType),
                    subtitle: Text(queryExplanation),
                  );
                }
                if (userSnapshot.hasError) {
                  return ListTile(
                    title: Text(queryType),
                    subtitle: Text(queryExplanation),
                  );
                }
                final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                final userName = userData['name'];
                final userEmail = userData['email']; // Add this line to fetch user email
                return ListTile(
                  title: Text(queryType),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(queryExplanation),
                      Text('User ID: $userId'),
                      Text('Name: $userName'), // Display user's name
                      Text('Email: $userEmail'), // Display user's email
                    ],
                  ),
                  onTap: () {
                    _showConfirmationDialog(context, documents[index].reference, queryType, queryExplanation, userId, userName);
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  void _showConfirmationDialog(BuildContext context, DocumentReference queryRef, String queryType, String queryExplanation, String userId, String userName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const Text('Will you solve this query?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                // Navigate to the solving screen
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => QuerySolvingScreen(
                    queryType: queryType,
                    queryExplanation: queryExplanation,
                    userId: userId, // Pass user ID
                    userName: userName,
                  ),
                ));
                // You can optionally perform other actions here, such as updating the query status
              },
              child: const Text('Yes'),
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
    SolvedQueriesScreen(),
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
          ),BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Solved Queries',
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
