import 'package:flutter_test/flutter_test.dart';
import 'package:eimunisasi/core/models/pagination_model.dart';

void main() {
    group('BasePagination', () {
        group('copyWith', () {
            test('returns a new instance with updated data', () {
                final pagination = BasePagination<int>(data: [1, 2, 3]);
                final updatedPagination = pagination.copyWith(data: [4, 5, 6]);

                expect(updatedPagination.data, [4, 5, 6]);
                expect(updatedPagination.metadata, pagination.metadata);
            });

            test('returns a new instance with updated metadata', () {
                final metadata = MetadataPaginationModel(total: 100, page: 2, perPage: 10);
                final pagination = BasePagination<int>(metadata: metadata);
                final updatedMetadata = MetadataPaginationModel(total: 200, page: 3, perPage: 20);
                final updatedPagination = pagination.copyWith(metadata: updatedMetadata);

                expect(updatedPagination.metadata, updatedMetadata);
                expect(updatedPagination.data, pagination.data);
            });

            test('returns the same instance if no parameters are provided', () {
                final pagination = BasePagination<int>(data: [1, 2, 3]);
                final updatedPagination = pagination.copyWith();

                expect(updatedPagination, pagination);
            });
        });
    });

    group('MetadataPaginationModel', () {
        group('copyWith', () {
            test('returns a new instance with updated total', () {
                final metadata = MetadataPaginationModel(total: 100);
                final updatedMetadata = metadata.copyWith(total: 200);

                expect(updatedMetadata.total, 200);
                expect(updatedMetadata.page, metadata.page);
                expect(updatedMetadata.perPage, metadata.perPage);
            });

            test('returns a new instance with updated page', () {
                final metadata = MetadataPaginationModel(page: 1);
                final updatedMetadata = metadata.copyWith(page: 2);

                expect(updatedMetadata.page, 2);
                expect(updatedMetadata.total, metadata.total);
                expect(updatedMetadata.perPage, metadata.perPage);
            });

            test('returns a new instance with updated perPage', () {
                final metadata = MetadataPaginationModel(perPage: 20);
                final updatedMetadata = metadata.copyWith(perPage: 30);

                expect(updatedMetadata.perPage, 30);
                expect(updatedMetadata.total, metadata.total);
                expect(updatedMetadata.page, metadata.page);
            });

            test('returns the same instance if no parameters are provided', () {
                final metadata = MetadataPaginationModel(total: 100, page: 1, perPage: 20);
                final updatedMetadata = metadata.copyWith();

                expect(updatedMetadata, metadata);
            });
        });

        group('fromMap', () {
            test('creates an instance from a valid map', () {
                final map = {'total': 100, 'page': 2, 'pageSize': 10};
                final metadata = MetadataPaginationModel.fromMap(map);

                expect(metadata.total, 100);
                expect(metadata.page, 2);
                expect(metadata.perPage, 10);
            });

            test('uses default values for missing keys', () {
                final map = <String, dynamic>{};
                final metadata = MetadataPaginationModel.fromMap(map);

                expect(metadata.total, 0);
                expect(metadata.page, 1);
                expect(metadata.perPage, 20);
            });
        });
    });
}