import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'landing.dart';
import 'updateprofile.dart';

class ProfilePage extends StatelessWidget {
  final User user;

  ProfilePage({required this.user});

  void _handleSignOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LandingPage()),
      (Route<dynamic> route) => false,
    );
  }

  void _handleUpdateProfile(BuildContext context) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => UpdateProfilePage(user: user)),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.photoURL ?? ''),
              radius: 50,
            ),
            const SizedBox(height: 20),
            Text(
              'Name: ${user.displayName}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Email: ${user.email}',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _handleUpdateProfile(context),
              child: const Text('Update Profile'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _handleSignOut(context),
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
