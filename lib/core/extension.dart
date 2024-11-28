import 'package:intl/intl.dart';

extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty || this.length == 1) return this.toUpperCase();
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }

  bool get isNullOrEmpty {
    return this.isEmpty;
  }

  bool get isNotNullOrEmpty {
    return this.isNotEmpty;
  }
}

const String emptyString = '';


extension DateTimeExtension on DateTime? {
  /// default format is dd-MM-yyyy
  String formattedDate({String? format}) {
    if (this == null) return emptyString;
    return format != null
        ? DateFormat(format).format(this!)
        : DateFormat('dd-MM-yyyy').format(this!);
  }
}
