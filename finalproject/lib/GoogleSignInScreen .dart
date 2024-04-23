import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInScreen extends StatefulWidget {
  const GoogleSignInScreen({Key? key, User? user}) : super(key: key);

  @override
  State<GoogleSignInScreen> createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  // Specify the type of ValueNotifier to avoid runtime issues
  ValueNotifier<UserCredential?> userCredential = ValueNotifier<UserCredential?>(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google SignIn Screen')),
      body: ValueListenableBuilder<UserCredential?>(
        valueListenable: userCredential,
        builder: (context, value, child) {
          return (value == null)
              ? Center(
            child: ElevatedButton(
              onPressed: () async {
                UserCredential? result = await signInWithGoogle();
                if (result != null) userCredential.value = result;
              },
              child: const Text('Sign In with Google'),
            ),
          )
              : Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 1.5, color: Colors.black54),
                  ),
                  child: Image.network(value.user?.photoURL ?? ''),
                ),
                const SizedBox(height: 20),
                Text(value.user?.displayName ?? ''),
                const SizedBox(height: 20),
                Text(value.user?.email ?? ''),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    bool result = await signOutFromGoogle();
                    if (result) userCredential.value = null;
                  },
                  child: const Text('Logout'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuthException, you might want to show a snackbar or dialog
      print('FirebaseAuthException: $e');
      return null;
    } catch (e) {
      // Handle other exceptions
      print('Exception: $e');
      return null;
    }
  }

  Future<bool> signOutFromGoogle() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuthException, you might want to show a snackbar or dialog
      print('FirebaseAuthException: $e');
      return false;
    } catch (e) {
      // Handle other exceptions
      print('Exception: $e');
      return false;
    }
  }
}
