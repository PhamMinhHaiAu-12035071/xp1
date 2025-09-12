import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

/// Infrastructure model for login API response data portion
///
/// Maps the "data" portion of PX1 API login response.
/// Contains JWT tokens and token metadata only (no user data).
///
/// API Structure: { "status": "success", "code": 200, "data": LoginResponse }
@freezed
sealed class LoginResponse with _$LoginResponse {
  /// Creates a LoginResponse from PX1 authentication API data portion
  ///
  /// [accessToken] - JWT access token for API authentication
  /// [refreshToken] - JWT refresh token for token renewal
  /// [tokenType] - Token type (typically "Bearer")
  /// [ttl] - Token time-to-live in seconds
  const factory LoginResponse({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    @JsonKey(name: 'token_type') required String tokenType,
    @JsonKey(name: 'ttl') required int ttl,
  }) = _LoginResponse;

  /// Creates LoginResponse from JSON API response data portion
  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}
