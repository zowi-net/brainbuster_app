import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:brainbuster/services/database.dart';
import 'package:unicons/unicons.dart';

class   AddQuestionsScreen extends StatefulWidget { 
  const AddQuestionsScreen({super.key});

  @override
  State<AddQuestionsScreen> createState() => _AddQuestionsScreenState();
}

class _AddQuestionsScreenState extends State<AddQuestionsScreen> {
  final Database db = Database();
  
  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();
  final TextEditingController option1Controller = TextEditingController();
  final TextEditingController option2Controller = TextEditingController();
  final TextEditingController option3Controller = TextEditingController();
  final TextEditingController option4Controller = TextEditingController();
  // final List<TextEditingController> optionControllers = List.generate(4, (index) => TextEditingController());
   
   //to sign user out so i call out the method signout in onpressed
  void signUserOut() async{
    await FirebaseAuth.instance.signOut();  
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[300],
          appBar: AppBar(
            backgroundColor: Colors.brown[300],
            title: Padding(
              padding: const EdgeInsets.only(left: 16.0,right: 16.0),
              child: Text('BrainBuster Quiz',
              style: GoogleFonts.rubik(
                textStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(32, 34, 36, 0.8), 
                ), 
              ),
            ),
            ),
            actions: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0,right: 16.0),
              child: GestureDetector(
                onTap: (){
                  // Navigator.pop(context);
                  Navigator.
                pushNamed(context, '/loginpage');
                  signUserOut;
                },child: const Icon(UniconsLine.signout,size: 24,),
              ),
            ),
            ], 
          ),
          body:  Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 16.0, bottom: 16.0),
        child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(
            child: Text( 
              'Add Questions and Answers here',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      const SizedBox(height: 20.0),
          TextField(
            controller: questionController,
            obscureText: false,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              focusColor: Colors.white,
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              hintText: ' Type Your Question',
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontSize: 20,
              )
            ),
          ),
      const SizedBox(height: 30.0),
        const Center(
          child: Text(
            "Type In Your Answer",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )
          ),
        ),
           TextField(
            controller: answerController,
            obscureText: false,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              focusColor: Colors.white,
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              hintText: '  Type Your Answer followed by a ?',
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontSize: 20,
              )
            ),
          ),
      const SizedBox(height: 20.0),
          Column(
            children: [
              const Text(
                "Type In Your Questions",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
      const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextField(
            controller: option1Controller,
            obscureText: false,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              focusColor: Colors.white,
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              hintText: '  Type In Question A',
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontSize: 20,
              )
            ),
          ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextField(
            controller: option2Controller,
            obscureText: false,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              focusColor: Colors.white,
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              hintText: '  Type In Question B',
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontSize: 20,
              )
            ),
          ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextField(
            controller:  option3Controller,
            obscureText: false,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              focusColor: Colors.white,
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              hintText: '  Type In Question C',
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontSize: 20,
              )
            ),
          ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextField(
            controller: option4Controller,
            obscureText: false,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              focusColor: Colors.white,
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              hintText: '  Type In Question D',
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontSize: 20,
              )
            ),
          ),
              ),
            ],
          ),
      const SizedBox(height: 20.0),
       Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.brown[700],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      db.addQuestion(
                      questionController.text,
                      answerController.text,
                      option1Controller.text,
                      option2Controller.text,
                      option3Controller.text,
                      option4Controller.text,
                    );
                      // Navigator.pushNamed(context, '/home');
                    },
                    child: const Text(
                      'Submit Questions',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),      
        ],
      ),
        ),
      ),
      
      ),
    );
  }
}





