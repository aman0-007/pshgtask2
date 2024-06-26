import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QuerySolvingScreen extends StatefulWidget {
  final String queryType;
  final String queryExplanation;
  final String userId;
  final String userName;

  const QuerySolvingScreen({
    super.key,
    required this.queryType,
    required this.queryExplanation,
    required this.userId,
    required this.userName,
  });

  @override
  _QuerySolvingScreenState createState() => _QuerySolvingScreenState();
}

class _QuerySolvingScreenState extends State<QuerySolvingScreen> {
  final TextEditingController _solutionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solve Query'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User ID:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(widget.userId),
            const SizedBox(height: 10),
            const Text(
              'User Name:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(widget.userName),
            const SizedBox(height: 10),
            const Text(
              'Query Type:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(widget.queryType),
            const SizedBox(height: 10),
            const Text(
              'Query Explanation:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(widget.queryExplanation),
            const SizedBox(height: 20),
            const Text(
              'Your Solution:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: _solutionController,
              maxLines: 10,
              decoration: const InputDecoration(
                hintText: 'Write your solution here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {

                String solution = _solutionController.text;
                FirebaseFirestore.instance
                    .collection('solved_queries')
                    .add({
                  'userId': widget.userId,
                  'queryType': widget.queryType,
                  'queryExplanation': widget.queryExplanation,
                  'solution': solution,
                })
                    .then((docRef) {
                  print('Solved query added successfully to solved_queries collection');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Explanation submitted successfully')),
                  );

                  _solutionController.clear();
                  FirebaseFirestore.instance
                      .collection('queries')
                      .where('userId', isEqualTo: widget.userId)
                      .where('queryType', isEqualTo: widget.queryType)
                      .where('queryExplanation', isEqualTo: widget.queryExplanation)
                      .get()
                      .then((querySnapshot) {
                    for (var doc in querySnapshot.docs) {
                      doc.reference.delete().then((_) {
                        // Query removed successfully from 'queries' collection
                        print('Query removed successfully from queries collection');
                      }).catchError((error) {
                        // Handle error
                        print('Failed to remove query from queries collection: $error');
                      });
                    }
                  }).catchError((error) {
                    // Handle error
                    print('Failed to find query to remove from queries collection: $error');
                  });
                })
                    .catchError((error) {
                  // Handle error
                  print('Failed to add solved query to solved_queries collection: $error');
                });
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
