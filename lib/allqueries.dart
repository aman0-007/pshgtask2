import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllQueriesPage extends StatefulWidget {
  const AllQueriesPage({Key? key}) : super(key: key);

  @override
  _AllQueriesPageState createState() => _AllQueriesPageState();
}

class _AllQueriesPageState extends State<AllQueriesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late List<QueryDocumentSnapshot> _queries = [];
  late Map<String, dynamic> _userData = {}; // To store user data

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch user data
    _fetchQueries();
  }

  Future<void> _fetchUserData() async {
    // Assuming user is logged in and you have access to user's uid
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      DocumentSnapshot userDataSnapshot = await _firestore.collection('users').doc(uid).get();
      setState(() {
        _userData = userDataSnapshot.data() as Map<String, dynamic>;
      });
    }
  }

  Future<void> _fetchQueries() async {
    // Assuming user is logged in and you have access to user's uid
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      QuerySnapshot querySnapshot = await _firestore.collection('users').doc(uid).collection('queries').get();

      setState(() {
        _queries = querySnapshot.docs;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Queries'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1), // Updated background color
        ),
        child: _queries.isNotEmpty
            ? ListView.builder(
          itemCount: _queries.length,
          itemBuilder: (context, index) {
            var data = _queries[index].data() as Map<String, dynamic>;
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['queryType'],
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      data['queryExplanation'],
                      style: const TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'User ID: ${_userData['userId']}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Name: ${_userData['name']}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                tileColor: Colors.blue.withOpacity(0.3), // Light blue color for ListTile
                // You can add more fields as needed
              ),
            );
          },
        )
            : const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}