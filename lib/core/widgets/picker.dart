import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class Picker {
  static DatePickerTheme dateTheme(BuildContext context) {
    return DatePickerTheme(
      doneStyle: TextStyle(
        color: Theme.of(context).colorScheme.secondary,
        fontWeight: FontWeight.bold,
        fontFamily: 'Nunito',
      ),
      cancelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: 'Nunito',
        color: Colors.black,
      ),
      itemStyle: TextStyle(
        fontWeight: FontWeight.w500,
        fontFamily: 'Nunito',
      ),
    );
  }

  static Future<DateTime?> pickDate(
    BuildContext context,
    Function(DateTime) onChanged, {
    DateTime? minTime,
    DateTime? maxTime,
    bool showTitleActions = true,
    DateTime? currentTime,
    LocaleType? locale = LocaleType.id,
  }) async {
    final currentTimeDefault = DateTime.now();
    final minTimeDefault = DateTime(currentTimeDefault.year - 5);
    final maxTimeDefault = currentTimeDefault;
    return DatePicker.showDatePicker(
      context,
      theme: dateTheme(context),
      showTitleActions: true,
      minTime: minTime ?? minTimeDefault,
      maxTime: maxTime ?? maxTimeDefault,
      onChanged: onChanged,
      currentTime: currentTime ?? currentTimeDefault,
      locale: locale,
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
