import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QuerySolvingScreen extends StatefulWidget {
  final String queryType;
  final String queryExplanation;
  final String userId;
  final String userName;

  const QuerySolvingScreen({
    Key? key,
    required this.queryType,
    required this.queryExplanation,
    required this.userId,
    required this.userName,
  }) : super(key: key);

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
              style: const TextStyle(fontWeight: FontWeight.bold),
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
              maxLines: 10, // Adjust the number of lines as needed
              decoration: const InputDecoration(
                hintText: 'Write your solution here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Get the solution from the controller
                String solution = _solutionController.text;

                // Add the solved query to the 'solved_queries' collection
                FirebaseFirestore.instance
                    .collection('solved_queries')
                    .add({
                  'userId': widget.userId,
                  'queryType': widget.queryType,
                  'queryExplanation': widget.queryExplanation,
                  'solution': solution,
                })
                    .then((docRef) {
                  // Solved query added successfully to 'solved_queries' collection
                  print('Solved query added successfully to solved_queries collection');
                  // Show Snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Explanation submitted successfully')),
                  );
                  // Clear solution field
                  _solutionController.clear();

                  // Remove the solved query from the 'queries' collection
                  FirebaseFirestore.instance
                      .collection('queries')
                      .where('userId', isEqualTo: widget.userId)
                      .where('queryType', isEqualTo: widget.queryType)
                      .where('queryExplanation', isEqualTo: widget.queryExplanation)
                      .get()
                      .then((querySnapshot) {
                    querySnapshot.docs.forEach((doc) {
                      doc.reference.delete().then((_) {
                        // Query removed successfully from 'queries' collection
                        print('Query removed successfully from queries collection');
                      }).catchError((error) {
                        // Handle error
                        print('Failed to remove query from queries collection: $error');
                      });
                    });
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
