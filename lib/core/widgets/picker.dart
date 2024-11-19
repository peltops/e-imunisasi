import 'package:flutter/material.dart';

class Picker {
  static Future<DateTime?> pickDate(
    BuildContext context, {
    DateTime? minTime,
    DateTime? maxTime,
    bool showTitleActions = true,
    DateTime? currentTime,
    Locale? locale = const Locale('id', 'ID'),
    bool Function(DateTime)? selectableDayPredicate,
  }) async {
    final currentTimeDefault = DateTime.now();
    final minTimeDefault = DateTime(currentTimeDefault.year - 5);
    final maxTimeDefault = currentTimeDefault;
    return await showDatePicker(
      context: context,
      initialDate: currentTime ?? currentTimeDefault,
      firstDate: minTime ?? minTimeDefault,
      lastDate: maxTime ?? maxTimeDefault,
      locale: locale,
      selectableDayPredicate: selectableDayPredicate,
    );
  }

  static Future<TimeOfDay> pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    return picked ?? TimeOfDay.now();
  }
}
