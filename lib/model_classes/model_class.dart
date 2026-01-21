import 'package:json_annotation/json_annotation.dart';
part 'model_class.g.dart';

@JsonSerializable()
class Todo {
  String task;
  String discription;
  String date;
  String time;
  String docId;
  bool isDone;
  bool isPin;

  Todo({
    required this.task,
    required this.discription,
    required this.date,
    required this.time,
    required this.docId,
    this.isDone=false,
    this.isPin=false,
  });

  factory Todo.fromJson(Map<String, dynamic> json) =>
      _$TodoFromJson(json);

  Map<String, dynamic> toJson() => _$TodoToJson(this);
}
