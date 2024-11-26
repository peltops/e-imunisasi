import 'package:equatable/equatable.dart';

class BasePagination<T> extends Equatable {
  final List<T>? data;
  final MetadataPaginationModel? metadata;

  const BasePagination({
    this.data,
    this.metadata,
  });

  BasePagination<T> copyWith({
    List<T>? data,
    MetadataPaginationModel? metadata,
  }) {
    return BasePagination<T>(
      data: data ?? this.data,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
    data,
    metadata,
  ];
}

class MetadataPaginationModel extends Equatable {
  final int total;
  final int page;
  final int perPage;

  const MetadataPaginationModel({
    this.total = 0,
    this.page = 1,
    this.perPage = 20,
  });

  MetadataPaginationModel copyWith({
    int? total,
    int? page,
    int? perPage,
  }) {
    return MetadataPaginationModel(
      total: total ?? this.total,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
    );
  }

  factory MetadataPaginationModel.fromMap(Map<String, dynamic> map) {
    return MetadataPaginationModel(
      total: map['total'] ?? 0,
      page: map['page'] ?? 1,
      perPage: map['pageSize'] ?? 20,
    );
  }

  @override
  List<Object?> get props => [
    total,
    page,
    perPage,
  ];
}