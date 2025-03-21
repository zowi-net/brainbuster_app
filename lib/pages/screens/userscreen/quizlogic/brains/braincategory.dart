import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      backgroundColor: const Color.fromRGBO(221, 220, 220, 2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
                            Row(
                  mainAxisAlignment: MainAxisAlignment.start, // Align children to the start (left)
                  mainAxisSize: MainAxisSize.max, // Take full width
                  children: [
                    // Left-aligned Icon
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back),
                    ),
                    // Centered Text (fills remaining space)
                    Expanded(
                      child: Center(
                        child: Text(
                          "Category",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20,
                            color: Colors.brown[800],
                            wordSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
            ),
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
          
                    return Padding(
                      padding: const EdgeInsets.only(top: 50,left: 16,right: 16),
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 30,
                          crossAxisSpacing: 10,
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
                              color: const Color.fromRGBO(238, 146, 30, 4),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16,right: 16,top: 16,bottom: 16),
                                  child: Text(docIds[index],
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
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
  // Timer logic
  Timer? _timer;
  final ValueNotifier<int> _remainingTime = ValueNotifier<int>(50 * 60); // 50 minutes in seconds

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.value > 0) {
        _remainingTime.value--;
      } else {
        _timer?.cancel();
        _showFailedTestDialog();
      }
    });
  }

  void _showFailedTestDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Time Up!',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
        content: Text('You have failed the test.',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16, 
          color: Colors.brown[800],
          wordSpacing: 1.5,
        ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/result', arguments: {'score': 0});
            },
            child: Text('OK',
            style: TextStyle(
              fontFamily: 'Poppins',
            fontSize: 16, 
            color: Colors.brown[800],
            wordSpacing: 1.5,
             ),
           ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _remainingTime.dispose();
    super.dispose();
  }

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
            return Center(child: Text("No questions available",
            style: GoogleFonts.poppins(
                  fontSize: 15, 
                  color: Colors.brown[800],
                  wordSpacing: 1.5,
                ),
              ),
           );
          }

          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          List<dynamic> questions = data['questions'] ?? [];

          if (_currentQuestionIndex >= questions.length) {
            return Center(
              child: Text(
                'Quiz Completed! Your score is $_score/${questions.length}',
                style: GoogleFonts.poppins(
                    fontSize: 16, 
                    color: Colors.brown[800],
                    wordSpacing: 1.5,
                  ),
              ),
            );
          }

          Map<String, dynamic> currentQuestion = questions[_currentQuestionIndex];
          String questionText = currentQuestion['question'] ?? 'No question available';
          List<dynamic> options = currentQuestion['options'] ?? [];
          String correctAnswer = currentQuestion['answer'] ?? '';

          return Padding(
            padding: const EdgeInsets.only(left: 16.0,right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timer display
                ValueListenableBuilder<int>(
                  valueListenable: _remainingTime,
                  builder: (context, value, child) {
                    return Center(
                      child: Text('Time remaining: ${value ~/ 60}:${value % 60}',
                      style: GoogleFonts.poppins(
                        color: Colors.red[800],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10,),
                Text(
                  'Question: $questionText',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18, 
                    color: Colors.brown[800],
                    wordSpacing: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                ...options.map<Widget>((option) {
                  return RadioListTile<String>(
                    title: Text(option ?? 'No option available',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                    )),
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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: ElevatedButton(
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
                        child: Text("Previous",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                            fontSize: 16, 
                            color: Colors.brown[800],
                            wordSpacing: 1.5,
                            fontWeight: FontWeight.w500,
                          ), 
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: ElevatedButton(
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
                        child: Text("Next",
                         style: TextStyle(
                          fontFamily: 'Poppins',
                            fontSize: 16, 
                            color: Colors.brown[800],
                            wordSpacing: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
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