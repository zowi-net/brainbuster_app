import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  bool isResending = false;
  bool isEmailVerified = false;
  String role = ''; // Will hold the role (user/admin)

  // Check email verification status
  Future<void> checkEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;

    // Check if the user exists and email is verified
    if (user != null) {
      await user.reload();
      setState(() {
        isEmailVerified = user.emailVerified;
      });

      // Automatically navigate if email is verified
      if (isEmailVerified) {
        await getUserRole(user.uid);
        navigateBasedOnRole();
      }
    }
  }

  // Fetch the user role from Firestore
  Future<void> getUserRole(String userId) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists) {
      setState(() {
        role = userDoc['role'] ?? 'user'; // Default to 'user' if no role found
      });
    }
  }

  Future<void> resendVerificationEmail() async {
    setState(() {
      isResending = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification email resent!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isResending = false;
      });
    }
  }

  // Navigate based on the role after verification
  void navigateBasedOnRole() {
    if (role == 'admin') {
      Navigator.pushReplacementNamed(context, '/adminscreen');
    } else {
      Navigator.pushReplacementNamed(context, '/userscreen');
    }
  }

  @override
  void initState() {
    super.initState();

    // Periodically check email verification status every 3 seconds
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        await checkEmailVerification();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(221, 220, 220, 6),
      appBar: AppBar(title: const Text('Email Verification'), backgroundColor: const Color.fromRGBO(117, 74, 73, 5)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.email,
              size: 100,
              color: Color.fromRGBO(117, 74, 73, 5),
            ),
            const SizedBox(height: 20),
            const Text(
              'Please check your email and verify your account.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            isResending
                ? const CircularProgressIndicator()
                : SizedBox(
                  width: 250,
                  height: 70,
                  child: ElevatedButton(
                      onPressed: resendVerificationEmail,
                      style:  ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(117, 74, 73, 5), // Custom RGB (Orange)
                      ),
                      child: const Text('Resend Verification Email',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white)),
                    ),
                ),
            const SizedBox(height: 20),
            // Check if email is verified before allowing navigation
            isEmailVerified
                ? TextButton(
                    onPressed: navigateBasedOnRole,
                    child: const Text('I\'ve verified my email'),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

