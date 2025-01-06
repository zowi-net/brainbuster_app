import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:brainbuster/services/database.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final Database db = Database();
  List<Map<String, dynamic>> _quizData = [];
  int _currentIndex = 0;
  Timer? _timer;
  int _timeRemaining = 30;
  bool _isOptionSelected = false;
  int _selectedOptionIndex = -1;
  int _score = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchQuizData();
    _startTimer();
  }

  Future<void> _fetchQuizData() async {
    try {
      final snapshot = await db.readData().first;
      setState(() {
        _quizData = snapshot.docs
            .map((doc) => Map<String, dynamic>.from(doc.data() as Map<dynamic, dynamic>))
            .toList();
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      // Handle error (e.g., show a message)
    }
  }

  void _startTimer() {
    _timeRemaining = 30; // Reset timer
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        setState(() {
          _timeRemaining--;
        });
      } else {
        _timer?.cancel();
        // Handle time-up behavior
      }
    });
  }

  void _checkAnswer(String selectedOption, String correctAnswer) {
    if (selectedOption == correctAnswer) {
      _score++;
    }
  }

  void _moveToNextQuestion() {
    if (_currentIndex < _quizData.length - 1) {
      setState(() {
        _currentIndex++;
        _isOptionSelected = false;
        _selectedOptionIndex = -1;
        _startTimer(); // Restart timer for the next question
      });
    } else {
      // Show score dialog when the quiz ends
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Quiz Completed'),
          content: Text('Your score is $_score'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_quizData.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text('No questions available'),
        ),
      );
    }

    final quiz = _quizData[_currentIndex];
    String correctAnswer = quiz['answerController'] ?? '';

    List<String> options = [
      quiz['option1'] ?? 'No Content',
      quiz['option2'] ?? 'No Content',
      quiz['option3'] ?? 'No Content',
      quiz['option4'] ?? 'No Content',
    ];

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.brown[300],
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'BrainBuster Quiz',
            style: GoogleFonts.rubik(
              textStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(32, 34, 36, 0.8),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    quiz['question'] ?? 'No Content',
                    style:  GoogleFonts.thasadith(
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ), 
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                'Time remaining: $_timeRemaining seconds',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            ...options.asMap().map((index, option) {
              return MapEntry(
                index,
                GestureDetector(
                  onTap: () {
                    // Allow user to select or change the option
                    setState(() {
                      _selectedOptionIndex = index;
                      _isOptionSelected = true;
                      _checkAnswer(option, correctAnswer);
                    });
                  },
                  child: MouseRegion(
                    onEnter: (event) {
                      // Hover effect: change background color for visual feedback
                      setState(() {
                        if (!_isOptionSelected || _selectedOptionIndex == index) {
                          _selectedOptionIndex = index;
                        }
                      });
                    },
                    onExit: (event) {
                      // Reset hover effect when mouse leaves
                      if (!_isOptionSelected) {
                        setState(() {
                          _selectedOptionIndex = -1;
                        });
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 100,
                        width: double.infinity,
                        child: Card(
                          elevation: 40,
                          surfaceTintColor: Colors.grey[900],
                          shadowColor: Colors.transparent,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          color: _selectedOptionIndex == index
                              ? (_isOptionSelected
                                  ? Colors.green.shade200
                                  : Colors.grey.shade200)
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(option),
                                if (_isOptionSelected &&
                                    _selectedOptionIndex == index)
                                  const Icon(Icons.check_circle,
                                      color: Colors.green),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).values.toList(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
GestureDetector(
          onTap: _currentIndex > 0
        ?  () {
      // Define your button action here
          setState(() {
                    _currentIndex--;
                    _isOptionSelected = false;
                    _selectedOptionIndex = -1;
                    _startTimer();
                  });
                }
              : null,   
        
           child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Button size
                decoration: BoxDecoration(
                  color: Colors.brown[600], // Background color
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // Shadow color
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // Shadow position
                    ),
                  ],
                ),
                child: const Text(
                  "Previous Question",
                  style: TextStyle(
                    color: Colors.white, // Text color
                    fontSize: 16, // Font size
                    fontWeight: FontWeight.bold, // Text weight
                  ),
                ),
              ),
),
const SizedBox(height: 100),
      GestureDetector(
        onTap: () {
            // Define your button action here
              if (_isOptionSelected) {
                  _moveToNextQuestion();
            }
        },
           child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Button size
                decoration: BoxDecoration(
                  color: Colors.brown[600], // Background color
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // Shadow color
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // Shadow position
                    ),
                  ],
                ),
                child: const Text(
                  "Next Question",
                  style: TextStyle(
                    color: Colors.white, // Text color
                    fontSize: 16, // Font size
                    fontWeight: FontWeight.bold, // Text weight
                  ),
                ),
              ),
),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
