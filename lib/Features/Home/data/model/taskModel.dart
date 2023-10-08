class TaskModel {
  int? id;
  String? title;
  String? note;
  String? date;
  String? startTime;
  String? endTime;

  int? isCompleted;
  int? color;
  String? repeat;
  String? remind;

  TaskModel(
      {this.id,
      this.title,
      this.note,
      this.date,
      this.startTime,
      this.endTime,
      this.isCompleted,
      this.repeat,
      this.color,
      this.remind});
}
