extension DateTimeExtension on DateTime? {
  bool get isNotNull => this != null;

  bool get isNull => this == null;

  DateTime get orNow => this ?? DateTime.now();
}
