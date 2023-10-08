import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/Features/Home/data/model/taskModel.dart';
import 'package:todoapp/Features/Home/preasentation/views/todo_homeview/widgets/task_Item.dart';
import 'package:todoapp/core/services/notification_service.dart';

class TaskListView extends StatelessWidget {
  const TaskListView(
      {super.key, required this.taskList, required this.bottomSheet});
  final List<TaskModel> taskList;
  final Function(BuildContext context, TaskModel task) bottomSheet;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      primary: false,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => const SizedBox(
        height: 10,
      ),
      itemCount: taskList.length,
      itemBuilder: (context, index) {
        TaskModel task = taskList[index];
        if (task.repeat == "Daily") {
          DateTime date = DateFormat('HH:mm').parse(task.startTime!);

          String myTime = DateFormat('HH:mm').format(date);

          NotifyHelper.showScheduleNotification(
                  hour: int.parse(myTime.toString().split(':')[0]),
                  minutes: int.parse(myTime.toString().split(':')[1]),
                  task: task)
              .then((value) => print('this is $value'));
        }

        return GestureDetector(
            onTap: () {
              bottomSheet(context, taskList[index]);
            },
            child: TaskItem(
              index: index,
              task: taskList[index],
            ));
      },
    );
  }
}
