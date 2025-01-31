import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/service/database.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}
class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center ,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(          
              maxLines: 3,   
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Task Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async{
                Task tast = Task(
                  title: _titleController.text,
                  description: _descriptionController.text,
                  isCompleted: false,
                  date: DateTime.now(),
                );
                if(tast.title.isEmpty && tast.description.isEmpty){
                  showDialog(context: context, builder: (context){
                    return AlertDialog(
                      title: const Text('Error'),
                      content: const Text('Please fill all fields'),
                      actions: [
                        TextButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  });
                }else{
                  await DatabaseHelper().insertTask(tast);
                }      
                Navigator.pop(context , true);
              },
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}