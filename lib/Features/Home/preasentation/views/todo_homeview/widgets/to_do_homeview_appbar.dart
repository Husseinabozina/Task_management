import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todoapp/Features/Home/preasentation/controllers/cubit/Task_cubit.dart';
import 'package:todoapp/core/services/notification_service.dart';

class ToDoHomeViewappBar extends StatelessWidget {
  const ToDoHomeViewappBar({super.key});

  @override
  Widget build(BuildContext context) {
    var taskCubit = BlocProvider.of<TaskCubit>(context);

    return Row(
      children: [
        IconButton(
            onPressed: () async {
              taskCubit.changeThemes();
              await NotifyHelper.showSimpleNotification(
                  title: "mode is changes",
                  body: taskCubit.isDarkTheme
                      ? 'Dark theme is activated'
                      : "Light theme is activated",
                  payload: 'this is simple data');
            },
            icon: taskCubit.isDarkTheme
                ? const Icon(Icons.light_mode)
                : const Icon(Icons.brightness_3_outlined)),
        const Spacer(),
        const SizedBox(
          width: 10,
        ),
        SvgPicture.asset(
          'assets/images/user-profile.svg',
          height: 50,
          width: 50,
        )
      ],
    );
  }
}
