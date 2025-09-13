import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_entity.freezed.dart';
part 'token_entity.g.dart';

/// Domain entity representing JWT authentication tokens
///
/// Contains access and refresh tokens from API response.
/// Maps to API response format with snake_case field names.
@freezed
sealed class TokenEntity with _$TokenEntity {
  /// Creates a TokenEntity with JWT token information
  ///
  /// [accessToken] - JWT access token for API authentication
  /// [refreshToken] - JWT refresh token for token renewal
  /// [tokenType] - Token type, typically "Bearer"
  /// [ttl] - Token time-to-live in seconds
  const factory TokenEntity({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    @JsonKey(name: 'token_type') required String tokenType,
    required int ttl,
  }) = _TokenEntity;

  /// Creates a TokenEntity from API response data
  ///
  /// Use this constructor when receiving tokens from API.
  factory TokenEntity.fromApiResponse({
    required String accessToken,
    required String refreshToken,
    required String tokenType,
    required int ttl,
  }) {
    return TokenEntity(
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenType: tokenType,
      ttl: ttl,
    );
  }

  /// Creates a TokenEntity from JSON response
  factory TokenEntity.fromJson(Map<String, dynamic> json) =>
      _$TokenEntityFromJson(json);
}

/// Extension to add toJson method to TokenEntity
extension TokenEntityJson on TokenEntity {
  /// Converts TokenEntity to JSON format
  Map<String, dynamic> toJson() => _$TokenEntityToJson(this as _TokenEntity);
}
