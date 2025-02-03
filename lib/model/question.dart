

class Question{
  final String question;
  final List<String> option;
  String correctAnswer;

  Question({
    required this.question,
    required this.option,
    required this.correctAnswer,
  });
  
  //methos to check if the selected answer is correct
  bool iscorrect(String selectedAnswer){
    return selectedAnswer == correctAnswer;
  }
}


