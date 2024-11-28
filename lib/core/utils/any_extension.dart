extension AnyExtension on dynamic {
  bool isNull() {
    return this == null;
  }

  bool isNotNull() {
    return this != null;
  }
}
