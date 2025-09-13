import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/features/authentication/infrastructure/models/login_request.dart';
import 'package:xp1/features/authentication/infrastructure/models/login_response.dart';

void main() {
  group('Infrastructure Models', () {
    test('LoginRequest should create and serialize correctly', () {
      const loginRequest = LoginRequest(
        userName: 'supervisor@mgt.vn',
        password: 'Supervior@0001',
      );

      expect(loginRequest.userName, 'supervisor@mgt.vn');
      expect(loginRequest.password, 'Supervior@0001');

      final json = loginRequest.toJson();
      expect(json['user_name'], 'supervisor@mgt.vn');
      expect(json['password'], 'Supervior@0001');

      // Verify JSON structure matches API requirement exactly
      expect(json.keys.length, 2);
      expect(json.containsKey('user_name'), isTrue);
      expect(json.containsKey('password'), isTrue);
    });

    test('LoginResponse should create and serialize correctly', () {
      const loginResponse = LoginResponse(
        accessToken: 'access-token',
        refreshToken: 'refresh-token',
        tokenType: 'Bearer',
        ttl: 10800,
      );

      expect(loginResponse.accessToken, 'access-token');
      expect(loginResponse.refreshToken, 'refresh-token');
      expect(loginResponse.tokenType, 'Bearer');
      expect(loginResponse.ttl, 10800);

      final json = loginResponse.toJson();
      expect(json['access_token'], 'access-token');
      expect(json['refresh_token'], 'refresh-token');
      expect(json['token_type'], 'Bearer');
      expect(json['ttl'], 10800);
    });
  });
}
