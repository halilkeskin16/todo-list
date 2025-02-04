import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/service/database.dart';
import 'package:todo_app/views/home_screen.dart';

class Controller extends GetxController {
  RxList<Task> tasks = <Task>[].obs;
  TaskFilter taskFilter = TaskFilter.all;
  Rx<Task?> selectedTask = Rx<Task?>(null);
  RxBool isLight = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllTasks();
  }

  Future<void> loadAllTasks() async {
    List<Task> loadedTasks = await DatabaseHelper().getTasks();
    tasks.assignAll(loadedTasks);
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

  void changeThemeMode() {
    isLight.value = !isLight.value;
  }

  void selectedTaskDetails(Task task) {
    selectedTask.value = task;
  }
}
