import 'package:test/test.dart';
import 'package:eimunisasi/core/utils/string_extension.dart';

void main() {
    group('StringExtension', () {
        group('isNotNullOrEmpty', () {
            test('returns true when string is not null and not empty', () {
                expect('hello'.isNotNullOrEmpty, true);
            });

            test('returns false when string is null', () {
                expect((null as String?).isNotNullOrEmpty, false);
            });

            test('returns false when string is empty', () {
                expect(''.isNotNullOrEmpty, false);
            });
        });

        group('isNullOrEmpty', () {
            test('returns true when string is null', () {
                expect((null as String?).isNullOrEmpty, true);
            });

            test('returns true when string is empty', () {
                expect(''.isNullOrEmpty, true);
            });

            test('returns false when string is not null and not empty', () {
                expect('hello'.isNullOrEmpty, false);
            });
        });

        group('orEmpty', () {
            test('returns the string when it is not null', () {
                expect('hello'.orEmpty, 'hello');
            });

            test('returns empty string when the string is null', () {
                expect((null as String?).orEmpty, '');
            });
        });

        group('removeZeroAtFirst', () {
            test('removes leading zero when string starts with zero', () {
                expect('0123'.removeZeroAtFirst(), '123');
            });

            test('returns the same string when it does not start with zero', () {
                expect('123'.removeZeroAtFirst(), '123');
            });

            test('returns empty string when the string is null', () {
                expect((null as String?).removeZeroAtFirst(), '');
            });

            test('returns empty string when the string is empty', () {
                expect(''.removeZeroAtFirst(), '');
            });
        });
    });
}