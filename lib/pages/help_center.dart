import 'package:flutter/material.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Help Center',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.brown[300],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('FAQs'),
            _buildQuestionAnswer(
                'How can I reset my password?',
                'To reset your password, go to the login page and click on "Forgot Password?". Follow the instructions sent to your email.'),
            _buildQuestionAnswer(
                'How do I report a problem?',
                'You can report a problem by navigating to the "Contact Us" section and sending us a detailed message.'),
            const Divider(),
            _buildSectionTitle('Contact Support'),
            _buildContent(
                'If you need further assistance, please reach out to us via one of the following methods:'),
            _buildContent('- **Email**: support@brainbusterquiz.com'),
            _buildContent('- **Phone**: +1 (555) 123-4567'),
            _buildContent('- **Live Chat**: Available in the app from 9 AM to 5 PM (GMT).'),
            const Divider(),
            _buildSectionTitle('Tips for Better Performance'),
            _buildContent('1. Ensure a stable internet connection during quizzes.'),
            _buildContent('2. Keep your app updated for the latest features and bug fixes.'),
            _buildContent('3. Take regular breaks to stay focused and refreshed.'),
            const Divider(),
            _buildSectionTitle('Feedback and Suggestions'),
            _buildContent(
                'We value your feedback! Please share your thoughts via the "Feedback" section in the app.'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildQuestionAnswer(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            answer,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        content,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
