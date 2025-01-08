// import 'package:brainbuster/pages/quiz.dart';
import 'package:brainbuster/pages/admin_page.dart';
import 'package:brainbuster/pages/auth_page.dart';
import 'package:brainbuster/pages/help_center.dart';
import 'package:brainbuster/pages/login_page.dart';
import 'package:brainbuster/pages/privacy.dart';
import 'package:brainbuster/pages/sigup_page.dart';
import 'package:brainbuster/pages/userscreen.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:unicons/unicons.dart';
import 'firebase_options.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:brainbuster/pages/result.dart';
import 'package:flutter/material.dart';
import 'package:brainbuster/pages/home.dart';
import 'package:brainbuster/pages/quiz.dart';
import 'package:brainbuster/pages/profile.dart';
// import 'package:brainbuster/pages/auth_page.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
   // Creamy beige color code

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const  AuthPage(),//starter app section
        '/loginpage': (context) =>  LoginPage(),//login secttion
        '/signup': (context) => const SignUpPage(),//create account section
        '/adminscreen': (context) =>  AdminScreen(),//home page section admin screen
        '/userscreen': (context) =>   UserScreen(),//user screen section
        '/quiz': (context) =>  const QuizPage(),//quiz section
        // '/result': (context) => const ResultPage(score: 0,),
        '/profile': (context) => const ProfilePage(),//profile for user section
        '/admin': (context) => const AdminPage(), //where questions and answers are been placed
        '/privacy': (context) => const PrivacyAndTermsPage(),//privacy and terms sections
        '/helpcenter': (context) => const HelpCenterPage(),//for help with problems solutions
        // HomePage()
      }, 
    );
  }
}