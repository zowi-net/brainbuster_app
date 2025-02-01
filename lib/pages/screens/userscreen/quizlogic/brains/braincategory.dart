import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Braincategory extends StatefulWidget {
  const Braincategory({super.key});

  @override
  State<Braincategory> createState() => _BraincategoryState();
}

class _BraincategoryState extends State<Braincategory> {
  Stream<List<String>> getCategoryIdStream() {
    return FirebaseFirestore.instance.collection('category').snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => doc.id).toList(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Text("Category"),
            Expanded(
              child: StreamBuilder<List<String>>(
                stream: getCategoryIdStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docIds = snapshot.data!;

                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1,
                    ),
                    itemCount: docIds.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuestionsScreen(categoryId: docIds[index]),
                            ),
                          );
                        },
                        child: Card(
                          child: Center(
                            child: Text(docIds[index]),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class QuestionsScreen extends StatefulWidget {
  final String categoryId;

  const QuestionsScreen({super.key, required this.categoryId});

  @override
  QuestionsScreenState createState() => QuestionsScreenState();
}

class QuestionsScreenState extends State<QuestionsScreen> {
  String? _selectedOption;
  int _currentQuestionIndex = 0;
  int _score = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Questions for ${widget.categoryId}')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('category')
            .doc(widget.categoryId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("No questions available"));
          }

          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          List<dynamic> questions = data['questions'] ?? [];

          if (_currentQuestionIndex >= questions.length) {
            return Center(
              child: Text(
                'Quiz Completed! Your score is $_score/${questions.length}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            );
          }

          Map<String, dynamic> currentQuestion = questions[_currentQuestionIndex];
          String questionText = currentQuestion['question'] ?? 'No question available';
          List<dynamic> options = currentQuestion['options'] ?? [];
          String correctAnswer = currentQuestion['answer'] ?? '';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Question: $questionText',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ...options.map<Widget>((option) {
                  return RadioListTile<String>(
                    title: Text(option ?? 'No option available'),
                    value: option ?? 'No option available',
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value;
                      });
                    },
                  );
                }).toList(),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _currentQuestionIndex > 0
                          ? () {
                              setState(() {
                                _currentQuestionIndex--;
                                _selectedOption = null;
                              });
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Previous", style: TextStyle(fontSize: 16)),
                    ),
                    ElevatedButton(
                      onPressed: _selectedOption != null
                          ? () {
                              setState(() {
                                if (_selectedOption == correctAnswer) {
                                  _score++;
                                }
                                if (_currentQuestionIndex < questions.length - 1) {
                                  _currentQuestionIndex++;
                                  _selectedOption = null;
                                } else {
                                  // Quiz completed
                                  _currentQuestionIndex++;
                                }
                              });
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Next", style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}