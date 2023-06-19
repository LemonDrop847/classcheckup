import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'components/colors.dart';
import 'pages/landing.dart';
import 'index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AppColors.loadThemeFromPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppColors.currentTheme,
      home: FutureBuilder(
        future: _checkIfUserSignedIn(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            if (snapshot.hasData && snapshot.data != null) {
              return IndexPage(
                uid: _auth.currentUser!.uid,
              );
            } else {
              return const LandingPage();
            }
          }
        },
      ),
    );
  }

  Future<User?> _checkIfUserSignedIn() async {
    return _auth.currentUser;
  }
}
