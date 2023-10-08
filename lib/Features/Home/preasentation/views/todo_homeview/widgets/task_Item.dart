import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/Features/Home/data/model/taskModel.dart';
import 'package:todoapp/Features/Home/preasentation/controllers/cubit/Task_cubit.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({
    this.index,
    this.task,
    Key? key,
  }) : super(key: key);

  final TaskModel? task;
  final int? index;

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<TaskCubit>(context);
    return Container(
      padding: const EdgeInsets.only(left: 20),
      height: 170,
      width: double.infinity,
      decoration: BoxDecoration(
          color: cubit.getColor(task!.color!),
          borderRadius: BorderRadius.circular(15)),
      child: Row(children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                task!.title!,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(color: Colors.white),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.timer,
                    color: Colors.white,
                  ),
                  Text(
                    task!.startTime!,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: Colors.white),
                  ),
                  Text(
                    " - ${task!.endTime!}",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: Colors.white),
                  ),
                ],
              ),
              Text(task!.note!,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: Colors.white)),
            ],
          ),
        ),
        Container(
          height: 70,
          width: 1,
          color: Colors.white,
        ),
        RotatedBox(
          quarterTurns: 3,
          child: Text(task!.isCompleted == 0 ? 'TODO' : 'Completed',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white)),
        ),
        const SizedBox(
          width: 3,
        )
      ]),
    );
  }
}
