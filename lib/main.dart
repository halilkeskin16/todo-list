import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:todo_app/service/controller/controller.dart';
import 'package:todo_app/views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

await AppBinding().dependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do App',
      theme: ThemeData.light(), 
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: HomeScreen(),
    );
  }
}

class AppBinding extends Bindings {
  @override
  Future<void> dependencies()async {
    await Get.putAsync(()async=>Controller(), permanent: true);
  }
}
