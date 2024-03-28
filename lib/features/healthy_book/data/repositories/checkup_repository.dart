import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../models/checkup_model.dart';

@injectable
class CheckupRepository {
  final FirebaseFirestore firestore;

  const CheckupRepository(this.firestore);

  Future<List<CheckupModel>> getCheckups(String? uid) async {
    try {
      final snapshot = await firestore
          .collection('checkups')
          .where('id_pasien', isEqualTo: uid)
          .get();
      return snapshot.docs.map((e) {
        var data = Map<String, dynamic>.from(e.data());
        return CheckupModel.fromFirebase(data, e.id);
      }).toList();
    } on FirebaseException catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}