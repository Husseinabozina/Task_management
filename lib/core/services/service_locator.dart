import 'package:get_it/get_it.dart';
import 'package:todoapp/core/services/sqflite_helper.dart';

final getit = GetIt.instance;
Future<void> setUp() async {
  getit.registerLazySingleton<SqfliteHelper>(() => SqfliteHelper());
}
