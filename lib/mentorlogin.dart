import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pshgtask2/mentorhomepage.dart';
import 'package:pshgtask2/authentication.dart';



const kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

const kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: const Color(0xFF6CA8F1),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: const [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

class MentorLoginPage extends StatelessWidget {
  final Authentication _authentication = Authentication();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  MentorLoginPage({super.key});

  bool _validateEmail(String email) {

    RegExp emailRegExp = RegExp(
        r'^[a-zA-Z0-9._%+-]+@(gmail\.com|outlook\.com|ves\.ac\.in)$');
    return emailRegExp.hasMatch(email);
  }

  bool _validatePassword(String password) {

    RegExp passwordRegExp = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$&*])(.{8,})$');
    return passwordRegExp.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return Container(
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Mentor Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30.0),
                _buildEmailTF(context),
                const SizedBox(height: 30.0),
                _buildPasswordTF(context),
                const SizedBox(height: 30.0),
                _buildVerifyButton(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmailTF(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Email',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          width: MediaQuery.of(context).size.width * 0.8, // Adjust width as needed
          child: TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your Email',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Password',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          width: MediaQuery.of(context).size.width * 0.8, // Adjust width as needed
          child: TextField(
            controller: _passwordController,
            obscureText: true,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerifyButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0,horizontal: 60),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          String email = _emailController.text;
          String password = _passwordController.text;

          if (_validateEmail(email) && _validatePassword(password)) {
            // Attempt to sign in
            User? user = await _authentication.signInWithEmailAndPassword(email, password);
            if (user != null) {
              // Sign-in successful, navigate to dashboard
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) =>  const MentorHomepage()),
              );
            } else {
              // Sign-in failed, show error message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Invalid email or password')),
              );
            }
          } else {
            // Show error message with criteria for login
            String errorMessage = '';
            if (!_validateEmail(email)) {
              errorMessage +=
              'Invalid email format. Please use a valid email address.\n';
            }
            if (!_validatePassword(password)) {
              errorMessage +=
              'Invalid password format. Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, one digit, and one special character.\n';
            }
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ));
          }
        },
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          backgroundColor: Colors.white,
          padding: const EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: const Text(
          'VERIFY',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }
}
