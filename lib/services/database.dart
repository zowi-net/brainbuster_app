import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  // Add a new question
  Future<void> addQuestion(
      String questionController,
      String answerController,
      String option1Controller,
      String option2Controller,
      String option3Controller,
      String option4Controller) async {
    var firestore = FirebaseFirestore.instance;
    await firestore.collection('quiz').add({
      'question': questionController,
      'option1': option1Controller,
      'option2': option2Controller,
      'option3': option3Controller,
      'option4': option4Controller,
      'answer': answerController,
      'date': DateTime.now(),
    });
  }

  // Stream to read quiz data
  Stream<QuerySnapshot> readData() {
    var firestore = FirebaseFirestore.instance;
    return firestore.collection('quiz').orderBy('date', descending: true).snapshots();
  }

  // Stream to read student data
  Stream<QuerySnapshot> readStudents() {
    var firestore = FirebaseFirestore.instance;
    return firestore.collection('users').snapshots();
  }

  // Delete user data by userId
  Future<void> deleteUser(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();
    } catch (e) {
      rethrow;
    }
  }

  // Delete quiz data by quizId
  Future<void> deleteQuiz(String quizId) async {
    try {
      await FirebaseFirestore.instance.collection('quiz').doc(quizId).delete();
    } catch (e) {
      rethrow;
    }
  }

  // Update quiz data by quizId
  Future<void> updateQuiz(
    String quizId,
    String questionController,
    String answerController,
    String option1Controller,
    String option2Controller,
    String option3Controller,
    String option4Controller,
  ) async {
    try {
      await FirebaseFirestore.instance.collection('quiz').doc(quizId).update({
        'question': questionController,
        'answer': answerController,
        'option1': option1Controller,
        'option2': option2Controller,
        'option3': option3Controller,
        'option4': option4Controller,
        'date': DateTime.now(), // Optionally update the date to the current timestamp
      });
    } catch (e) {
      rethrow;
    }
  }
}



