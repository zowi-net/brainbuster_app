import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        padding: const EdgeInsets.all(16.0),
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
              TextField(
                controller: newCategoryController,
                decoration: const InputDecoration(
                  labelText: 'Or Add New Category',
                ),
              ),
              const SizedBox(height: 16),
              // Fields for the question and its options.
              TextField(
                controller: questionController,
                decoration: const InputDecoration(labelText: 'Question'),
              ),
              TextField(
                controller: option1Controller,
                decoration: const InputDecoration(labelText: 'Option 1'),
              ),
              TextField(
                controller: option2Controller,
                decoration: const InputDecoration(labelText: 'Option 2'),
              ),
              TextField(
                controller: option3Controller,
                decoration: const InputDecoration(labelText: 'Option 3'),
              ),
              TextField(
                controller: option4Controller,
                decoration: const InputDecoration(labelText: 'Option 4'),
              ),
              TextField(
                controller: answerController,
                decoration: const InputDecoration(labelText: 'Answer'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
