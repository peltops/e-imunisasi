import 'package:test/test.dart';
import 'package:eimunisasi/core/utils/datetime_extension.dart';

void main() {
  group('DateTimeExtension', () {
    group('isNotNull', () {
      test('returns true when DateTime is not null', () {
        expect(DateTime.now().isNotNull, true);
      });

      test('returns false when DateTime is null', () {
        expect((null as DateTime?).isNotNull, false);
      });
    });

    group('isNull', () {
      test('returns true when DateTime is null', () {
        expect((null as DateTime?).isNull, true);
      });

      test('returns false when DateTime is not null', () {
        expect(DateTime.now().isNull, false);
      });
    });

    group('orNow', () {
      test('returns the DateTime when it is not null', () {
        final dateTime = DateTime(2023, 10, 10);
        expect(dateTime.orNow, dateTime);
      });

      test('returns current DateTime when the DateTime is null', () {
        final now = DateTime.now();
        expect((null as DateTime?).orNow.isAfter(now.subtract(Duration(seconds: 1))), true);
      });
    });
  });
}