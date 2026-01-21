// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Todo _$TodoFromJson(Map<String, dynamic> json) => Todo(
  task: json['task'] as String,
  discription: json['discription'] as String,
  date: json['date'] as String,
  time: json['time'] as String,
  docId: json['docId'] as String,
  isDone: json['isDone'] as bool? ?? false,
  isPin: json['isPin'] as bool? ?? false,
);

Map<String, dynamic> _$TodoToJson(Todo instance) => <String, dynamic>{
  'task': instance.task,
  'discription': instance.discription,
  'date': instance.date,
  'time': instance.time,
  'docId': instance.docId,
  'isDone': instance.isDone,
  'isPin': instance.isPin,
};
