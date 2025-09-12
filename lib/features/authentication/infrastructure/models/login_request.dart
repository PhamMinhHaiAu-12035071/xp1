import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_request.freezed.dart';

/// Infrastructure model for login API request
///
/// Contains authentication credentials for login endpoint.
/// Maps to JSON for API communication using custom serialization.
@Freezed(fromJson: false, toJson: false)
sealed class LoginRequest with _$LoginRequest {
  /// Creates a LoginRequest for authentication API
  ///
  /// [userName] - User's username or email address
  /// [password] - User's password
  const factory LoginRequest({
    required String userName,
    required String password,
  }) = _LoginRequest;

  /// Creates LoginRequest from JSON response
  factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
    userName: json['user_name'] as String,
    password: json['password'] as String,
  );
}

/// Extension for custom JSON serialization
extension LoginRequestJson on LoginRequest {
  /// Converts to JSON with proper API field mapping
  Map<String, dynamic> toJson() => {
    'user_name': userName,
    'password': password,
  };
}
