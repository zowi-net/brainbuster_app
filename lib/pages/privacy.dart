import 'package:flutter/material.dart';

class PrivacyAndTermsPage extends StatelessWidget {
  const PrivacyAndTermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Privacy and Terms',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.brown[300],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Privacy Policy'),
            _buildSubsectionTitle('1.1 Data Collection'),
            _buildContent(
                'We may collect personal information, usage data, and location data to enhance your experience.'),
            _buildSubsectionTitle('1.2 Use of Data'),
            _buildContent(
                'Your data is used for personalizing your experience, improving functionality, and sending notifications.'),
            _buildSubsectionTitle('1.3 Data Sharing'),
            _buildContent(
                'We do not sell your data. Trusted third-party services are used for authentication and analytics.'),
            _buildSubsectionTitle('1.4 Data Security'),
            _buildContent(
                'We use industry-standard measures to protect your data but cannot guarantee absolute security.'),
            _buildSubsectionTitle('1.5 User Rights'),
            _buildContent(
                'You can access, correct, or delete your data and opt out of certain practices by contacting us.'),
            const Divider(),
            _buildSectionTitle('Terms of Use'),
            _buildSubsectionTitle('2.1 Acceptance of Terms'),
            _buildContent(
                'By using the BrainBuster Quiz app, you agree to these terms. Discontinue use if you disagree.'),
            _buildSubsectionTitle('2.2 User Responsibilities'),
            _buildContent(
                'Use the app for personal purposes, avoid sharing harmful content, and refrain from disrupting functionality.'),
            _buildSubsectionTitle('2.3 Intellectual Property'),
            _buildContent(
                'All content in the app is owned by BrainBuster Quiz and may not be copied or distributed without permission.'),
            _buildSubsectionTitle('2.4 Account Termination'),
            _buildContent(
                'We reserve the right to suspend accounts that violate these terms or engage in harmful activities.'),
            const Divider(),
            _buildSectionTitle('Changes to Privacy and Terms'),
            _buildContent(
                'We may update this document and communicate changes via the app or email. Continued use implies acceptance.'),
            const Divider(),
            _buildSectionTitle('Contact Us'),
            _buildContent(
                'For questions or concerns, contact us at:\n- Email: [Insert Email]\n- Phone: [Insert Phone Number]'),
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

  Widget _buildSubsectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
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
