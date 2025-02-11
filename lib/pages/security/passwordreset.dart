import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Declare GlobalKey for ScaffoldMessenger
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  void _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
        // Show success message
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(content: Text('Password reset link sent to ${_emailController.text}')),
        );
      } on FirebaseAuthException catch (e) {
        // Handle error (e.g., user not found)
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(content: Text('Error: ${e.message}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,  // Pass the key to ScaffoldMessenger
      child: Scaffold(
        appBar: AppBar(
          title: Text('Password Reset',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold, 
                    color: Colors.brown[800],
                    wordSpacing: 1.5,
                  ),
          ),
          backgroundColor: Colors.brown[300],
        ),
        body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.brown[300]!, Colors.brown[600]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.only(left: 16,right: 16),
        child: Center(
          child: SizedBox(
            height: 350,
            width: 350,
            child: Card(
              semanticContainer: true,
              color: Colors.white70,
              elevation: 25,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Text(
                          textAlign: TextAlign.center,
                          'Enter your email address to reset your password',
                          style: GoogleFonts.poppins(
                            fontSize: 16, 
                            color: Colors.brown[800],
                            wordSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email, color: Colors.brown[600]),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          fillColor: Colors.brown[100],
                          filled: true,
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(color: Colors.brown[400]),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.brown, width: 2),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          )
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _resetPassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown[500],
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Reset Password',
                        style:TextStyle(
                          color: Colors.white70,
                          fontSize:15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
    );
  }
}
