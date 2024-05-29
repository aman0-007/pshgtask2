import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: '274695880965-v3alm5fdm39gubu9skv39iu09dtg0eab.apps.googleusercontent.com',
    scopes: [
      'email',
      'profile',
    ],
  );

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential = await _auth.signInWithCredential(credential);
        return userCredential.user;
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to sign in with Google')),
      );
    }
    return null;
  }

  Future<void> registerWithEmailAndPassword(BuildContext context,String email, String password,String contactNumber,String name) async {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration successful'),
        ),
      );

      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
        'email': email,
        'name': name,
        'contactNumber': contactNumber,
      });

  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Sign-in successful, return the user
      return userCredential.user;
    } catch (e) {
      // Sign-in failed, return null and handle the error (e.g., display an error message)
      print('Sign-in failed: $e');
      return null;
    }
  }
}
