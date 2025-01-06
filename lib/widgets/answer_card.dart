
import 'package:flutter/material.dart';

class AnswerCard extends StatelessWidget {
  const AnswerCard({
    super.key,
    required this.currentIndex,
    required this.question,
    required this.isSelected,
    required this.selectedAnswerIndex,
    required this.correctAnswerIndex, required this.isCorrectAnswer,
  });

  final int currentIndex;
  final String question;
  final int selectedAnswerIndex;
  final bool isSelected;
  final int correctAnswerIndex;
  final bool isCorrectAnswer;

  @override
  Widget build(BuildContext context) {
    bool isCorrectAnswer = currentIndex == correctAnswerIndex;
    bool isWrongAnswer = !isCorrectAnswer && !isSelected;
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      
      child: Container(
        height: 70,
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
        ),
        decoration: BoxDecoration(
          color:Colors.white10,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: isCorrectAnswer
                ? Colors.green
                : isWrongAnswer
                    ? Colors.red
                    : Colors.white24,
          ),
        ),
        child: Row(
          children: [
            Expanded(child: Text(
              question,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            ),
            const SizedBox(height: 10,),
            isCorrectAnswer
              ? buildCorrectIcon()
              : isWrongAnswer
                ? buildWrongIcon()
                : const SizedBox.shrink(),
          ],
        ),
      ),
    ); // Replace with your widget implementation
  }
}

Widget buildCorrectIcon() => CircleAvatar(
  radius: 15,
  backgroundColor: Colors.green[800],
  child: const Icon(
    Icons.check,
    color: Colors.white,
  ),
);


Widget buildWrongIcon() => CircleAvatar(
  radius: 15,
  backgroundColor: Colors.red[900],
  child: const Icon(
    Icons.check,
    color: Colors.white,
  ),
);