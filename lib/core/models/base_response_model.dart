import 'package:equatable/equatable.dart';

class BaseResponse<T> extends Equatable {
  final bool isSuccessful;
  final String? message;
  final T? error;
  final T? data;

  const BaseResponse({
    this.data,
    this.isSuccessful = false,
    this.message,
    this.error,
  });

  BaseResponse<T> copyWith({
    final bool? isSuccessful,
    final String? message,
    final T? error,
    final T? data,
  }) {
    return BaseResponse<T>(
      data: data ?? this.data,
      isSuccessful: isSuccessful ?? this.isSuccessful,
      message: message ?? this.message,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        data,
        isSuccessful,
        message,
        error,
      ];

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return BaseResponse<T>(
      isSuccessful: json['isSuccessful'] as bool? ?? false,
      message: json['message'] as String?,
      error: json['error'] != null ? fromJsonT(json['error']) : null,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}
