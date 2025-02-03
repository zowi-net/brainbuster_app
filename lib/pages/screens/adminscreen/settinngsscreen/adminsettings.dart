
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // Settings option action
              },
              child: const Text('Change Password'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Other settings option action
              },
              child: const Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
