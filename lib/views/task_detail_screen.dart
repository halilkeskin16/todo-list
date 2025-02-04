  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
  import 'package:todo_app/models/task.dart';
  import 'package:todo_app/service/controller/controller.dart';

  class TaskDetailScreen extends StatefulWidget {
    final Task task;

    const TaskDetailScreen({super.key, required this.task});

    @override
    State<TaskDetailScreen> createState() => _TaskDetailScreenState();
  }

  class _TaskDetailScreenState extends State<TaskDetailScreen> {
    late TextEditingController _titleController;
    late TextEditingController _descriptionController;
    final Controller controller = Get.find<Controller>();
    bool isLandscape = false;

    @override
    void initState() {
      super.initState();
    }

    Future<void> _updateTask() async {
      Task updatedTask = Task(
        id: widget.task.id,
        title: _titleController.text,
        description: _descriptionController.text,
        date: widget.task.date, 
        isCompleted: widget.task.isCompleted, 
      );
      await controller.updateTask(updatedTask);
    }

    @override
    Widget build(BuildContext context) {
      _titleController = TextEditingController(text: controller.selectedTask.value?.title ?? "");
      _descriptionController = TextEditingController(text: controller.selectedTask.value?.description ?? "");
      isLandscape = MediaQuery.of(context).size.width > 700;
      return Scaffold(
        appBar: AppBar(title: const Text("Task Details")),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 10),
                Text(
                  "Created: ${widget.task.date!.toString().substring(0, 16)}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  "Status: ${widget.task.isCompleted ? "Completed" : "Pending"}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: (){
                    _updateTask();
                    Get.back();
                  },
                  child: const Text("Update Task"),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
