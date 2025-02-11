import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        title: Text('Edit User',
              style: GoogleFonts.poppins(
              fontSize: 20, 
              color: Colors.black87,
              wordSpacing: 1.5,
            ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 16),
        child: Column(
          children: [
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
              hintText: '  FirstName',
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontSize: 20,
              ),
            ),
              style: GoogleFonts.poppins(
                fontSize: 16, 
                color: Colors.black38,
                wordSpacing: 1.5,
              ),
            ),const SizedBox(height: 20,),
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
              hintText: '  LastName',
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontSize: 20,
              ),
            ),
              style: GoogleFonts.poppins(
                fontSize: 16, 
                color: Colors.black38,
                wordSpacing: 1.5,
              ),
            ),const SizedBox(height: 20,),
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
              ),
            ),
              style: GoogleFonts.poppins(
                fontSize: 16, 
                color: Colors.black38,
                wordSpacing: 1.5,  
              ),
            ),const SizedBox(height: 20,),
            TextField(
              controller: roleController,
              decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              focusColor: Colors.white,
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              hintText: '  Type either admin or user',
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontSize: 20,
              ),
            ),
              style: GoogleFonts.poppins(
                fontSize: 16, 
                color: Colors.black38,
                wordSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child: ElevatedButton(
              onPressed: _updateUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple[400],
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Save Changes',
              style:TextStyle(
                color: Colors.white70,
                fontSize:15,
                ),
              ),
              ),
            ),const SizedBox(height: 100,),
            Text("Section admin can make a user an admin or edit firstname and lastname or email address",
            style: GoogleFonts.poppins(
                fontSize: 16, 
                color: Colors.black26,
                wordSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
