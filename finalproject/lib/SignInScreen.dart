// ignore: duplicate_ignore
// ignore: duplicate_ignore
// ignore: file_names
// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:practicef/splash_screen.dart';

import 'GoogleSignInScreen .dart';
import 'SignUpScreen.dart';

class SignInScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        centerTitle: true,
        backgroundColor: Colors.blue, // Set AppBar background color
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            // Add your logo widget here

            SizedBox(height: 20),
            // Email TextField with icon
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
                prefixIcon: Icon(Icons.email),
              ),
            ),

            SizedBox(height: 16),

            // Password TextField with visibility toggle and icon
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: !_isPasswordVisible,
            ),

            SizedBox(height: 20),

            // Sign In Button with loading indicator
            ElevatedButton(
              onPressed: _isLoading ? null : () => _signIn(),
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text('Sign In'),
            ),

            SizedBox(height: 10),

            // Sign Up Button
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              child: Text('Don\'t have an account? Sign Up'),
            ),

            SizedBox(height: 20),

            // Google Sign-In Button
            ElevatedButton(
              onPressed: _isLoading ? null : () => _googleSignInButtonPressed(),
              child: Text('Sign In with Google'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signIn() async {
    try {
      setState(() {
        _isLoading = true;
      });

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Navigate to the next screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SplashScreen(user: userCredential.user)),
      );
    } catch (e) {
      showErrorDialog('Error during sign in: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _googleSignInButtonPressed() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Your Google Sign-In logic here
      // ...

      // Navigate to the Google Sign-In screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GoogleSignInScreen()),
      );
    } catch (e) {
      showErrorDialog('Error during Google Sign-In: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
