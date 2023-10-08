import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/Features/Home/preasentation/controllers/cubit/Task_cubit.dart';
import 'package:todoapp/Features/Home/preasentation/views/add_tasks_view/add_taskview.dart';
import 'package:todoapp/Features/Home/preasentation/views/todo_homeview/to_do_homeview.dart';
import 'package:todoapp/Features/Home/preasentation/views/todo_homeview/widgets/task_listview.dart';
import 'package:todoapp/Features/Home/preasentation/views/todo_homeview/widgets/to_do_homeview_appbar.dart';
import 'package:todoapp/constants.dart';
import 'package:todoapp/core/services/notification_service.dart';
import 'package:todoapp/core/widgets/CustomButton.dart';
import '../../../../data/model/taskModel.dart';

class ToDoHomeViewBody extends StatefulWidget {
  ToDoHomeViewBody({super.key});

  @override
  State<ToDoHomeViewBody> createState() => _ToDoHomeViewBodyState();
}

class _ToDoHomeViewBodyState extends State<ToDoHomeViewBody> {
  final DateTime _selectedDate = DateTime.now();

  int selectedItem = 0;
  @override
  void initState() {
    // NotifyHelper.onClickNotification.stream.listen((event) {
    //   Navigator.of(context)
    //       .push(MaterialPageRoute(builder: (context) => ToDoHomeView()));
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (ctx, state) {
        final taskCubit = BlocProvider.of<TaskCubit>(ctx);
        return Padding(
          padding: const EdgeInsets.only(top: 30, left: 20, right: 10),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              const ToDoHomeViewappBar(),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(
                      '${DateFormat.MEd().format(DateTime.now())} Today',
                      maxLines: 2,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  CustomTextButton(
                    text: '+ Add Task',
                    color: const Color(0xffecc19c),
                    onpressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AddTaskView()));
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              _showDatePicker(taskCubit),
              const SizedBox(
                height: 40,
              ),
              _showTasksView(state, taskCubit)
            ],
          ),
        );
      },
    );
  }

  Widget _showTasksView(TaskState state, TaskCubit taskCubit) {
    if (state is GetDataLoading) {
      return CircularProgressIndicator();
    } else if (state is GetDataSuccess) {
      return taskCubit.tasks.isNotEmpty
          ? TaskListView(
              bottomSheet: _showModalBottomSheet,
              taskList: taskCubit.tasks,
            )
          : _NoTasks();
    } else {
      return _NoTasks();
    }
  }

  DatePicker _showDatePicker(TaskCubit taskcubit) {
    return DatePicker(
      width: 60,
      height: 90,
      DateTime.now(),
      initialSelectedDate: DateTime.now(),
      monthTextStyle:
          const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      dayTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      dateTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      selectionColor: kprimaryColor,
      selectedTextColor: Colors.white,
      onDateChange: (date) {
        taskcubit.selectDate(date);
      },
    );
  }

  void _showModalBottomSheet(BuildContext context, TaskModel task) {
    WidgetsFlutterBinding.ensureInitialized();
    showBottomSheet(
        context: context,
        builder: (ctx) {
          return Container(
            padding: const EdgeInsets.all(20),
            height: 350,
            color: Colors.grey[800]!.withOpacity(0.2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (task.isCompleted == 0)
                  CustomTextButton(
                    text: 'TASK COMPLETED',
                    color: kprimaryColor,
                    onpressed: () {
                      BlocProvider.of<TaskCubit>(context).upbdateTask(task.id!);
                      Navigator.of(context).pop();
                    },
                  ),
                CustomTextButton(
                  text: 'DELETE TASK',
                  color: const Color(0xFFff4667),
                  onpressed: () {
                    BlocProvider.of<TaskCubit>(context).deletTask(task.id!);
                    Navigator.of(context).pop();
                  },
                ),
                CustomTextButton(
                  text: 'CANCEL',
                  color: Colors.blueGrey,
                  onpressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        });
  }

  Widget _NoTasks() {
    return Container(
      width: double.infinity,
      alignment: Alignment.bottomCenter,
      height: 400,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/images/tasks-list.svg',
            height: 150,
            width: 100,
            color: kprimaryColor.withOpacity(0.7),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'You do not have any tasks yet!',
          ),
          const SizedBox(
            height: 10,
          ),
          const Text('Add new tasks '),
          const SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }
}
