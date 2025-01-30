import 'package:flutter/material.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final TextEditingController questionController = TextEditingController();
  final TextEditingController option1Controller = TextEditingController();
  final TextEditingController option2Controller = TextEditingController();
  final TextEditingController option3Controller = TextEditingController();
  final TextEditingController option4Controller = TextEditingController();
  final TextEditingController answerController = TextEditingController();

  // final DatabaseCategory databaseCategory = DatabaseCategory();

  String selectedCategory = 'biology'; // Default category

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Question')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedCategory,
              items: ['biology', 'chemistry', 'math']
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),
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
              decoration: const InputDecoration(labelText: 'Correct Answer'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: (){},
              child: const Text('Add Question'),
            ),
          ],
        ),
      ),
    );
  }
}
