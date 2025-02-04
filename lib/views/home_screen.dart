import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/service/controller/controller.dart';
import 'package:todo_app/views/add_task_screen.dart';
import 'package:todo_app/views/task_detail_screen.dart';

enum TaskFilter { all, done, pending }

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final Controller getController = Get.find();

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).size.width > 700;
    bool isLight = getController.isLight.value;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your To-Do List'),
        leading: IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            getController.loadAllTasks();
          },
        ),
        actions: [
          IconButton(
            icon: Obx(
              () => getController.isLight.value
                  ? const Icon(Icons.light_mode)
                  : const Icon(Icons.dark_mode),
            ),
            onPressed: () {
              isLight = !isLight;
              getController.changeThemeMode();
              Get.changeThemeMode(isLight ? ThemeMode.light : ThemeMode.dark);
            },
          ),
        ],
      ),
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
                  child: GetBuilder<Controller>(
                    builder: (controller) {
                      return getController.selectedTask.value != null
                          ? TaskDetailScreen(task: getController.selectedTask.value!)
                          : const Center(
                              child: Text(
                                'Select a task to see details',
                                style: TextStyle(),
                              ),
                            );
                    },
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
            getController.loadAllTasks();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildToggleButtons() {
    return GetBuilder<Controller>(
      builder: (controller) {
        return ToggleButtons(
          isSelected: [
            controller.taskFilter == TaskFilter.all,
            controller.taskFilter == TaskFilter.done,
            controller.taskFilter == TaskFilter.pending
          ],
          onPressed: (index) {
            controller.taskFilter = TaskFilter.values[index];
            controller.update();
          },
          borderRadius: BorderRadius.circular(12),
          selectedColor: Colors.white,
          fillColor: controller.isLight.value ? Colors.blue : Colors.blueGrey,
          color: controller.isLight.value ? Colors.black : Colors.white,
          constraints: const BoxConstraints(minWidth: 100, minHeight: 40),
          children: const [
            Text("All"),
            Text("Done"),
            Text("Pending"),
          ],
        );
      },
    );
  }

  Widget taskListWidget() {
    return GetBuilder<Controller>(
      builder: (controller) {
        List<Task> filteredTasks = [];
        switch (controller.taskFilter) {
          case TaskFilter.all:
            filteredTasks = controller.tasks;
            break;
          case TaskFilter.done:
            filteredTasks =
                controller.tasks.where((task) => task.isCompleted).toList();
            break;
          case TaskFilter.pending:
            filteredTasks =
                controller.tasks.where((task) => !task.isCompleted).toList();
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
                      color:
                          task.isCompleted ? Colors.green[100] : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(8),
                      title: Text(
                        task.title,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 17, color: Colors.black),
                          ),
                          Text(
                            task.date!.toString().substring(0, 16),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            activeColor: Colors.green,
                            value: task.isCompleted,
                            onChanged: (value) {
                              task.isCompleted = value!;
                              controller.updateTask(task);
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
                                          controller.deleteTask(task.id!);
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
                        if (MediaQuery.of(context).size.width > 700) {
                          controller.selectedTaskDetails(task);
                          controller.update();
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TaskDetailScreen(task: task)),
                          ).then((value) {
                            if (value == true) {
                              controller.loadAllTasks();
                            }
                          });
                        }
                      },
                    ),
                  );
                },
              );
      },
    );
  }

}
