import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:todoapp/Features/Home/data/model/taskModel.dart';
import 'package:todoapp/core/appthemes/appthemes.dart';
import 'package:todoapp/core/services/service_locator.dart';
import 'package:todoapp/core/services/themes_services.dart';

import '../../../../../constants.dart';
import '../../../../../core/services/sqflite_helper.dart';

part 'Task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(Checkediconinitial());
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController repeatController = TextEditingController();
  GlobalKey formkey = GlobalKey();

  int selectedIndex = 0;
  DateTime? pickedDate = DateTime.now();
  String pickedStartTime = DateFormat('hh:mm a').format(DateTime.now());
  String pickedEndTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(hours: 4)));
  bool isDarkTheme = false;

  void changeThemes() {
    isDarkTheme = !isDarkTheme;
    ThemeService().switchMode(isDarkTheme);
    emit(GetDataSuccess());
  }

  void switchThemeMode(bool isDarketheme) {
    isDarketheme ? ThemeMode.light : ThemeMode.dark;
  }

  ThemeMode themeMode() {
    return ThemeService().getThemeMode();
  }

  List<TaskModel> tasks = [];

  DateTime selectedDate = DateTime.now();

  void selectDate(DateTime pickedate) {
    emit(SelectDateLoading());
    selectedDate = pickedate;
    emit(SelectDateSuccess());
    getdata();
  }

  Future<void> getdata() async {
    print('getdata get CAllled');

    emit(GetDataLoading());
    try {
      await getit<SqfliteHelper>().getFromDB().then((value) {
        tasks = value
            .map(
              //               CREATE TABLE Tasks(
              // id INTEGER PRIMARY KEY AUTOINCREMENT,
              // title TEXT,
              // note TEXT,
              // date TEXT,
              // startTime TEXT,
              // endTime TEXT,
              // isCompleted INTEGER,
              // color INTEGER,
              // repeat TEXT
              // )
              (task) => TaskModel(
                id: task['id'] as int,
                title: task['title'] as String,
                note: task['note'] as String,
                date: task['date'] as String,
                startTime: task['startTime'] as String,
                endTime: task['endTime'] as String,
                isCompleted: task['isCompleted'] as int,
                color: task['color'] as int,
                repeat: task['repeat'] as String,
              ),
            )
            .toList()
            .where((e) => e.date == DateFormat.yMd().format(selectedDate))
            .toList();
        print(DateFormat.yMd().format(selectedDate));

        emit(GetDataSuccess());
      });
    } catch (e) {
      emit(GetDataFailure());
    }
  }

  addTask() async {
    emit(AddTaskLoading());

    try {
      await Future.delayed(const Duration(seconds: 2));

      await getit<SqfliteHelper>().insertToDB(TaskModel(
        note: " ${noteController.text}".trim(),
        title: titleController.text.trim(),
        date: DateFormat.yMd().format(pickedDate!),
        startTime: pickedStartTime,
        endTime: pickedEndTime,
        isCompleted: 0,
        color: selectedIndex,
        repeat: repeat,
      ));
      noteController.clear();
      titleController.clear();

      emit(AddTaskSuccess());
      await getdata();
      print('added successfully');
    } catch (e) {
      emit(AddTaskFailure());
    }
  }

  upbdateTask(int id) async {
    await getit<SqfliteHelper>().updatedDB(id).then((value) {
      emit(UpdateDataLoading());
      try {
        getdata();
        emit(UpdateDataSuccess());
      } catch (e) {
        emit(UpdateDataFailure());
      }
    });
  }

  deletTask(int id) async {
    emit(DeleteDataLoading());

    await getit<SqfliteHelper>().deleteFromDB(id).then((value) {
      getdata();

      emit(DeleteDataSuccess());
    }).catchError((e) {
      emit(DeleteDataFailure());
    });
  }

  Color getColor(int index) {
    switch (index) {
      case 0:
        return kprimaryColor;
      case 1:
        return Colors.greenAccent;
      case 2:
        return Colors.blueGrey;
      case 3:
        return Colors.amberAccent;
      case 4:
        return Colors.brown;
      case 5:
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  void changeIndex(int index) {
    selectedIndex = index;

    emit(CheckediconChange());
  }

  void showTaskDatePicker(BuildContext context) async {
    emit(GetDateLoading());

    var startDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2025));
    if (startDate != null) {
      pickedDate = startDate;

      emit(GetDateSuccess());
    } else {
      emit(GetDateFailure());
    }
  }

  void showEndTimePicker(BuildContext context) async {
    emit(GetEndTimeLoading());
    try {
      TimeOfDay? endTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(DateTime.now()));
      pickedEndTime = endTime!.format(context);
      emit(GetEndTimeSuccess());
    } catch (e) {
      print(e.toString());
      emit(GetEndTimeFailure());
    }
  }

  void showStartTimePicker(BuildContext context) async {
    emit(GetStartTimeLoading());

    try {
      TimeOfDay? startTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(DateTime.now()));
      pickedStartTime = startTime!.format(context);
      emit(GetStartTimeSuccess());
    } catch (e) {
      emit(GetStartTimeFailure());
    }
  }

  String repeat = '';
  void getRepeatTextFieldvalue(String repeatTime) {
    repeat = repeatTime;
  }
}
