import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final int score;

  const ResultPage({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(221, 220, 220, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(117, 74, 77, 1),
        title: const Text('Quiz Result',style: TextStyle(
          fontFamily: 'Poppins',
          color: Colors.white,
          fontSize: 15,
        ),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Your Score is:',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              '$score',
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
              color: Colors.brown[700], // Background color for the button container
              borderRadius: BorderRadius.circular(12), // Curved edges
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // Soft shadow
                  blurRadius: 5,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Go back to the main screen
                },
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent, // Make the button background transparent
                  shadowColor: Colors.transparent, // Removes button's default shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Match the container’s border radius
                  ),
                ),
                child: const Text('Return to Home',style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  color: Colors.white, // Ensure text is readable
                  fontWeight: FontWeight.bold,
                ),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
