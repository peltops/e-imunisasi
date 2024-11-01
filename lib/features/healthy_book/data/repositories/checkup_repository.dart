import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/checkup_model.dart';

@injectable
class CheckupRepository {
  final SupabaseClient supabase;

  const CheckupRepository(this.supabase);

  Future<List<CheckupModel>> getCheckups(String childId) async {
    try {
      final response = await supabase
          .from(CheckupModel.tableName)
          .select()
          .eq('child_id', childId)
          .withConverter(
            (json) => json.map((e) => CheckupModel.fromSeribase(e)).toList(),
          );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
