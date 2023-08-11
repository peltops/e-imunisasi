extension StringExtension on String? {
  bool get isNotNullOrEmpty {
    return this != null && this?.isNotEmpty == true;
  }

  bool get isNullOrEmpty {
    return this == null || this?.isEmpty == true;
  }

  String get orEmpty => this ?? '';

  String removeZeroAtFirst() {
    if (this?.startsWith('0') == true) {
      return this?.replaceFirst('0', '') ?? '';
    }
    return this.orEmpty;
  }
}
