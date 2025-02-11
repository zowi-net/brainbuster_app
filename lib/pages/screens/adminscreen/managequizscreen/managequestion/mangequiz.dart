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
        return ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            var category = categories[index];
            return ListTile(
              title: Text(category.id),
              onTap: () {
                setState(() {
                  selectedCategoryId = category.id;
                });
              },
            );
          },
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

        return ListView.builder(
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




// import 'package:brainbuster/pages/screens/adminscreen/managequizscreen/addquestions/addquestion.dart';
// import 'package:brainbuster/services/database.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';  // Import the intl package for date formatting

// class ManageQuizzesScreen extends StatefulWidget {
//   const ManageQuizzesScreen({super.key});

//   @override
//   State<ManageQuizzesScreen> createState() => _ManageQuizzesScreenState();
// }

// class _ManageQuizzesScreenState extends State<ManageQuizzesScreen> {
//   final Database db = Database();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[300],
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.brown[300],
//         child: const Icon(Icons.add),
//         onPressed: () {
//           // Navigator.pushNamed(context, '/addquiz');
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const AddQuestionsScreen(),
//             ),
//           );
//         },
//       ),
//       appBar: AppBar(
//         title: const Text('Manage Quizzes'),
//         backgroundColor: Theme.of(context).colorScheme.primaryContainer,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Colors.blue.shade200,
//               Colors.purple.shade200,
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: StreamBuilder<QuerySnapshot>(
//           stream: db.readData(),
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return const Center(
//                 child: Text('Something went wrong'),
//               );
//             } else if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
//               var quizzes = snapshot.data!.docs;

//               return ListView.builder(
//                 itemCount: quizzes.length,
//                 itemBuilder: (context, index) {
//                   final quiz = quizzes[index];
//                   // Extract the necessary fields
//                   final String answer = quiz['answer'] ?? 'No Answer';
//                   final Timestamp timestamp = quiz['date'];
//                   final String option1 = quiz['option1'] ?? 'No Option';
//                   final String option2 = quiz['option2'] ?? 'No Option';
//                   final String option3 = quiz['option3'] ?? 'No Option';
//                   final String option4 = quiz['option4'] ?? 'No Option';
//                   final String question = quiz['question'] ?? 'No Question';
                  
//                   // Format the timestamp to a readable date
//                   String formattedDate = DateFormat('d MMM yyyy at h:mm a').format(timestamp.toDate());

//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                     elevation: 6,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     // Apply a refined gradient background to the card
//                     color: Colors.transparent,
//                     child: Ink(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(16),
//                         gradient: LinearGradient(
//                           colors: [
//                             Colors.blue.shade50,
//                             Colors.purple.shade50,
//                           ],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                       ),
//                       child: ListTile(
//                         title: Text(
//                           question,
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Answer: $answer',
//                               style: const TextStyle(fontSize: 14),
//                             ),
//                             Text(
//                               'Date: $formattedDate',
//                               style: const TextStyle(fontSize: 12, color: Colors.grey),
//                             ),
//                             const SizedBox(height: 8),
//                             const Text(
//                               'Options:',
//                               style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                             ),
//                             Text('1. $option1'),
//                             Text('2. $option2'),
//                             Text('3. $option3'),
//                             Text('4. $option4'),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             } else {
//               return const Center(
//                 child: Text('No quizzes available'),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
