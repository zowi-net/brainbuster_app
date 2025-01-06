import 'package:brainbuster/pages/home.dart';
import 'package:brainbuster/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body : StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
         builder: (context, snapshot) {
           //user is loggin
           if(snapshot.hasData){
            return  HomePage();
           }
           //user is not loggin
            else{
              return LoginPage();
            }
         }
         
         )
    );
  }
}