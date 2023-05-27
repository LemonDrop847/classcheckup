import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'setup.dart';

class LandingPage extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final String uID;

  LandingPage({super.key, required this.uID});

  void _handleSignIn(BuildContext context) {
    _googleSignIn.signIn().then((GoogleSignInAccount? account) async {
      if (account != null) {
        final googleAuth = await account.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((UserCredential? user) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SetupUser(
                uid: uID,
              ),
            ),
          );
        });
      }
    }).catchError((error) {
      print('Sign-in error: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Landing Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome to MyApp!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _handleSignIn(context),
              child: const Text('Sign in with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
