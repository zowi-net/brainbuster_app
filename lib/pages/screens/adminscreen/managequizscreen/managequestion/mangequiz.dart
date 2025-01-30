import 'package:brainbuster/pages/screens/adminscreen/managequizscreen/addquestions/addquestion.dart';
import 'package:brainbuster/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // Import the intl package for date formatting

class ManageQuizzesScreen extends StatefulWidget {
  const ManageQuizzesScreen({super.key});

  @override
  State<ManageQuizzesScreen> createState() => _ManageQuizzesScreenState();
}

class _ManageQuizzesScreenState extends State<ManageQuizzesScreen> {
  final Database db = Database();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown[300],
        child: const Icon(Icons.add),
        onPressed: () {
          // Navigator.pushNamed(context, '/addquiz');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddQuestionsScreen(),
            ),
          );
        },
      ),
      appBar: AppBar(
        title: const Text('Manage Quizzes'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade200,
              Colors.purple.shade200,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: db.readData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong'),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              var quizzes = snapshot.data!.docs;

              return ListView.builder(
                itemCount: quizzes.length,
                itemBuilder: (context, index) {
                  final quiz = quizzes[index];
                  // Extract the necessary fields
                  final String answer = quiz['answer'] ?? 'No Answer';
                  final Timestamp timestamp = quiz['date'];
                  final String option1 = quiz['option1'] ?? 'No Option';
                  final String option2 = quiz['option2'] ?? 'No Option';
                  final String option3 = quiz['option3'] ?? 'No Option';
                  final String option4 = quiz['option4'] ?? 'No Option';
                  final String question = quiz['question'] ?? 'No Question';
                  
                  // Format the timestamp to a readable date
                  String formattedDate = DateFormat('d MMM yyyy at h:mm a').format(timestamp.toDate());

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    // Apply a refined gradient background to the card
                    color: Colors.transparent,
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.shade50,
                            Colors.purple.shade50,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          question,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Answer: $answer',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              'Date: $formattedDate',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Options:',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Text('1. $option1'),
                            Text('2. $option2'),
                            Text('3. $option3'),
                            Text('4. $option4'),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text('No quizzes available'),
              );
            }
          },
        ),
      ),
    );
  }
}
