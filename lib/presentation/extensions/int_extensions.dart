extension IntExtensions on int? {
  DateTime? fromMillisecondsSinceEpoch() {
    if (this != null) {
      return DateTime.fromMillisecondsSinceEpoch(this! * 1000);
    }
    return null;
  }
}
