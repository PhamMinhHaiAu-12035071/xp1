import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:yaml/yaml.dart';

void main() {
  group('Flutter Launcher Icons Integration Tests', () {
    test('flutter_launcher_icons.yaml configuration should be valid', () {
      // Arrange
      final configFile = File('flutter_launcher_icons.yaml');

      // Act & Assert
      expect(
        configFile.existsSync(),
        isTrue,
        reason: 'Configuration file should exist',
      );

      final content = configFile.readAsStringSync();
      final yaml = loadYaml(content) as Map;

      // Verify required configuration fields
      expect(yaml['flutter_launcher_icons'], isNotNull);

      final config = yaml['flutter_launcher_icons'] as Map;
      expect(config['android'], equals('launcher_icon'));
      expect(config['ios'], isTrue);
      expect(config['image_path'], isNotNull);
      expect(config['remove_alpha_ios'], isTrue);
      expect(config['min_sdk_android'], equals(21));

      // Verify web configuration
      expect(config['web'], isNotNull);
      final webConfig = config['web'] as Map;
      expect(webConfig['generate'], isTrue);
      expect(webConfig['image_path'], isNotNull);
      expect(webConfig['background_color'], isNotNull);
      expect(webConfig['theme_color'], isNotNull);
    });

    test('master app icon asset should exist', () {
      // Arrange
      final iconFile = File('assets/icons/app_icons/app_icon.png');

      // Act & Assert
      expect(
        iconFile.existsSync(),
        isTrue,
        reason: 'Master app icon should exist',
      );

      // Verify file size is reasonable (should be larger than 0)
      final fileSize = iconFile.lengthSync();
      expect(fileSize, greaterThan(0), reason: 'Icon file should not be empty');
    });

    test('pubspec.yaml should include app_icons assets directory', () {
      // Arrange
      final pubspecFile = File('pubspec.yaml');

      // Act
      final content = pubspecFile.readAsStringSync();
      final yaml = loadYaml(content) as Map;

      // Assert
      expect(yaml['flutter'], isNotNull);
      final flutter = yaml['flutter'] as Map;
      expect(flutter['assets'], isNotNull);

      final assets = flutter['assets'] as List;
      expect(
        assets.any((asset) => asset.toString().contains('app_icons/')),
        isTrue,
        reason: 'Assets should include app_icons directory',
      );
    });

    group('Generated Platform Icons', () {
      test('Android icons should be generated', () {
        // Android mipmap directories
        final mipmapDirs = [
          'android/app/src/main/res/mipmap-hdpi/',
          'android/app/src/main/res/mipmap-mdpi/',
          'android/app/src/main/res/mipmap-xhdpi/',
          'android/app/src/main/res/mipmap-xxhdpi/',
          'android/app/src/main/res/mipmap-xxxhdpi/',
        ];

        for (final dirPath in mipmapDirs) {
          final dir = Directory(dirPath);
          if (dir.existsSync()) {
            final launcherIcon = File('${dirPath}launcher_icon.png');
            expect(
              launcherIcon.existsSync(),
              isTrue,
              reason: 'launcher_icon.png should exist in $dirPath',
            );

            final fileSize = launcherIcon.lengthSync();
            expect(
              fileSize,
              greaterThan(0),
              reason: 'Icon file should not be empty in $dirPath',
            );
          }
        }
      });

      test('iOS icons should be generated', () {
        // iOS AppIcon.appiconset directory
        final iosIconDir = Directory(
          'ios/Runner/Assets.xcassets/AppIcon.appiconset/',
        );

        if (iosIconDir.existsSync()) {
          final contentsJson = File('${iosIconDir.path}Contents.json');
          expect(
            contentsJson.existsSync(),
            isTrue,
            reason: 'Contents.json should exist',
          );

          // Check for some key iOS icon files
          final iconFiles = [
            'Icon-App-1024x1024@1x.png',
            'Icon-App-60x60@2x.png',
            'Icon-App-60x60@3x.png',
          ];

          for (final iconFileName in iconFiles) {
            final iconFile = File('${iosIconDir.path}$iconFileName');
            if (iconFile.existsSync()) {
              final fileSize = iconFile.lengthSync();
              expect(
                fileSize,
                greaterThan(0),
                reason: '$iconFileName should not be empty',
              );
            }
          }
        }
      });

      test('Web icons should be generated', () {
        // Web favicon and icons
        final webFavicon = File('web/favicon.png');
        if (webFavicon.existsSync()) {
          expect(
            webFavicon.lengthSync(),
            greaterThan(0),
            reason: 'Web favicon should not be empty',
          );
        }

        final webIconsDir = Directory('web/icons/');
        if (webIconsDir.existsSync()) {
          final webIcons = ['Icon-192.png', 'Icon-512.png'];

          for (final iconFileName in webIcons) {
            final iconFile = File('${webIconsDir.path}$iconFileName');
            if (iconFile.existsSync()) {
              final fileSize = iconFile.lengthSync();
              expect(
                fileSize,
                greaterThan(0),
                reason: '$iconFileName should not be empty',
              );
            }
          }
        }
      });
    });

    test('pubspec.yaml should include flutter_launcher_icons dependency', () {
      // Arrange
      final pubspecFile = File('pubspec.yaml');

      // Act
      final content = pubspecFile.readAsStringSync();
      final yaml = loadYaml(content) as Map;

      // Assert
      expect(yaml['dev_dependencies'], isNotNull);
      final devDeps = yaml['dev_dependencies'] as Map;
      expect(
        devDeps['flutter_launcher_icons'],
        isNotNull,
        reason: 'flutter_launcher_icons should be in dev_dependencies',
      );

      // Verify version format
      final version = devDeps['flutter_launcher_icons'].toString();
      expect(
        version.startsWith('^'),
        isTrue,
        reason: 'Version should use caret notation for flexibility',
      );
    });
  });

  group('Makefile Integration Tests', () {
    test('Makefile should include generate-icons command', () {
      // Arrange
      final makeFile = File('Makefile');

      // Act & Assert
      expect(makeFile.existsSync(), isTrue, reason: 'Makefile should exist');

      final content = makeFile.readAsStringSync();
      expect(
        content.contains('generate-icons:'),
        isTrue,
        reason: 'Makefile should contain generate-icons command',
      );
      expect(
        content.contains('pub run flutter_launcher_icons'),
        isTrue,
        reason: 'Makefile should contain flutter_launcher_icons command',
      );
    });
  });
}
