import 'package:eimunisasi/features/health_worker/data/models/health_worker_model.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../health_worker/data/models/clinic_model.dart';

@injectable
class ClinicRepository {
  final SupabaseClient supabaseClient;

  const ClinicRepository(this.supabaseClient);

  Future<List<ClinicModel>> getClinics({
    int? page,
    int? perPage,
    String? search,
  }) async {
    try {
      final queryParameters = {
        if (page != null) 'page': page.toString(),
        if (perPage != null) 'pageSize': perPage.toString(),
        if (search != null) 'search': search,
      };

      final fetch = await supabaseClient.functions.invoke(
        'get-clinics',
        queryParameters: queryParameters,
        method: HttpMethod.get,
      );

      if (fetch.status != 200) {
        throw Exception('Failed to get clinics');
      }

      final data = fetch.data['data'] as List?;
      final result = data
          ?.map(
            (e) => ClinicModel.fromSeribase(e),
      )
          .toList();

      return result ?? [];
    } catch (e) {
      throw e;
    }
  }
}
