import 'dart:async';
import 'package:brainbuster/pages/screens/userscreen/result/result.dart';
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
      // Handle error (e.g., show an error message)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load quiz data')),
      );
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
      _showFailedDialog(); // Display failed dialog when time runs out
    }
  });
}

void _showFailedDialog() {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent closing the dialog without action
    builder: (context) => AlertDialog(
      title: const Text('Time Up!'),
      content: const Text('You have failed the quiz. Try again later!'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close dialog
            Navigator.pop(context); // Go back to the previous screen
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
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
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ResultPage(score: _score),
    ),
  );
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
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_quizData.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No questions available')),
      );
    }

    final quiz = _quizData[_currentIndex];
     String correctAnswer = quiz['answer'] ?? '';
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
        title: Text(
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                quiz['question'] ?? 'No Content',
                style: GoogleFonts.thasadith(
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Time remaining: $_timeRemaining seconds',
                style: const TextStyle(fontSize: 18),
              ),
            ),
                      ...options.asMap().entries.map((entry) {
                      int index = entry.key;
                      String option = entry.value;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedOptionIndex = index;
                            _isOptionSelected = true;
                            _checkAnswer(option, correctAnswer);
                          });
                        },
                        child: Card(
                          color: _selectedOptionIndex == index ? Colors.red.shade200 : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: _selectedOptionIndex == index
                                ? const Icon(Icons.check, color: Colors.green)
                                : null,
                            title: Text(option),
                          ),
                        ),
                      );
                    }).toList().reversed,//i changed it to revserse lolo remove later
                    const Spacer(),
                    Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: _currentIndex > 0
                  ? () {
                      setState(() {
                        _currentIndex--;
                        _isOptionSelected = false;
                        _selectedOptionIndex = -1;
                        _startTimer();
                      });
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _currentIndex > 0 ? Colors.brown : Colors.grey,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Previous Question'),
            ),
            ElevatedButton(
              onPressed: _isOptionSelected ? _moveToNextQuestion : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isOptionSelected ? Colors.green : Colors.grey,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Next Question'),
            ),
          ],
          ),
          ],
        ),
      ),
    );
  }
}
