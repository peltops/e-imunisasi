import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart' as LibPicker;

class Picker {
  static LibPicker.DatePickerTheme dateTheme(BuildContext context) {
    return LibPicker.DatePickerTheme(
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
        LibPicker.LocaleType? locale = LibPicker.LocaleType.id,
  }) async {
    final currentTimeDefault = DateTime.now();
    final minTimeDefault = DateTime(currentTimeDefault.year - 5);
    final maxTimeDefault = currentTimeDefault;
    return LibPicker.DatePicker.showDatePicker(
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
