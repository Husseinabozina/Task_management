import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/Features/Home/preasentation/controllers/cubit/Task_cubit.dart';
import 'package:todoapp/Features/Home/preasentation/views/todo_homeview/to_do_homeview.dart';
import 'package:todoapp/core/appthemes/appthemes.dart';
import 'package:todoapp/core/services/sqflite_helper.dart';
import 'package:todoapp/core/services/notification_service.dart';

import 'core/services/service_locator.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotifyHelper().initializeNotification();

  setUp();
  await getit<SqfliteHelper>().initDb();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskCubit>(
        create: (context) => TaskCubit()..getdata(),
        child: BlocBuilder<TaskCubit, TaskState>(
          builder: (context, state) {
            final taskCubit = BlocProvider.of<TaskCubit>(context);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              themeMode: taskCubit.themeMode(),
              theme: AppThemes.light,
              darkTheme: AppThemes.dark,
              home: const ToDoHomeView(),
            );
          },
        ));
  }
}
