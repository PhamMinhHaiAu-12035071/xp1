# Authentication Widgets

This directory contains reusable widgets for authentication screens.

## AuthAppBar

A custom AppBar widget designed specifically for authentication screens with consistent styling and responsive design.

### Features

- **Left Icon**: Customizable left icon with default back arrow
- **Center Title**: Centered title with proper typography
- **Responsive Design**: Adapts to different screen sizes
- **Design System Integration**: Uses app's color, typography, and sizing system
- **Accessibility**: Proper semantic labels and touch targets
- **Customizable**: Background color, elevation, and tap callbacks

### Usage

#### Basic Usage

```dart
import 'package:xp1/features/authentication/presentation/widgets/auth_app_bar.dart';

class MyAuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthAppBar(
        title: 'Login',
      ),
      body: // Your page content
    );
  }
}
```

#### Custom Left Icon

```dart
AuthAppBar(
  title: 'Settings',
  leftIcon: context.appIcons.menu,
  onLeftIconTap: () => _showDrawer(),
)
```

#### Custom Background

```dart
AuthAppBar(
  title: 'Profile',
  backgroundColor: context.colors.orangeLight,
  elevation: 2,
)
```

### Parameters

| Parameter         | Type            | Default  | Description                                                     |
| ----------------- | --------------- | -------- | --------------------------------------------------------------- |
| `title`           | `String`        | Required | The title text to display in the center                         |
| `leftIcon`        | `String?`       | `null`   | Custom left icon path (defaults to back arrow)                  |
| `onLeftIconTap`   | `VoidCallback?` | `null`   | Callback when left icon is tapped (defaults to Navigator.pop()) |
| `backgroundColor` | `Color?`        | `null`   | Background color (defaults to transparent)                      |
| `elevation`       | `double`        | `0`      | AppBar elevation                                                |

### Design System Integration

The widget automatically uses:

- **Colors**: `context.colors.greyNormal` for text and icons
- **Typography**: `context.textStyles.headingMedium()` for title
- **Sizing**: `context.sizes.r*` for responsive dimensions
- **Icons**: `context.iconService` and `context.appIcons` for SVG icons

### Examples

See `auth_app_bar_example.dart` for comprehensive usage examples including:

- Default AppBar
- Custom left icon
- Colored background
- Custom tap handlers

### Accessibility

- Proper semantic labels for screen readers
- Adequate touch target sizes (48x48dp minimum)
- High contrast colors following design system
- Keyboard navigation support
