import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/service/database.dart';
import 'package:todo_app/views/home_screen.dart';

class Controller extends GetxController {
  List<Task> tasks = [];
  TaskFilter taskFilter = TaskFilter.all;
  Task? selectedTask;
  @override
  void onInit() {
    super.onInit();
    loadAllTasks();
  }
  Future<void> loadAllTasks() async {
    tasks = await DatabaseHelper().getTasks();
    update();
  }
  Future<void> deleteTask(int id) async {
    await DatabaseHelper().deleteTask(id);
    loadAllTasks();
  }
  Future<void> insertTask(Task task) async {
  await DatabaseHelper().insertTask(task);
  loadAllTasks();
}
Future<void> updateTask(Task task) async {
  await DatabaseHelper().updateTask(task);
  loadAllTasks();
}
}