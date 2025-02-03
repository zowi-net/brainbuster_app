import 'package:flutter/material.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Center'),
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
        child: ListView(
          children: [
            Text(
              'Help Center',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
              ),
            ),
            const SizedBox(height: 20),
            _buildHelpTopic(
              title: 'Account Issues',
              description:
                  'If you are having trouble accessing your account, make sure your credentials are correct or try resetting your password.',
            ),
            _buildHelpTopic(
              title: 'App Functionality',
              description:
                  'For issues related to app features, ensure you have the latest version of the app installed.',
            ),
            _buildHelpTopic(
              title: 'Payment and Billing',
              description:
                  'For any payment or billing questions, contact our support team for assistance.',
            ),
            _buildHelpTopic(
              title: 'Security and Privacy',
              description:
                  'If you have concerns regarding your data privacy or security, refer to our Privacy Policy or contact support.',
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Contact support action
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Redirecting to support...')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[500],
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Contact Support',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpTopic({required String title, required String description}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[800],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: TextStyle(fontSize: 16, color: Colors.brown[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
