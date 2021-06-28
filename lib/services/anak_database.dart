import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eimunisasi/services/calendar_database.dart';

class AnakService extends FirestoreDatabase {
  Stream<DocumentSnapshot<Map<String, dynamic>>> get documentStream =>
      FirebaseFirestore.instance
          .collection('anak')
          .doc('mFKOBg6XOyoI3lfdnjFz')
          .snapshots();
}
