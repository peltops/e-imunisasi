import 'package:test/test.dart';
import 'package:eimunisasi/core/extension.dart';

void main() {
    group('StringExtension', () {
        group('capitalize', () {
            test('capitalizes the first letter of a string', () {
                expect('hello'.capitalize(), 'Hello');
            });

            test('capitalizes the first letter and lowercases the rest', () {
                expect('hELLO'.capitalize(), 'Hello');
            });

            test('returns an empty string when the string is empty', () {
                expect(''.capitalize(), '');
            });
        });

        group('isNullOrEmpty', () {
            test('returns true when string is empty', () {
                expect(''.isNullOrEmpty, true);
            });

            test('returns false when string is not empty', () {
                expect('hello'.isNullOrEmpty, false);
            });
        });

        group('isNotNullOrEmpty', () {
            test('returns true when string is not empty', () {
                expect('hello'.isNotNullOrEmpty, true);
            });

            test('returns false when string is empty', () {
                expect(''.isNotNullOrEmpty, false);
            });
        });
    });

    group('DateTimeExtension', () {
        group('formattedDate', () {
            test('returns formatted date with default format', () {
                final date = DateTime(2023, 10, 10);
                expect(date.formattedDate(), '10-10-2023');
            });

            test('returns formatted date with custom format', () {
                final date = DateTime(2023, 10, 10);
                expect(date.formattedDate(format: 'yyyy/MM/dd'), '2023/10/10');
            });

            test('returns empty string when DateTime is null', () {
                DateTime? date = null;
                expect(date.formattedDate(), '');
            });
        });
    });
}