import 'package:cloud_firestore/cloud_firestore.dart';

class Database{
  Future addQuestion(questionController,answerController,option1Controller,option2Controller,option3Controller,option4Controller) async{
      var  firestore = FirebaseFirestore.instance;
      return firestore.collection('quiz').add({
        'question': questionController,
        'option1':  option1Controller,
        'option2':  option2Controller,
        'option3':  option3Controller,
        'option4':  option4Controller,
        'answer':   answerController,
        'date': DateTime.now(),
      },
      );
     }

      Stream<QuerySnapshot> readData() {
        var firestore = FirebaseFirestore.instance;
        return firestore.collection('quiz').snapshots();
      }


  }
