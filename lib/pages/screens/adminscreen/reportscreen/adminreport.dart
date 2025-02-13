import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final TextEditingController newCategoryController = TextEditingController();
  final TextEditingController questionController = TextEditingController();
  final TextEditingController option1Controller = TextEditingController();
  final TextEditingController option2Controller = TextEditingController();
  final TextEditingController option3Controller = TextEditingController();
  final TextEditingController option4Controller = TextEditingController();
  final TextEditingController answerController = TextEditingController();

  String? selectedCategory;

  /// Submits the form by adding a new question to the chosen category document.
  /// If a new category name is provided, that will override the selected category.
  void _submitForm() async {
    String newCategory = newCategoryController.text.trim();
    String categoryId = newCategory.isNotEmpty ? newCategory : (selectedCategory ?? '');

    String question = questionController.text.trim();
    String option1 = option1Controller.text.trim();
    String option2 = option2Controller.text.trim();
    String option3 = option3Controller.text.trim();
    String option4 = option4Controller.text.trim();
    String answer = answerController.text.trim();

    if (categoryId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or add a category')),
      );
      return;
    }

    if (question.isNotEmpty &&
        option1.isNotEmpty &&
        option2.isNotEmpty &&
        option3.isNotEmpty &&
        option4.isNotEmpty &&
        answer.isNotEmpty) {
      // Get a reference to the chosen category document.
      DocumentReference categoryDoc = FirebaseFirestore.instance
          .collection('category')
          .doc(categoryId);

      // Add the new question to the questions array using arrayUnion.
      await categoryDoc.set({
        'name': categoryId,
        'questions': FieldValue.arrayUnion([
          {
            'question': question,
            'options': [option1, option2, option3, option4],
            'answer': answer,
          }
        ]),
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Question added successfully')),
      );

      // Clear the form fields.
      newCategoryController.clear();
      questionController.clear();
      option1Controller.clear();
      option2Controller.clear();
      option3Controller.clear();
      option4Controller.clear();
      answerController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

  @override
  void dispose() {
    newCategoryController.dispose();
    questionController.dispose();
    option1Controller.dispose();
    option2Controller.dispose();
    option3Controller.dispose();
    option4Controller.dispose();
    answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20,right: 20,top: 16.0,bottom: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Section for selecting an existing category.
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('category').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  List<DocumentSnapshot> docs = snapshot.data!.docs;
                  if (docs.isEmpty) {
                    return const Text("No categories found. Add a new category below.");
                  }
                  List<DropdownMenuItem<String>> items = docs.map((doc) {
                    return DropdownMenuItem<String>(
                      value: doc.id,
                      child: Text(doc.id),
                    );
                  }).toList();

                  // Set the initial category if none is selected.
                  if(selectedCategory == null) {
                    selectedCategory = docs.first.id;
                  }
                  return DropdownButton<String>(
                    elevation: 25,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    value: selectedCategory,
                    items: items,
                    onChanged: (newVal) {
                      setState(() {
                        selectedCategory = newVal;
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              // Optional field to add a new category.
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: newCategoryController,
                  decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                focusColor: Colors.white,
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                hintText: '  Add New Category',
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 20,
                ),
                            ),
                style: GoogleFonts.poppins(
                  fontSize: 16, 
                  color: Colors.black38,
                  wordSpacing: 1.5,
                ),
                ),
              ),
              // Fields for the question and its options.
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: questionController,
                  decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                focusColor: Colors.white,
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                hintText: '  Question',
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 20,
                ),
                            ),
                style: GoogleFonts.poppins(
                  fontSize: 16, 
                  color: Colors.black38,
                  wordSpacing: 1.5,
                ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: option1Controller,
                  decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                focusColor: Colors.white,
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                hintText: '  Option 1',
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 20,
                ),
                            ),
                style: GoogleFonts.poppins(
                  fontSize: 16, 
                  color: Colors.black38,
                  wordSpacing: 1.5,
                ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: option2Controller,
                  decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                focusColor: Colors.white,
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                hintText: '  Option 2',
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 20,
                ),
                            ),
                style: GoogleFonts.poppins(
                  fontSize: 16, 
                  color: Colors.black38,
                  wordSpacing: 1.5,
                ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: option3Controller,
                  decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                focusColor: Colors.white,
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                hintText: '  Option 3',
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 20,
                ),
                            ),
                style: GoogleFonts.poppins(
                  fontSize: 16, 
                  color: Colors.black38,
                  wordSpacing: 1.5,
                ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: option4Controller,
                  decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                focusColor: Colors.white,
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                hintText: '  Option 4',
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 20,
                ),
                 ),
                style: GoogleFonts.poppins(
                  fontSize: 16, 
                  color: Colors.black38,
                  wordSpacing: 1.5,
                ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(9),
                child: TextField(
                  controller: answerController,
                  decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                focusColor: Colors.white,
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                hintText: '  Answer',
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 20,
                ),
                            ),
                style: GoogleFonts.poppins(
                  fontSize: 16, 
                  color: Colors.black38,
                  wordSpacing: 1.5,
                ),
                ),
              ),
              const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 40,right: 40),
              child: ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple[400],
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Add Questions',
              style:TextStyle(
                color: Colors.white70,
                fontSize:15,
                ),
              ),
            ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}
