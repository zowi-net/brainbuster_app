import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditUserScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String userId;

  const EditUserScreen({required this.userData, required this.userId, Key? key}) : super(key: key);

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController roleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    firstNameController.text = widget.userData['firstName'];
    lastNameController.text = widget.userData['lastName'];
    emailController.text = widget.userData['email'];
    roleController.text = widget.userData['role'];
  }

  void _updateUser() {
    FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'email': emailController.text,
      'role': roleController.text,
    }).then((_) {
      Navigator.pop(context); // Go back after update
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: roleController,
              decoration: const InputDecoration(labelText: 'Role'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateUser,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
