import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response.freezed.dart';

/// Generic API response wrapper for PX1 API responses
///
/// Handles the standard PX1 API response structure with success/error patterns:
///
/// Success: { "status": "success", "code": 200, "data": {...} }
/// Error: { "status": "error", "message": "error message", "code": 400 }
@Freezed(genericArgumentFactories: true)
sealed class ApiResponse<T> with _$ApiResponse<T> {
  /// Success response wrapper
  ///
  /// [status] - Always "success" for successful responses
  /// [code] - HTTP status code (200, 201, etc.)
  /// [data] - The actual response data of type T
  const factory ApiResponse.success({
    required String status,
    required int code,
    required T data,
  }) = ApiSuccessResponse<T>;

  /// Error response wrapper
  ///
  /// [status] - Always "error" for error responses
  /// [message] - Human-readable error message
  /// [code] - HTTP error code (400, 401, 500, etc.)
  const factory ApiResponse.error({
    required String status,
    required String message,
    required int code,
  }) = ApiErrorResponse<T>;

  /// Creates ApiResponse from JSON with custom data parser
  ///
  /// [json] - The raw JSON response from API
  /// [fromJsonT] - Function to parse the data portion into type T
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) {
    final status = json['status'] as String;

    if (status == 'success') {
      return ApiResponse.success(
        status: status,
        code: json['code'] as int,
        data: fromJsonT(json['data']),
      );
    } else {
      return ApiResponse.error(
        status: status,
        message: json['message'] as String,
        code: json['code'] as int,
      );
    }
  }
}
