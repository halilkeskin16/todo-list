import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/service/database.dart';
import 'package:todo_app/views/home_screen.dart';

class Controller extends GetxController {
  List<Task> tasks = [];
  TaskFilter taskFilter = TaskFilter.all;
  Rx<Task?> selectedTask = Rx<Task?>(null); // selectedTask artık Rx oldu
  RxBool isLight = true.obs;
  RxBool addButtonPressed = false.obs;
  String title = "";
  String description = "";

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

  Future<void> changeThemeMode() async {
    isLight.value = !isLight.value;
    update();
  }

  void selectedTaskDetails(Task task) {
    selectedTask.value = task;
  }
}
