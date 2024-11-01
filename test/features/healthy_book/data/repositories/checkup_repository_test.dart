import 'package:eimunisasi/features/healthy_book/data/models/checkup_model.dart';
import 'package:eimunisasi/features/healthy_book/data/repositories/checkup_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_supabase_http_client/mock_supabase_http_client.dart';
import 'package:mockito/annotations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@GenerateMocks([
  GoTrueClient,
  SupabaseClient,
])
@GenerateNiceMocks([MockSpec<User>()])
import 'checkup_repository_test.mocks.dart';

void main() {
  late CheckupRepository checkupRepository;
  late SupabaseClient supabaseClient;

  setUpAll(() {
    supabaseClient = SupabaseClient(
      'https://test.com',
      'test',
      httpClient: MockSupabaseHttpClient(),
    );
    checkupRepository = CheckupRepository(supabaseClient);
  });

  group('getCheckups', () {
    test('returns a list of CheckupModel if succeeds', () async {
      final checkupRepository = CheckupRepository(supabaseClient);
      final testCheckup = CheckupModel(
        beratBadan: 10,
        tinggiBadan: 10,
        lingkarKepala: 10,
        jenisVaksin: 'jenisVaksin',
        riwayatKeluhan: 'riwayatKeluhan',
        diagnosa: 'diagnosa',
        tindakan: 'tindakan',
        id: 'id',
        idOrangTuaPasien: 'idOrangTua',
        idPasien: 'idPasien',
        idDokter: 'idDokter',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        deletedAt: DateTime.now(),
      );

      await supabaseClient
          .from(CheckupModel.tableName)
          .insert(testCheckup.toMap());
      final res = await checkupRepository.getCheckups('idPasien');
      expect(res, isA<List<CheckupModel>>());
    });
  });
}
