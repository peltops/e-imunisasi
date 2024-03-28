import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eimunisasi/models/nakes.dart';

class NakesService {
  final _service = FirebaseFirestore.instance;

  NakesService() : super();

// Stream List Nakes
  List<Nakes> _listData(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      var data = Map<String, dynamic>.from(e.data() as Map<dynamic, dynamic>);
      data['id'] = e.id;
      return Nakes.fromMap(data);
    }).toList();
  }

  Stream<List<Nakes>> get nakesStream =>
      _service.collection('users_medis').snapshots().map(_listData);
}
