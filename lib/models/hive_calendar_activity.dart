import 'package:hive/hive.dart';
part 'hive_calendar_activity.g.dart';

@HiveType(typeId: 0)
class CalendarsHive extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  String activity;
}
