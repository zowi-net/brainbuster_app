import 'package:brainbuster/model/question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'questions_screen.dart'; // Import the new screen

class Braincategory extends StatefulWidget {
  const Braincategory({super.key});

  @override
  State<Braincategory> createState() => _BraincategoryState();
}

class _BraincategoryState extends State<Braincategory> {
  Stream<List<String>> getCategoryIdStream() {
    return FirebaseFirestore.instance.collection('category').snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => doc.id).toList(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Text("Category"),
            Expanded(
              child: StreamBuilder<List<String>>(
                stream: getCategoryIdStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docIds = snapshot.data!;

                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1,
                    ),
                    itemCount: docIds.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuestionsScreen(categoryId: docIds[index]),
                            ),
                          );
                        },
                        child: Card(
                          child: Center(
                            child: Text(docIds[index]),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class QuestionsScreen extends StatefulWidget {
  final String categoryId;

  const QuestionsScreen({super.key, required this.categoryId});

  @override
  _QuestionsScreenState createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Questions for Category ${widget.categoryId}'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('category').doc(widget.categoryId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Question: ${data['question'] ?? 'No question available'}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  RadioListTile<String>(
                    title: Text('Option 1: ${data['option1'] ?? 'No option available'}'),
                    value: data['option1'] ?? 'No option available',
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('Option 2: ${data['option2'] ?? 'No option available'}'),
                    value: data['option2'] ?? 'No option available',
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('Option 3: ${data['option3'] ?? 'No option available'}'),
                    value: data['option3'] ?? 'No option available',
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('Option 4: ${data['option4'] ?? 'No option available'}'),
                    value: data['option4'] ?? 'No option available',
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Handle the submission of the selected option
                      if (_selectedOption != null) {
                        bool isCorrect = _selectedOption == data['answer'];
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isCorrect
                                ? 'Correct! You selected: $_selectedOption'
                                : 'Incorrect. The correct answer is: ${data['answer']}'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select an option'),
                          ),
                        );
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text("No data available"));
          }
        },
      ),
    );
  }
}


// class QuestionsScreen extends StatelessWidget {
//   final String categoryId;

//   const QuestionsScreen({super.key, required this.categoryId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Questions for Category $categoryId'),
//       ),
//       body: StreamBuilder<DocumentSnapshot>(
//         stream: FirebaseFirestore.instance.collection('category').doc(categoryId).snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (snapshot.hasData && snapshot.data != null) {
//             Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
//             return ListView(
//               children: [
//                 ListTile(
//                   title: Text('Question: ${data['question']}'),
//                 ),
//                 ListTile(
//                   title: Text('Option 1: ${data['option1']}'),
//                 ),
//                 ListTile(
//                   title: Text('Option 2: ${data['option2']}'),
//                 ),
//                 ListTile(
//                   title: Text('Option 3: ${data['option3']}'),
//                 ),
//                 ListTile(
//                   title: Text('Option 4: ${data['option4']}'),
//                 ),
//                 // Add more widgets to display other question details
//               ],
//             );
//           } else {
//             return const Center(child: Text("No data available"));
//           }
//         },
//       ),
//     );
//   }
// }


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class Braincategory extends StatefulWidget {
//   const Braincategory({super.key});

//   @override
//   State<Braincategory> createState() => _BraincategoryState();
// }

// class _BraincategoryState extends State<Braincategory> {
//     // Stream function to fetch category IDs in real-time
//   Stream<List<String>> getCategoryIdStream() {
//     return FirebaseFirestore.instance.collection('category').snapshots().map(
//       (snapshot) => snapshot.docs.map((doc) => doc.id).toList(),
//     );
//   }





//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       body: SafeArea(
//         child:Column(
//   children: [
//     const Text("Category"),
//     Expanded(
//       child: StreamBuilder<List<String>>( // Specify your stream type
//         stream: getCategoryIdStream(), // Your stream source
//         builder: (context, snapshot) {
//           // Handle stream states
//           if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           }

//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final docIds = snapshot.data!; // Your stream data

//           return GridView.builder(
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               mainAxisSpacing: 8,
//               crossAxisSpacing: 8,
//               childAspectRatio: 1,
//             ),
//             itemCount: docIds.length,
//             itemBuilder: (context, index) {
//               return Card(
//                 child: Center(
//                   child: Text(docIds[index]),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     ),
//   ],
// ),
//       ),
//     );
//   }
// }






// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

// class Braincategory extends StatefulWidget {
//   const Braincategory({super.key});

//   @override
//   State<Braincategory> createState() => _BraincategoryState();
// }

// class _BraincategoryState extends State<Braincategory> {
  
//   List<String> docIds = [];

//   Future getDocIds() async{
//     await FirebaseFirestore.instance.collection('category').get().then(
//       (snapshotcategory) => snapshotcategory.docs.forEach(
//         (document){
//             print(document.reference);
//             docIds.add(document.id);
//         }
//       ),
//     );
//   }



//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: SafeArea(
//           child: Column(
//             children: [
//               Expanded(
//                 child:  FutureBuilder(
//                    future: getDocIds(),
//                    builder: (context, snapshot) {
//                      return ListView.builder(
//                   itemCount: docIds.length,
//                   itemBuilder: (context, index) {
//                     return  ListTile(
//                       title: GetQuestionName(documentId: docIds[index]),
//                     );
//                   } 
                  
//                   );
//                 }),
//               )
//             ],
//           ),
//         ),
//       );
//   }
// }

// class GetQuestionName extends StatelessWidget {
  
//   final String documentId;

//     GetQuestionName({required this.documentId});


//     //get the collection
//     CollectionReference questions = FirebaseFirestore.instance.collection('category');

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: questions.doc(documentId).get(), 
//       builder: (context, snapshot){
//           if(snapshot.connectionState == ConnectionState.done){
          
//             Map<String, dynamic> data = 
//             snapshot.data!.data() as Map<String, dynamic>; 
          
//           return Text('First question: ${data['question']}');
             
//           }
//           return const Text("no data");
//       }
//       );
//   }
// }

