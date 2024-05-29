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

  late List<DocumentSnapshot> _queries = [];

  @override
  void initState() {
    super.initState();
    _fetchQueries();
  }

  Future<void> _fetchQueries() async {
    // Assuming user is logged in and you have access to user's uid
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('queries')
          .get();

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
        backgroundColor: Colors.blue, // Updated app bar color
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1), // Updated background color
        ),
        child: _queries.isNotEmpty
            ? ListView.builder(
          itemCount: _queries.length,
          itemBuilder: (context, index) {
            // Accessing fields from the document data
            var data = _queries[index].data() as Map<String, dynamic>;
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                title: Text(
                  data['queryType'],
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  data['queryExplanation'],
                  style: const TextStyle(color: Colors.white),
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
