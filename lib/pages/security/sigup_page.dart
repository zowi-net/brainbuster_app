import 'package:brainbuster/pages/security/emailverify.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;

// TextEditingController is used to control the textfield
final TextEditingController firstNameController = TextEditingController();
final TextEditingController lastNameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController confirmpasswordController = TextEditingController();
String role = 'user';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

// Snackbar to display wrong credentials
void showWrongCredentialsSnackBar(BuildContext wrgcontext) {
  ScaffoldMessenger.of(wrgcontext).showSnackBar(
    const SnackBar(
      content: Text('Wrong email or password'),
      backgroundColor: Color.fromRGBO(241, 58, 90, 6), // Indicate an error
      duration: Duration(seconds: 3), // Visible for 3 seconds
    ),
  );
}

// Function to sign up the user
void signUserUp(
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
    // Check if password is confirmed
    if (passwordController.text == confirmpasswordController.text) {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Send email verification
      await userCredential.user!.sendEmailVerification();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully. Please verify your email.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      // Save user role in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': emailController.text.trim(),
        'role': role,
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'password': passwordController.text.trim(),
      });

      // Navigate to the EmailVerificationPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EmailVerificationPage()),
      );
    } else {
      // Show error message if passwords do not match
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Color.fromRGBO(241, 58, 90, 6),
          duration: Duration(seconds: 3),
        ),
      );
    }
  } catch (e) {
    // Handle the error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error creating account: $e'),
        backgroundColor: const Color.fromRGBO(241, 58, 90, 6),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}


class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(221, 220, 220, 6),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16,right: 16,top: 5,bottom: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               Row(
                 children: [
                   GestureDetector(
                      onTap: () {
                        Navigator.pop(context, '/loginpage');
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        size: 30,
                      ),
                    ),
                 ],
               ),
                const SizedBox(height: 1),
                Lottie.asset('assets/hm.json', width: 300, height: 200),
                const Text(
                  'Create An Account With Brainbuster',
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                Text(
                  'Welcome to BrainBuster Create an account With Us',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 15, 
                    color: Colors.grey[600],
                    wordSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
// FirstName field
                TextField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    focusColor: Colors.white,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    hintText: '  First Name',
                    hintStyle: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.grey[500],
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
// LastName field
                TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    focusColor: Colors.white,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    hintText: ' Last Name',
                    hintStyle: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.grey[500],
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
// Email field
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
                    hintText: ' Email',
                    hintStyle: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.grey[500],
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
// Password field
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
                      fontFamily: 'Poppins',
                      color: Colors.grey[500],
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
// Confirm password field
                TextField(
                  controller: confirmpasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    focusColor: Colors.white,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    hintText: '  Confirm Password',
                    hintStyle: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.grey[500],
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
// Dropdown to select user or admin
                // DropdownButton<String>(
                //   value: role,
                //   items: ['user', 'admin']
                //       .map((role) => DropdownMenuItem(
                //             value: role,
                //             child: Text(role),
                //           ))
                //       .toList(),
                //   onChanged: (value) => setState(() => role = value!),
                // ),
                const SizedBox(height: 20),
  // SignUp button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(117, 74, 73, 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: GestureDetector(
                          onTap: () async {
                            signUserUp(context, emailController, passwordController);
                            role;
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              color: Color.fromRGBO(221, 220, 220, 2),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
