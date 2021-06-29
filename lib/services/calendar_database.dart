import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eimunisasi/models/calendar.dart';
import 'package:flutter/material.dart';

class FirestoreDatabase {
  FirestoreDatabase({@required this.uid});
  final String uid;

  final _service = FirebaseFirestore.instance;

  Future<void> setEvent(Calendars calendars) =>
      _service.collection('calendars').add(calendars.toMap());

  Future<void> updateEvent(Calendars calendars, docID) =>
      _service.collection('calendars').doc(docID).update(calendars.toMap());

  Future<void> deleteEvent(docID) =>
      _service.collection('calendars').doc(docID).delete();

  // Future<void> deleteJob(Job job) async {
  //   // delete where entry.jobId == job.jobId
  //   final allEntries = await entriesStream(job: job).first;
  //   for (final entry in allEntries) {
  //     if (entry.jobId == job.id) {
  //       await deleteEntry(entry);
  //     }
  //   }
  //   // delete job
  //   await _service.deleteData(path: FirestorePath.job(uid, job.id));
  // }

  Stream<Calendars> calendarStream() =>
      _service.doc(uid).snapshots().map((e) => Calendars(
          uid: e.data()['uid'],
          date: e.data()['date'],
          activity: e.data()['activity']));

  List<Calendars> _listEventKalender(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      var data = Map<String, dynamic>.from(e.data());
      return Calendars(
          uid: data['uid'] ?? '',
          activity: data['activity'] ?? '',
          date: data['date'].toDate(),
          documentID: e.id);
    }).toList();
  }

  Stream<List<Calendars>> get calendarsStream =>
      _service.collection('calendars').snapshots().map(_listEventKalender);

  // Future<void> deleteEntry(Entry entry) =>
  //     _service.deleteData(path: FirestorePath.entry(uid, entry.id));

  // Stream<List<Entry>> entriesStream({Job? job}) =>
  //     _service.collectionStream<Entry>(
  //       path: FirestorePath.entries(uid),
  //       queryBuilder: job != null
  //           ? (query) => query.where('jobId', isEqualTo: job.id)
  //           : null,
  //       builder: (data, documentID) => Entry.fromMap(data, documentID),
  //       sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
  //     );
}
