import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

// Snackbar to display wrong credentials
  void showWrongCredentialsSnackBar(BuildContext wrgcontext) {
    ScaffoldMessenger.of(wrgcontext).showSnackBar(
      const SnackBar(
        content: Text('Wrong email or password'),
        backgroundColor:Color.fromRGBO(241, 58, 90, 1), // Indicate an error
        duration: Duration(seconds: 3), // Visible for 3 seconds
      ),
    );
  }
// Function to sign in the user
  void signUserIn(
      BuildContext context, TextEditingController emailController, TextEditingController passwordController) async {
// Show loading dialog
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
// Authenticate user
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

// Check if email is verified
      User? user = userCredential.user;
      if (user != null && !user.emailVerified) {
        Navigator.pop(context);
// Email is not verified, redirect to EmailVerificationPage
        Navigator.pushReplacementNamed(context, '/verification');
        return;
      }

// Fetch user role from Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      String role = userDoc['role'];

// Close loading dialog
      Navigator.pop(context);

// Navigate to respective dashboard based on the role
      Navigator.pushNamed(context, role == 'admin' ? '/adminscreen' : '/userscreen');
    } on FirebaseAuthException catch (e) {
// Close loading dialog
      Navigator.pop(context);

// Handle errors
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showWrongCredentialsSnackBar(context); // Use the Snackbar function
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: ${e.message}'),
            backgroundColor:  const Color.fromRGBO(241, 58, 90, 1),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  const Color.fromRGBO(221, 220, 220, 6),
      bottomNavigationBar:Padding(
        padding:  const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
        //Register button
          Text(
            'Don\'t have an account yet?',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 20,
              color: Colors.grey[600],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/signup');
            },
            child: const Text(
              'Register Now',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 19,
                color:  Color.fromRGBO(241, 58, 90, 1),
              ),
            ),
          ),
        ],
            ),
      ), 
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0,bottom: 16.0,top: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Lottie.asset('assets/hm.json', width: 300, height: 200),
                const Text(
                  'Welcome to Brainbuster',
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color:  Color.fromRGBO(117, 74, 73, 5),
                  ),
                ),
                Text(
                  'App to test your knowledge',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 50),
// email field
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    focusColor: Colors.white,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    hintText: '  Email',
                    hintStyle: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.grey[500],
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
// password field
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    focusColor: Colors.white,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    hintText: '  Password',
                    hintStyle: TextStyle(
                      fontFamily: 'poppins',
                      color: Colors.grey[500],
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
// signIn button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    width: double.infinity,
                    height: 90,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(117, 74, 73, 5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            signUserIn(context, emailController, passwordController);
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Color.fromRGBO(255, 255, 255, 1),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
//forgot password
                Padding(
                  padding: const EdgeInsets.only(left: 150, top: 9),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/passwordreset');
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Color.fromRGBO(241, 58, 90, 1), fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

