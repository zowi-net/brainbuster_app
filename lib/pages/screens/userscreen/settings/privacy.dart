import 'package:flutter/material.dart';

class PrivacyAndTermsPage extends StatelessWidget {
  const PrivacyAndTermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'We value your privacy and are committed to protecting your personal information. Our Privacy Policy outlines how we collect, use, and protect your data.',
              style: TextStyle(fontSize: 16, color: Colors.brown[700]),
            ),
            const SizedBox(height: 20),
            Text(
              'Collection of Information:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'We may collect personal information such as your name, email, and other details to provide better services.',
              style: TextStyle(fontSize: 16, color: Colors.brown[700]),
            ),
            const SizedBox(height: 20),
            Text(
              'How We Use Your Information:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Your information helps us improve the app and provide personalized experiences.',
              style: TextStyle(fontSize: 16, color: Colors.brown[700]),
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Action after accepting privacy policy
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Privacy policy accepted')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[500],
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Accept Privacy Policy',style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
