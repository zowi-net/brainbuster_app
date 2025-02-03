import 'package:brainbuster/pages/screens/userscreen/quizlogic/brains/braincategory.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:brainbuster/pages/security/login_page.dart';
import 'package:brainbuster/pages/security/sigup_page.dart';
import 'package:brainbuster/pages/screens/adminscreen/homescreen/adminscreen.dart';
import 'package:brainbuster/pages/screens/userscreen/homescreen/userscreen.dart';
import 'package:brainbuster/pages/screens/userscreen/quizlogic/quiz.dart';
import 'package:brainbuster/pages/screens/userscreen/settings/settings.dart';
import 'package:brainbuster/pages/screens/userscreen/settings/help_center.dart';
import 'package:brainbuster/pages/screens/userscreen/settings/privacy.dart';
import 'package:brainbuster/pages/security/passwordreset.dart';
import 'package:brainbuster/pages/screens/userscreen/result/result.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
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
      initialRoute: '/loginpage',
      routes: {
        '/loginpage': (context) =>  LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/passwordreset': (context) => const PasswordResetScreen(),
        '/adminscreen': (context) => const AdminnistratorDashboard(),
        '/userscreen': (context) =>  UserScreenDashBoard(),
        '/braincategory': (context) =>  const Braincategory(),
        '/quiz': (context) => const QuizPage(),
        '/setting': (context) => const SettingPage(),
        '/privacyandterms': (context) => const PrivacyAndTermsPage(),
        '/helpcenter': (context) => const HelpCenterScreen(),
        '/result': (context) => const ResultPage(score: 0),        
        // '/questionlist': (context) => QuestionList(categoryId: ''),
      },
    );
  }
}

