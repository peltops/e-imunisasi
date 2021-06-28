class Calendars {
  final String uid;
  final DateTime date;
  final String activity;
  final String documentID;

  Calendars({this.uid, this.activity, this.date, this.documentID});

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "activity": activity,
      "date": date,
    };
  }
}
