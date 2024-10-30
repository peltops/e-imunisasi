import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eimunisasi/features/healthy_book/data/models/checkup_model.dart';

class CheckupsServices {
  CheckupsServices({this.nikAnak});
  final String? nikAnak;

  final _service = FirebaseFirestore.instance;
  List<CheckupModel> _listData(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      var data = Map<String, dynamic>.from(e.data() as Map<dynamic, dynamic>);
      return CheckupModel.fromSeribase(data);
    }).toList();
  }

  Stream<List<CheckupModel>> checkupsStream(String? uid) => _service
      .collection('checkups')
      .where('id_pasien', isEqualTo: uid)
      .snapshots()
      .map(_listData);
}
