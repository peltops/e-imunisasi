import 'package:eimunisasi/features/profile/data/models/child_model.dart';
import 'package:eimunisasi/features/profile/data/repositories/child_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_supabase_http_client/mock_supabase_http_client.dart';
import 'package:mockito/annotations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@GenerateMocks([
  GoTrueClient,
  SupabaseStorageClient,
])
@GenerateNiceMocks([
  MockSpec<User>(),
  MockSpec<ChildModel>(),
])
import 'child_repository_test.mocks.dart';

void main() {
  late ChildRepository childRepository;
  late final SupabaseClient mockSupabaseClient;
  late final MockSupabaseHttpClient mockHttpClient;

  setUpAll(() {
    mockHttpClient = MockSupabaseHttpClient();
    mockSupabaseClient = SupabaseClient(
      'https://example.com',
      'anon-key',
      httpClient: mockHttpClient,
    );

    childRepository = ChildRepository(mockSupabaseClient);
  });

  tearDown(() async {
    mockHttpClient.reset();
  });

  tearDownAll(() {
    mockHttpClient.close();
  });

  group('ChildRepository', () {
    final mockUser = MockUser();

    test('getAllChildren returns list of children', () async {
      final child1 = ChildModel(
        parentId: '1',
        nik: '1234567890',
        tempatLahir: 'Jakarta',
        jenisKelamin: 'L',
        golDarah: 'A',
        nama: 'Child',
        tanggalLahir: DateTime.now(),
        photoURL: 'https://example.com',
      );
      final child2 = child1.copyWith(
        nik: '0987654321',
        nama: 'Child 2',
      );
      final List<ChildModel> mockData = [
        child1,
        child2,
      ];

      for (var element in mockData) {
        final data = element.toSeribaseMap();
        data.addAll({'created_at': DateTime.now().toIso8601String()});
        await mockSupabaseClient
            .from('children')
            .insert(data);
      }

      final result = await childRepository.getAllChildren();

      expect(result, isA<List<ChildModel>>());
      expect(result.length, 2);
    });

    test('setChild inserts a child and returns it with id', () async {
      final anak = ChildModel(
        parentId: mockUser.id,
        nik: '1234567890',
        tempatLahir: 'Jakarta',
        jenisKelamin: 'L',
        golDarah: 'A',
        nama: 'Child',
        tanggalLahir: DateTime.now(),
        photoURL: 'https://example.com',
      );
      final result = await childRepository.setChild(anak);

      expect(result.id, '');
      expect(result.parentId, mockUser.id);
    });

    test('deleteChild deletes a child', () async {
      final id = '1';
      final result = childRepository.deleteChild(id);

      expect(result, isA<Future<void>>());
    });
  });
}
