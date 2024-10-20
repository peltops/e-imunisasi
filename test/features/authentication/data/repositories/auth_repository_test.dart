import 'package:mock_supabase_http_client/mock_supabase_http_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:test/test.dart';
import 'package:eimunisasi/features/authentication/data/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/url_launcher.mock.dart';

class MockUri extends Mock implements Uri {}

class MockOAuthResponse extends Mock implements OAuthResponse {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockSupabaseClient extends Mock implements supabase.SupabaseClient {}

class MockGoTrueClient extends Mock implements supabase.GoTrueClient {}

class MockUser extends Mock implements supabase.User {}

void main() {
  flutter_test.TestWidgetsFlutterBinding.ensureInitialized();
  late SharedPreferences sharedPreferences;
  late AuthRepository authRepository;
  late SupabaseClient mockSupabase;
  late MockGoTrueClient mockGoTrue;
  late MockOAuthResponse oAuthResponse;
  late MockSupabaseHttpClient mockSupabaseHttpClient;

  setUpAll(() {
    registerFallbackValue(MockUri());
  });
  setUp(() {
    mockSupabaseHttpClient = MockSupabaseHttpClient();
    sharedPreferences = MockSharedPreferences();
    mockSupabase = SupabaseClient(
      'https://example.com',
      'anon-key',
      httpClient: mockSupabaseHttpClient,
    );

    mockGoTrue = MockGoTrueClient();
    oAuthResponse = MockOAuthResponse();
    authRepository = AuthRepository(
      sharedPreferences,
      mockSupabase,
    );
  });
  group('destroyPasscode', () {
    test('destroyPasscode success', () async {
      when(() => sharedPreferences.remove('passCode'))
          .thenAnswer((_) async => true);

      final result = await authRepository.destroyPasscode();
      verify(() => sharedPreferences.remove('passCode')).called(1);
      expect(result, true);
    });

    test('destroyPasscode throws an exception if remove throws', () async {
      when(() => sharedPreferences.remove('passCode')).thenThrow(
        Exception('error'),
      );

      final result = authRepository.destroyPasscode();

      expect(result, throwsA(isA<Exception>()));
    });
  });

  group('logInWithSeribaseOauth', () {
    late AuthRepository authRepository;
    late MockSupabaseClient mockSupabase;
    setUp(() {
      mockSupabase = MockSupabaseClient();
      authRepository = AuthRepository(
        sharedPreferences,
        mockSupabase,
      );
      //  Mock the URL launcher
      final mock = setupMockUrlLauncher();
      UrlLauncherPlatform.instance = mock;

      // Mock the OAuth response URL
      when(() => oAuthResponse.provider)
          .thenReturn(supabase.OAuthProvider.keycloak);
      when(() => oAuthResponse.url).thenReturn('http://www.google.com');
      when(() => mockSupabase.auth).thenReturn(mockGoTrue);
    });

    test('logInWithSeribaseOauth success', () async {
      // Mock the getOAuthSignInUrl method
      when(() => mockGoTrue.getOAuthSignInUrl(
            provider: supabase.OAuthProvider.keycloak,
            redirectTo: any(named: 'redirectTo'),
            scopes: any(named: 'scopes'),
            queryParams: any(named: 'queryParams'),
          )).thenAnswer((_) async => oAuthResponse);

      // Ensure mockSupabase.auth returns the correct MockGoTrueClient
      when(() => mockSupabase.auth).thenReturn(mockGoTrue);

      // Call the method under test
      final result = await authRepository.logInWithSeribaseOauth();

      // Verify the result is true, assuming that the repository checks for a successful response
      expect(result, true);
    });

    test('logInWithSeribaseOauth throws an exception if signInWithOAuth throws',
        () async {
      // Mock the getOAuthSignInUrl method
      when(() => mockGoTrue.getOAuthSignInUrl(
            provider: supabase.OAuthProvider.keycloak,
            redirectTo: any(named: 'redirectTo'),
            scopes: any(named: 'scopes'),
            queryParams: any(named: 'queryParams'),
          )).thenThrow(Exception('error'));

      // Ensure mockSupabase.auth returns the correct MockGoTrueClient
      when(() => mockSupabase.auth).thenReturn(mockGoTrue);

      final result = authRepository.logInWithSeribaseOauth();

      expect(result, throwsA(isA<Exception>()));
    });
  });
}
