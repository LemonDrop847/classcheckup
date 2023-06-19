import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/firebase_options.dart';
import 'components/theme.dart' as theme_mgr;
import 'pages/landing.dart';
import 'index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await theme_mgr.AppColors.loadThemeFromPrefs();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> _checkIfUserSignedIn() async {
    return _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme_mgr.AppColors.isDarkTheme
              ? theme_mgr.AppColors.darkTheme
              : theme_mgr.AppColors.lightTheme,
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
      },
    );
  }
}
