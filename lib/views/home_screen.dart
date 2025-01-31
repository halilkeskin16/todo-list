import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/service/database.dart';
import 'package:todo_app/views/add_task_screen.dart';
import 'package:todo_app/views/task_detail_screen.dart';

enum TaskFilter { all, done, pending }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];
  TaskFilter taskFilter = TaskFilter.all;
  Task? selectedTask;
  bool isLandscape = false;

  @override
  void initState() {
    super.initState();
    _loadAllTasks();
  }

  Future<void> _loadAllTasks() async {
    tasks = await DatabaseHelper().getTasks();
    setState(() {});
  }

  Future<void> _deleteTask(int id) async {
    await DatabaseHelper().deleteTask(id);
    _loadAllTasks();
  }

  @override
  Widget build(BuildContext context) {
    isLandscape = MediaQuery.of(context).size.width > 700;
    return Scaffold(
      appBar: AppBar(title: const Text('Your To-Do List')),
      body: isLandscape
          ? Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      buildToggleButtons(),
                      const SizedBox(height: 10),
                      Expanded(child: taskListWidget()),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.grey[200],
                    child: selectedTask != null
                        ? TaskDetailScreen(task: selectedTask!)
                        : const Center(
                            child: Text('Select a task to see details'),
                          ),
                  ),
                ),
              ],
            )
          : Column(
              children: [
                const SizedBox(height: 10),
                buildToggleButtons(),
                const SizedBox(height: 10),
                Expanded(child: taskListWidget()),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
          if (result == true) {
            _loadAllTasks();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildToggleButtons() {
    return ToggleButtons(
      isSelected: [
        taskFilter == TaskFilter.all,
        taskFilter == TaskFilter.done,
        taskFilter == TaskFilter.pending
      ],
      onPressed: (index) {
        setState(() {
          taskFilter = TaskFilter.values[index];
        });
      },
      borderRadius: BorderRadius.circular(12),
      selectedColor: Colors.white,
      fillColor: Colors.blue,
      color: Colors.black,
      constraints: const BoxConstraints(minWidth: 100, minHeight: 40),
      children: const [
        Text("All"),
        Text("Done"),
        Text("Pending"),
      ],
    );
  }

  Widget taskListWidget() {
    List<Task> filteredTasks = [];
    switch (taskFilter) {
      case TaskFilter.all:
        filteredTasks = tasks;
        break;
      case TaskFilter.done:
        filteredTasks = tasks.where((task) => task.isCompleted).toList();
        break;
      case TaskFilter.pending:
        filteredTasks = tasks.where((task) => !task.isCompleted).toList();
        break;
    }
    return filteredTasks.isEmpty
        ? Center(
            child: SizedBox(
              height: 200,
              child: Image.asset('assets/images/notaddedyet.png'),
            ),
          )
        : ListView.builder(
            itemCount: filteredTasks.length,
            itemBuilder: (context, index) {
              final task = filteredTasks[index];
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: task.isCompleted ? Colors.green[100] : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(8),
                  title: Text(
                    task.title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 17),
                      ),
                      Text(
                        task.date!.toString().substring(0, 16),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: task.isCompleted,
                        onChanged: (value) {
                          setState(() {
                            task.isCompleted = value!;
                          });
                          DatabaseHelper().updateTask(task);
                          _loadAllTasks();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Delete Task'),
                                content: const Text(
                                    'Are you sure you want to delete?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _deleteTask(task.id!);
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    if (isLandscape) {
                      setState(() {
                        if (selectedTask?.id == task.id) {
                          selectedTask = null;
                        } else {
                          selectedTask = Task(
                            id: task.id,
                            title: task.title,
                            description: task.description,
                            isCompleted: task.isCompleted,
                            date: task.date,
                          );
                        }
                      });
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TaskDetailScreen(task: task)),
                      ).then((value) {
                        if (value == true) {
                          _loadAllTasks();
                        }
                      });
                    }
                  },
                ),
              );
            },
          );
  }
}
