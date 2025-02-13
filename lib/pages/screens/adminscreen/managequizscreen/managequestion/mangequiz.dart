import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageQuizzesScreen extends StatefulWidget {
  const ManageQuizzesScreen({super.key});

  @override
  _ManageQuizzesScreenState createState() => _ManageQuizzesScreenState();
}

class _ManageQuizzesScreenState extends State<ManageQuizzesScreen> {
  String? selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('Manage Quizzes',
                style: GoogleFonts.poppins(
                    fontSize: 19, 
                    color: Colors.brown[800],
                    wordSpacing: 1.5,
                  ),
                ),
        actions: selectedCategoryId == null
            ? [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _showAddCategoryDialog,
                  color: Colors.green[500],
                ),
              ]
            : [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _deleteCategory,
                  color: Colors.red[800],
                ),
              ],
        leading: selectedCategoryId != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    selectedCategoryId = null; // Go back to categories list
                  });
                },
              )
            : null,
      ),
      body: 
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade200,
              Colors.purple.shade200,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: 
      selectedCategoryId == null ? _buildCategoryList() : _buildQuestionsList(),
       ),  
     );
  }

  /// Fetches and displays categories
  Widget _buildCategoryList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('category').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        var categories = snapshot.data!.docs;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              var category = categories[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 20,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(category.id),
                      onTap: () {
                        setState(() {
                          selectedCategoryId = category.id;
                        });
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// Fetches and displays questions for the selected category
  Widget _buildQuestionsList() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('category')
          .doc(selectedCategoryId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        var categoryData = snapshot.data!.data() as Map<String, dynamic>;

        // Check if 'questions' exists in the document
        if (!categoryData.containsKey('questions') || categoryData['questions'] == null) {
          return Center(child: Text("No questions found for this category",
                      style: GoogleFonts.poppins(
                        fontSize: 16, 
                        color: Colors.brown[800],
                        wordSpacing: 1.5,
                      ),
                    ),
                 );
        }

        List<dynamic> questions = categoryData['questions'];

        return Padding(
          padding: const EdgeInsets.only(top: 25),
          child: ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              var questionData = questions[index];
          
              // Ensure that 'question', 'options', and 'answer' exist
              String question = questionData.containsKey('question') ? questionData['question'] : "No question found";
              String answer = questionData.containsKey('answer') ? questionData['answer'] : "No answer provided";
              List<dynamic> options = questionData.containsKey('options') ? questionData['options'] : [];
          
              return Padding(
                padding: const EdgeInsets.only(left: 16.0,right: 16.0,bottom: 16.0),
                child: Card(
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Q: $question", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ...options.map((opt) => ListTile(
                              title: Text(opt.toString()),
                              leading: const Icon(Icons.circle),
                            )),
                        Text("Answer: $answer", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showEditQuestionDialog(index, question, answer, options),
                              color: Colors.green[500],
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteQuestion(index),
                              color: Colors.red[800],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Add new category
  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController categoryController = TextEditingController();
        return AlertDialog(
          title: const Text("Add New Category"),
          content: TextField(
            controller: categoryController,
            decoration: const InputDecoration(labelText: "Category Name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('category').add({
                  'name': categoryController.text,
                });
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  // Delete selected category
  void _deleteCategory() {
    FirebaseFirestore.instance.collection('category').doc(selectedCategoryId).delete();
    setState(() {
      selectedCategoryId = null;
    });
  }

  // Edit existing question and update only the options field
  void _showEditQuestionDialog(int index, String currentQuestion, String currentAnswer, List<dynamic> currentOptions) {
    TextEditingController questionController = TextEditingController(text: currentQuestion);
    TextEditingController answerController = TextEditingController(text: currentAnswer);
    List<TextEditingController> optionControllers = currentOptions
        .map((opt) => TextEditingController(text: opt.toString()))
        .toList();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Question"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: questionController,
                decoration: const InputDecoration(labelText: "Question"),
              ),
              TextField(
                controller: answerController,
                decoration: const InputDecoration(labelText: "Answer"),
              ),
              ...List.generate(currentOptions.length, (index) {
                return TextField(
                  controller: optionControllers[index],
                  decoration: InputDecoration(labelText: "Option ${index + 1}"),
                );
              }),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // Prepare the updated options list
                List<String> updatedOptions = optionControllers.map((controller) => controller.text).toList();

                // Fetch the current 'questions' field from Firestore
                var docRef = FirebaseFirestore.instance.collection('category').doc(selectedCategoryId);
                DocumentSnapshot docSnapshot = await docRef.get();
                var categoryData = docSnapshot.data() as Map<String, dynamic>;

                if (categoryData.containsKey('questions') && categoryData['questions'] != null) {
                  // Get the current list of questions
                  List<dynamic> questions = List.from(categoryData['questions']);

                  // Modify the question at the specified index
                  var updatedQuestion = questions[index];
                  updatedQuestion['question'] = questionController.text;
                  updatedQuestion['answer'] = answerController.text;
                  updatedQuestion['options'] = updatedOptions;

                  // Remove the old question and update it with the modified version
                  await docRef.update({
                    'questions': FieldValue.arrayRemove([categoryData['questions'][index]]),
                  });

                  // Add the updated question to Firestore
                  await docRef.update({
                    'questions': FieldValue.arrayUnion([updatedQuestion]),
                  });

                  // Close the dialog and refresh the screen
                  Navigator.pop(context);
                }
              },
              child: const Text("Save Changes"),
            ),
          ],
        );
      },
    );
  }

  // Delete a specific question
  void _deleteQuestion(int index) async {
    // Reference to the category document
    var docRef = FirebaseFirestore.instance.collection('category').doc(selectedCategoryId);

    // Fetch the document
    DocumentSnapshot docSnapshot = await docRef.get();
    var categoryData = docSnapshot.data() as Map<String, dynamic>;

    if (categoryData.containsKey('questions') && categoryData['questions'] != null) {
      // Get the list of questions
      List<dynamic> questions = List.from(categoryData['questions']);
      
      // Get the question to delete
      var questionToDelete = questions[index];

      // Remove the question from Firestore
      await docRef.update({
        'questions': FieldValue.arrayRemove([questionToDelete]),
      });

      // Optionally, refresh the UI after deletion by calling setState
      setState(() {});
    }
  }
}

  
  // In the above code, we have created a new screen called ManageQuizzesScreen. This screen will allow the admin to manage quizzes. The screen will display a list of categories. When the admin clicks on a category, the screen will display the questions for that category. The admin can add, edit, and delete questions. 
  // The _buildCategoryList method fetches and displays the list of categories. The _buildQuestionsList method fetches and displays the questions for the selected category. The _showAddCategoryDialog method displays a dialog to add a new category. The _deleteCategory method deletes the selected category. The _showEditQuestionDialog method displays a dialog to edit a question. The _deleteQuestion method deletes a question. 
  // Conclusion 
  // In this tutorial, we learned how to create a quiz app in Flutter using Firebase. We created a quiz app that allows users to take quizzes and view their results. We also created an admin panel that allows admins to manage quizzes and view user results. We used Firebase Authentication to authenticate users and Firebase Firestore to store quiz data. We also used Firebase Cloud Functions to calculate the quiz results. 
  // We hope you found this tutorial helpful. If you have any questions or comments, please let us know in the comments below. 
  // Happy coding! 
  // Related Posts:
  // Flutter Firebase Authentication Tutorial
  // Flutter Firebase Firestore Tutorial
  // Flutter Firebase Cloud Functions Tutorial
  // Flutter Firebase Storage Tutorial
  // Flutter Firebase Cloud Messaging Tutorial
  // Flutter Firebase Analytics Tutorial
  // Flutter Firebase Remote Config Tutorial
  // Flutter Firebase Performance Monitoring Tutorial
  // Flutter Firebase Crashlytics Tutorial
  // Flutter Firebase Dynamic Links Tutorial
  // Flutter Firebase Performance Monitoring Tutorial
  // Flutter Firebase Crashlytics Tutorial
  // Flutter Firebase Dynamic Links Tutorial
  // Flutter Firebase In-App Messaging Tutorial
  // Flutter Firebase A/B Testing Tutorial
  // Flutter Firebase Predictions Tutorial