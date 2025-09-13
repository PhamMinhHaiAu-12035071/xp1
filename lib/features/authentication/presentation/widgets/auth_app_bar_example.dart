import 'package:flutter/material.dart';
import 'package:xp1/core/themes/extensions/app_theme_extension.dart';
import 'package:xp1/features/authentication/presentation/widgets/auth_app_bar.dart';

/// Example usage of AuthAppBar widget.
///
/// Demonstrates different configurations and use cases
/// for the custom authentication AppBar.
class AuthAppBarExample extends StatelessWidget {
  /// Creates an AuthAppBar example.
  const AuthAppBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthAppBar(
        title: 'Authentication',
        // Uses default back arrow icon and Navigator.pop() behavior
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'AuthAppBar Examples',
              style: context.textStyles.headingLarge(),
            ),
            const SizedBox(height: 32),
            _buildExampleButton(
              context,
              'Default AppBar',
              () => _showExamplePage(
                context,
                'Default AppBar',
                const AuthAppBar(title: 'Default AppBar'),
              ),
            ),
            const SizedBox(height: 16),
            _buildExampleButton(
              context,
              'Custom Left Icon',
              () => _showExamplePage(
                context,
                'Custom Left Icon',
                AuthAppBar(
                  title: 'Custom Icon',
                  leftIcon: context.appIcons.menu, // Custom icon
                  onLeftIconTap: () => _showCustomAction(context),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildExampleButton(
              context,
              'Colored Background',
              () => _showExamplePage(
                context,
                'Colored Background',
                AuthAppBar(
                  title: 'Colored Background',
                  backgroundColor: context.colors.orangeLight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds an example button with consistent styling.
  Widget _buildExampleButton(
    BuildContext context,
    String text,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: context.colors.amberNormal,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.sizes.r8),
        ),
      ),
      child: Text(text),
    );
  }

  /// Shows an example page with the specified AppBar.
  void _showExamplePage(
    BuildContext context,
    String title,
    PreferredSizeWidget appBar,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => Scaffold(
          appBar: appBar,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: context.textStyles.headingMedium(),
                ),
                const SizedBox(height: 16),
                Text(
                  'This is an example page demonstrating the AuthAppBar '
                  'widget.',
                  style: context.textStyles.bodyMedium(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Shows a custom action when custom left icon is tapped.
  void _showCustomAction(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Custom left icon tapped!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
