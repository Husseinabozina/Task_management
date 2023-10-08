import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';
import 'package:todoapp/Features/Home/preasentation/controllers/cubit/Task_cubit.dart';
import 'package:todoapp/Features/Home/preasentation/views/add_tasks_view/widgets/task_components.dart';
import 'package:todoapp/core/function/commonsfun.dart';
import 'package:todoapp/core/widgets/CustomButton.dart';

class AddTaskViewBody extends StatefulWidget {
  const AddTaskViewBody({super.key});

  @override
  State<AddTaskViewBody> createState() => _AddTaskViewBodyState();
}

class _AddTaskViewBodyState extends State<AddTaskViewBody> {
  int _selectedRemind = 5;
  String _selectedRepeat = 'Daily';
  List<int> remindList = [5, 10, 15, 20];
  List<String> repeatList = ['Daily', 'Weakly', 'monthly'];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocConsumer<TaskCubit, TaskState>(
          listener: (context, state) {
            if (state is AddTaskSuccess) {
              showToast(
                  message: 'the task added successfully',
                  state: ToastStates.success);

              Navigator.of(context).pop();
            } else if (state is AddTaskFailure) {
              showToast(
                  message: 'the insirtion failed', state: ToastStates.error);
            }
          },
          builder: (ctx, state) {
            final taskCubit = BlocProvider.of<TaskCubit>(ctx);

            return Form(
              key: taskCubit.formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TaskComponents(
                    validator: (val) {
                      if (val!.isEmpty) {
                        return ' You should enter a title';
                      }
                      return null;
                    },
                    title: 'Title',
                    hintText: 'Enter title here',
                    controller: taskCubit.titleController,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TaskComponents(
                    validator: (val) {
                      if (val!.isEmpty) {
                        return ' You should enter a note';
                      }
                      return null;
                    },
                    title: 'Note',
                    hintText: 'Enter note here',
                    controller: taskCubit.noteController,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TaskComponents(
                    readOnly: true,
                    title: 'Date',
                    hintText: DateFormat.yMd().format(taskCubit.pickedDate!),
                    icon: IconButton(
                      icon: const Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        taskCubit.showTaskDatePicker(ctx);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: TaskComponents(
                        readOnly: true,
                        title: 'Start time',
                        hintText: taskCubit.pickedStartTime,
                        icon: IconButton(
                            onPressed: () {
                              taskCubit.showStartTimePicker(ctx);
                            },
                            icon: const Icon(Icons.access_alarm)),
                      )),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                          child: TaskComponents(
                        readOnly: true,
                        title: 'End time',
                        hintText: taskCubit.pickedEndTime,
                        icon: IconButton(
                            onPressed: () {
                              taskCubit.showEndTimePicker(ctx);
                            },
                            icon: const Icon(Icons.access_alarm)),
                      ))
                    ],
                  ),
                  TaskComponents(
                    readOnly: true,
                    title: 'Remind me',
                    hintText: '${_selectedRemind.toString()}',
                    icon: DropdownButton(
                        onChanged: (newvalue) {
                          setState(() {
                            _selectedRemind = int.parse(newvalue!);
                          });
                        },
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                        elevation: 5,
                        items: List.generate(
                            remindList.length,
                            (index) => DropdownMenuItem<String>(
                                value: remindList[index].toString(),
                                child: Text(remindList[index].toString())))),
                  ),
                  TaskComponents(
                    controller: taskCubit.repeatController,
                    readOnly: true,
                    title: 'Repeat',
                    hintText: '$_selectedRepeat',
                    icon: DropdownButton(
                        onChanged: (newvalue) {
                          taskCubit.getRepeatTextFieldvalue(newvalue ?? '');
                          setState(() {
                            _selectedRepeat = newvalue!;
                          });
                        },
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                        elevation: 5,
                        items: List.generate(
                            repeatList.length,
                            (index) => DropdownMenuItem<String>(
                                value: repeatList[index],
                                child: Text(repeatList[index])))),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    height: 40,
                    width: MediaQuery.of(context).size.width - 50,
                    child: ListView.separated(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                taskCubit.changeIndex(index);
                              });
                            },
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: taskCubit.getColor(index),
                              child: taskCubit.selectedIndex == index
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                              width: 8,
                            ),
                        itemCount: 6),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  (state is AddTaskLoading)
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.infinity,
                          child: CustomTextButton(
                              onpressed: () async {
                                taskCubit.addTask();
                              },
                              text: 'Create Task',
                              color: Color(0xffecc19c)),
                        )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
