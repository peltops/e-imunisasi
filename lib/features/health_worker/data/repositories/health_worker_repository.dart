import 'package:eimunisasi/features/health_worker/data/models/health_worker_model.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@injectable
class HealthWorkerRepository {
  final SupabaseClient supabaseClient;

  const HealthWorkerRepository(this.supabaseClient);

  Future<List<HealthWorkerModel>> getHealthWorkers({
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
        'get-health-workers',
        queryParameters: queryParameters,
        method: HttpMethod.get,
      );

      if (fetch.status != 200) {
        throw Exception('Failed to get health workers');
      }

      final data = fetch.data['data'] as List?;
      final result = data
          ?.map(
            (e) => HealthWorkerModel.fromSeribase(e),
          )
          .toList();

      return result ?? [];
    } catch (e) {
      throw e;
    }
  }

  Future<HealthWorkerModel?> getHealthWorkerById(String id) async {
    try {
      final fetch = await supabaseClient.functions.invoke(
        'get-health-worker/${id}',
        method: HttpMethod.get,
      );

      if (fetch.status == 404) {
        return null;
      }

      if (fetch.status != 200) {
        throw Exception('Failed to get health worker');
      }

      final data = fetch.data['data'];
      final result = HealthWorkerModel.fromSeribase(data);

      return result;
    } catch (e) {
      throw e;
    }
  }
}
