import 'package:hive/hive.dart';
part 'hive_calendar_activity_model.g.dart';

@HiveType(typeId: 0)
class CalendarActivityHive extends HiveObject {
  @HiveField(0)
  DateTime? date;

  @HiveField(1)
  String? activity;

  @HiveField(2)
  int? id;
}
