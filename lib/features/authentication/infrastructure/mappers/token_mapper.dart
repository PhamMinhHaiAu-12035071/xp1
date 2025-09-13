import 'package:injectable/injectable.dart';

import '../../../../core/mappers/base_mapper.dart';
import '../../domain/entities/token_entity.dart';
import '../models/login_response.dart';

/// Mapper for LoginResponse → TokenEntity conversion
///
/// Extracts JWT token information from authentication API responses
/// and converts to domain token entities with proper expiration handling.
@injectable
class TokenMapper extends BaseMapper<LoginResponse, TokenEntity> {
  /// Converts LoginResponse to TokenEntity
  ///
  /// Extracts token data from API response and calculates expiration
  /// timestamp using current time as the issuedAt baseline.
  @override
  TokenEntity fromModelToEntity(LoginResponse model) {
    return TokenEntity.fromApiResponse(
      accessToken: model.accessToken,
      refreshToken: model.refreshToken,
      tokenType: model.tokenType,
      ttl: model.ttl,
    );
  }

  // Note: Reverse conversion (TokenEntity → LoginResponse) not implemented
  // as tokens are created from API responses, not sent back as requests.
  // The base class UnimplementedError will be thrown if attempted.
}
