import 'package:flutter/material.dart';

import 'package:todoapp/Features/Home/preasentation/views/todo_homeview/widgets/to_do_homeview_body.dart';

class ToDoHomeView extends StatelessWidget {
  const ToDoHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ToDoHomeViewBody(),
    );
  }
}
