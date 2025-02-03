import 'package:brainbuster/pages/security/sigup_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';


class LoginPage extends StatelessWidget {
   LoginPage({super.key});
//TextEditingController is used to control the textfield
  // category. Each question is represented as a Map containing the document ID

final TextEditingController passwordController = TextEditingController();

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;



final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();



// Snackbar to display wrong credentials
void showWrongCredentialsSnackBar(BuildContext wrgcontext) {
  ScaffoldMessenger.of(wrgcontext).showSnackBar(
    const SnackBar(
      content: Text('Wrong email or password'),
      backgroundColor: Colors.red, // Indicate an error
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

    // Fetch user role from Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      String role = userDoc['role'];

    // Close loading dialog
    // Navigator.pop(context);

    // Navigate to respective dashboard either admindashboard or user dashboard
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
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                  Lottie.asset('assets/hm.json', width: 300, height: 200),
                Text(
                  'Welcome to Brainbuster',
                  style: GoogleFonts.pacifico(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                Text(
                  'App to test your knowledge',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[600],
                  ),
                ),
        const SizedBox(height: 50),
                
                //email field
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
                      color: Colors.grey[500],
                      fontSize: 20,
                    )
                  ),
                ),
        const SizedBox(height: 20),
        
                //password field
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
                      color: Colors.grey[500],
                      fontSize: 20,
                    )
                  ),
                ),const SizedBox(height: 50),
        
 //signIn button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.brown[700],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            signUserIn(context, emailController, passwordController);
                            // Navigator.pushNamed(context, '/home');
                          
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 150,top: 9),
                  child: TextButton( 
                   onPressed: () { 
                    Navigator.pushNamed(context, '/passwordreset');
                    }, 
                  child: Text('Forgot Password?',style: TextStyle(color: Colors.red[600], fontSize: 19),),
                  ),
                ),
        const SizedBox(height: 50),
        
                //signUp button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      'Don\'t have an account?',
                      style: GoogleFonts.averiaGruesaLibre(
                        fontSize: 20,
                        color: Colors.grey[600],
                      )
                  ),
                  GestureDetector(
                    onTap: () async{
                      // Navigator.pushNamed(context, '/signup');
                      try {
                  // Authenticate user
                  UserCredential userCredential = await _auth.signInWithEmailAndPassword(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  );

                  // Fetch user role from Firestore
                  DocumentSnapshot userDoc = await _firestore
                      .collection('users')
                      .doc(userCredential.user!.uid)
                      .get();

                  String role = userDoc['role'];

                  // Navigate to respective dashboard
                  Navigator.pushNamed(context, role == 'admin' ? '/adminscreen' : '/userscreen');
                } catch (_) {
                  // Handle errors here (e.g., show error message to the user)
                }
                      
                    },
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: Text(
                          '  Register Now',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.deepOrange[800],
                          ),  
                      ),
                    ),
                  ),
                ],
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




