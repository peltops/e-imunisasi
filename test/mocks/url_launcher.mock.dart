import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

MockUrlLauncher setupMockUrlLauncher() {
  final mock = MockUrlLauncher();
  registerFallbackValue(const LaunchOptions());

  when(() => mock.launchUrl(any(), any())).thenAnswer((_) async => true);
  return mock;
}