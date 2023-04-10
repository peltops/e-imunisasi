class KalenderModel {
  final String? uid;
  final DateTime? date;
  final String? activity;
  final String? documentID;
  final bool? readOnly;

  KalenderModel(
      {this.uid,
      this.activity,
      this.date,
      this.documentID,
      this.readOnly = false});

  factory KalenderModel.fromMap(Map data, val) {
    return KalenderModel(
      uid: data['uid'] ?? '',
      activity: data['activity'] ?? '',
      date: data['date'].toDate(),
      readOnly: data['readOnly'],
      documentID: val.id,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "activity": activity,
      "date": date,
      "readOnly": readOnly,
    };
  }
}
