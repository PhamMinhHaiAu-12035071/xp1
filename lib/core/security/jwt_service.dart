import 'dart:convert';

import 'package:injectable/injectable.dart';

/// Service for JWT token parsing and validation using dart:convert
///
/// Provides secure JWT token operations without external dependencies.
/// Handles token decoding, expiration checking, and user info extraction.
/// Follows security best practices for JWT token management.
@LazySingleton()
class JwtService {
  /// Decodes JWT payload using dart:convert only
  ///
  /// [token] - The JWT token to decode
  /// Returns decoded payload as Map or null if decoding fails
  ///
  /// Security note: Only decodes payload, does not verify signature
  /// For production use, implement proper signature verification
  Map<String, dynamic>? decodeToken(String token) {
    try {
      // JWT structure: header.payload.signature
      final parts = token.split('.');
      if (parts.length != 3) {
        return null; // Invalid JWT structure
      }

      final payload = parts[1];

      // Normalize base64 padding for decoding
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));

      return jsonDecode(decoded) as Map<String, dynamic>;
    } on FormatException {
      // Return null for JSON decoding errors
      return null;
    } on Exception {
      // Return null for any other decoding errors (malformed token, etc.)
      return null;
    }
  }

  /// Checks if JWT token has expired
  ///
  /// [token] - The JWT token to check
  /// Returns true if token is expired or invalid, false if still valid
  ///
  /// Uses 'exp' claim (expiration time) from JWT payload
  bool isTokenExpired(String token) {
    final decoded = decodeToken(token);
    if (decoded == null) {
      return true; // Invalid token is considered expired
    }

    final expValue = decoded['exp'];
    if (expValue is! int) {
      return true; // Non-numeric or missing exp claim means expired
    }

    // Convert Unix timestamp to DateTime (exp is in seconds)
    final expiryDate = DateTime.fromMillisecondsSinceEpoch(expValue * 1000);
    return DateTime.now().isAfter(expiryDate);
  }

  /// Checks if JWT token will expire soon (within specified minutes)
  ///
  /// [token] - The JWT token to check
  /// [minutesThreshold] - Minutes before expiration to consider "soon"
  /// Returns true if token will expire within threshold, false otherwise
  bool willTokenExpireSoon(String token, {int minutesThreshold = 5}) {
    final decoded = decodeToken(token);
    if (decoded == null) {
      return true; // Invalid token should be refreshed
    }

    final expValue = decoded['exp'];
    if (expValue is! int) {
      return true; // Non-numeric or missing exp claim
    }

    final expiryDate = DateTime.fromMillisecondsSinceEpoch(expValue * 1000);
    final timeUntilExpiry = expiryDate.difference(DateTime.now());

    return timeUntilExpiry.inMinutes <= minutesThreshold;
  }

  /// Extracts user information from JWT payload
  ///
  /// [token] - The JWT token to extract user info from
  /// Returns user info as Map or null if extraction fails
  ///
  /// Common JWT claims: sub (subject), name, email, roles, etc.
  Map<String, dynamic>? getUserInfo(String token) {
    return decodeToken(token);
  }

  /// Validates JWT token structure (does not verify signature)
  ///
  /// [token] - The JWT token to validate
  /// Returns true if token has valid structure, false otherwise
  ///
  /// Note: Only validates structure, not cryptographic signature
  bool validateTokenStructure(String token) {
    if (token.isEmpty) return false;

    final parts = token.split('.');
    if (parts.length != 3) return false;

    // Try to decode payload to ensure it's valid base64 JSON
    final decoded = decodeToken(token);
    return decoded != null;
  }

  /// Gets token expiration time as DateTime
  ///
  /// [token] - The JWT token to get expiration from
  /// Returns expiration DateTime or null if token is invalid
  DateTime? getTokenExpiration(String token) {
    final decoded = decodeToken(token);
    if (decoded == null) return null;

    final expValue = decoded['exp'];
    if (expValue is! int) return null;

    return DateTime.fromMillisecondsSinceEpoch(expValue * 1000);
  }

  /// Gets token issued time as DateTime
  ///
  /// [token] - The JWT token to get issued time from
  /// Returns issued DateTime or null if token is invalid or missing 'iat'
  DateTime? getTokenIssuedAt(String token) {
    final decoded = decodeToken(token);
    if (decoded == null) return null;

    final iatValue = decoded['iat'];
    if (iatValue is! int) return null;

    return DateTime.fromMillisecondsSinceEpoch(iatValue * 1000);
  }
}
