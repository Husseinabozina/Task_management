import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todoapp/Features/Home/preasentation/controllers/cubit/Task_cubit.dart';

class ThemeService {
  final _box = GetStorage();
  final _key = 'isDarkeMode';
  bool _getThemeFromBox() => _box.read(_key) ?? false;
  ThemeMode getThemeMode() {
    ThemeMode themeMode = _getThemeFromBox() ? ThemeMode.dark : ThemeMode.light;
    return themeMode;
  }

  void switchMode(bool val) {
    _box.write(_key, val);
  }
}
