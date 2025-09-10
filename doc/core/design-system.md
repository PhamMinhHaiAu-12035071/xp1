# Design System & Styling Architecture

## Overview

This project implements a **comprehensive design system** with colors, typography, spacing, and theming using a clean dependency injection architecture. The system provides type-safe, consistent, and maintainable styling across the entire application.

## Architecture

### Core Components

```
lib/core/
├── styles/
│   ├── colors/
│   │   ├── app_colors.dart          # Abstract color contracts
│   │   └── app_colors_impl.dart     # Concrete color implementation with DI
│   ├── app_text_styles.dart         # Abstract typography contracts
│   └── app_text_styles_impl.dart    # Concrete typography with DI
├── sizes/
│   ├── app_sizes.dart               # Abstract sizing contracts
│   └── app_sizes_impl.dart          # Responsive sizing implementation with DI
└── themes/
    ├── app_theme.dart               # Theme orchestration (light/dark)
    └── extensions/
        ├── app_color_extension.dart    # Custom theme extension
        └── app_theme_extension.dart    # Additional theme extensions
```

### Design Principles

- **Type Safety**: All design tokens are strongly typed with no magic numbers or strings
- **Dependency Injection**: All components use `@LazySingleton` for consistent access
- **Responsive Design**: Automatic responsive scaling with `flutter_screenutil` integration
- **Semantic Naming**: Colors and typography use semantic rather than descriptive names
- **Material 3 Integration**: Full Material Design 3 support with custom extensions
- **Theme Support**: Complete light/dark mode support with automatic switching
- **Consistency**: Single source of truth for all design decisions

## Quick Start

### 1. Service Injection

All design system services are automatically registered in the DI container:

```dart
@LazySingleton(as: AppColors)
class AppColorsImpl implements AppColors { ... }

@LazySingleton(as: AppTextStyles)
class AppTextStylesImpl implements AppTextStyles { ... }

@LazySingleton(as: AppSizes)
class AppSizesImpl implements AppSizes { ... }
```

### 2. Basic Usage

```dart
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = GetIt.instance<AppColors>();
    final appTextStyles = GetIt.instance<AppTextStyles>();
    final appSizes = GetIt.instance<AppSizes>();

    return Container(
      width: appSizes.r120,                     // 120px responsive
      padding: EdgeInsets.all(appSizes.r16),   // 16px responsive padding
      decoration: BoxDecoration(
        color: appColors.amberLight,            // Semantic color
        borderRadius: BorderRadius.circular(appSizes.borderRadiusMd),
      ),
      child: Text(
        'Design System Example',
        style: appTextStyles.headingMedium(
          color: appColors.charcoal,            // Consistent text color
        ),
      ),
    );
  }
}
```

## Color System

### Color Architecture

The color system provides **8 complete color palettes** with comprehensive variations:

#### Brand Colors

- **Amber Palette**: Primary brand colors with 5 variants each
  - `amberLight` (#FF9575) - Light backgrounds, subtle highlights
  - `amberNormal` (#FF6B35) - Main brand color, primary CTAs
  - `amberDark` (#CC5429) - Secondary buttons, icons, borders
  - `amberDarker` (#923315) - Strong emphasis, deep shadows
  - **Interactive States**: Each color has hover/active variants

#### Semantic Colors

- **Green Palette**: Success states, positive indicators
- **Red Palette**: Error states, danger alerts, critical actions
- **Blue Palette**: Information states, links, secondary actions
- **Orange Palette**: Accent elements, highlights, warnings

#### Neutral Colors

- **Grey Palette**: Text, backgrounds, borders with comprehensive variations
- **Charcoal** (#2D3436): Primary text color
- **Warm Gray** (#8B7355): Secondary text, placeholders
- **Light Gray** (#F8F9FA): Page backgrounds, card backgrounds

#### Specialty Colors

- **Pink Palette**: Accent elements, feminine design
- **Slate Palette**: Dark themes, professional UI elements

### Color Usage Patterns

#### State-Based Colors

```dart
// Interactive button with proper state management
Widget buildInteractiveButton({
  required ButtonState state,
  required VoidCallback onPressed,
}) {
  final appColors = GetIt.instance<AppColors>();

  final buttonColor = switch (state) {
    ButtonState.normal => appColors.amberNormal,
    ButtonState.hover => appColors.amberNormalHover,
    ButtonState.active => appColors.amberNormalActive,
    ButtonState.disabled => appColors.greyLight,
  };

  return ElevatedButton(
    style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
    onPressed: state == ButtonState.disabled ? null : onPressed,
    child: Text('Interactive Button'),
  );
}
```

#### Semantic Color Usage

```dart
// Status indicators with semantic colors
Widget buildStatusIndicators() {
  final appColors = GetIt.instance<AppColors>();

  return Row(
    children: [
      StatusIcon(color: appColors.greenNormal, status: 'Success'),
      StatusIcon(color: appColors.redNormal, status: 'Error'),
      StatusIcon(color: appColors.blueNormal, status: 'Info'),
      StatusIcon(color: appColors.orangeNormal, status: 'Warning'),
    ],
  );
}
```

#### Material Color Integration

All colors are provided as `MaterialColor` with full shade variations:

```dart
// Access specific shades when needed
final primaryShades = appColors.amberNormal;
final lightShade = primaryShades[200];  // Lighter variant
final darkShade = primaryShades[800];   // Darker variant
```

## Typography System

### Typography Scale

**8-level typography system** based on Public Sans font with consistent properties:

- **Font Family**: Public Sans
- **Font Weight**: 400 (Regular) for all styles
- **Line Height**: 120% for optimal readability
- **Letter Spacing**: 0% for clean appearance

#### Typography Levels

```dart
// Display typography (largest)
Text('Hero Title', style: appTextStyles.displayLarge());    // 36px
Text('Page Title', style: appTextStyles.displayMedium());   // 32px

// Heading typography
Text('Section Header', style: appTextStyles.headingLarge());   // 24px
Text('Subsection', style: appTextStyles.headingMedium());      // 20px

// Body typography
Text('Primary content', style: appTextStyles.bodyLarge());     // 16px
Text('Secondary text', style: appTextStyles.bodyMedium());     // 14px
Text('Supporting info', style: appTextStyles.bodySmall());     // 12px

// Fine typography
Text('Legal text', style: appTextStyles.caption());           // 10px
```

### Typography Usage Patterns

#### Color Integration

```dart
// Typography with semantic colors
Widget buildTypographyExample() {
  final appTextStyles = GetIt.instance<AppTextStyles>();
  final appColors = GetIt.instance<AppColors>();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Primary Heading',
        style: appTextStyles.headingLarge(color: appColors.charcoal),
      ),
      Text(
        'Secondary content with contextual color',
        style: appTextStyles.bodyMedium(color: appColors.warmGray),
      ),
      Text(
        'Error message example',
        style: appTextStyles.bodySmall(color: appColors.redNormal),
      ),
    ],
  );
}
```

#### Responsive Typography

Typography automatically scales with the responsive system:

```dart
// Typography automatically adapts to screen size via ScreenUtil
Text(
  'Responsive Text',
  style: appTextStyles.bodyLarge(), // Automatically becomes responsive
)
```

## Responsive Sizing System

### Sizing Architecture

The sizing system provides **three variants for every dimension**:

- **r** (responsive): Both width and height - `appSizes.r16` → `16.r`
- **v** (vertical): Height only - `appSizes.v16` → `16.h`
- **h** (horizontal): Width only - `appSizes.h16` → `16.w`

### Size Scale

**Comprehensive scale from 2px to 680px** with commonly used values:

```dart
// Micro spacing
appSizes.r2, appSizes.r4, appSizes.r5, appSizes.r6, appSizes.r8

// Standard spacing
appSizes.r10, appSizes.r12, appSizes.r16, appSizes.r20, appSizes.r24

// Layout spacing
appSizes.r32, appSizes.r40, appSizes.r48, appSizes.r64, appSizes.r80

// Large layout elements
appSizes.r120, appSizes.r160, appSizes.r192, appSizes.r256

// Specialized sizes
appSizes.r260  // Onboarding image size
appSizes.r372  // Specific layout requirements
appSizes.r680  // Large container widths
```

### Border Radius Constants

```dart
// Consistent border radius values
decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(appSizes.borderRadiusXs),  // Extra small
  // borderRadius: BorderRadius.circular(appSizes.borderRadiusSm),  // Small
  // borderRadius: BorderRadius.circular(appSizes.borderRadiusMd),  // Medium
  // borderRadius: BorderRadius.circular(appSizes.borderRadiusLg),  // Large
)
```

### Responsive Layout Patterns

#### Complete Responsive Layout

```dart
Widget buildResponsiveLayout() {
  final appSizes = GetIt.instance<AppSizes>();

  return Container(
    width: appSizes.r120,      // 120px responsive (both dimensions)
    height: appSizes.v80,      // 80px responsive height only
    padding: EdgeInsets.all(appSizes.r16),
    margin: EdgeInsets.symmetric(
      horizontal: appSizes.h20,  // 20px responsive horizontal margin
      vertical: appSizes.v12,    // 12px responsive vertical margin
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(appSizes.borderRadiusMd),
    ),
  );
}
```

#### Grid Layouts

```dart
Widget buildResponsiveGrid() {
  final appSizes = GetIt.instance<AppSizes>();

  return GridView.builder(
    padding: EdgeInsets.all(appSizes.r16),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: appSizes.h16,  // Horizontal spacing
      mainAxisSpacing: appSizes.v16,   // Vertical spacing
      childAspectRatio: 1.0,
    ),
    itemBuilder: (context, index) {
      return Container(
        padding: EdgeInsets.all(appSizes.r12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(appSizes.borderRadiusMd),
        ),
      );
    },
  );
}
```

## Theme System

### Theme Architecture

The theme system provides **automatic light/dark mode support** with custom extensions:

#### Theme Creation

```dart
// Light theme with custom extensions
final lightTheme = AppTheme.lightTheme();

// Dark theme with custom extensions
final darkTheme = AppTheme.darkTheme();

// Apply to MaterialApp
MaterialApp(
  theme: lightTheme,
  darkTheme: darkTheme,
  themeMode: ThemeMode.system, // Follows system preference
)
```

#### Custom Theme Extensions

```dart
// Access theme-aware colors
Widget buildThemedWidget(BuildContext context) {
  final appTextStyles = GetIt.instance<AppTextStyles>();
  final colorExtension = context.theme.extension<AppColorExtension>()!;

  return Container(
    color: colorExtension.primary,      // Automatically switches with theme
    child: Text(
      'Theme-aware Content',
      style: appTextStyles.bodyLarge(
        color: colorExtension.textPrimary,  // Theme-aware text color
      ),
    ),
  );
}
```

### Theme Extension Properties

```dart
class AppColorExtension extends ThemeExtension<AppColorExtension> {
  final Color primary;       // Theme-appropriate primary color
  final Color secondary;     // Theme-appropriate secondary color
  final Color accent;        // Theme-appropriate accent color
  final Color textPrimary;   // Theme-appropriate primary text
  final Color textSecondary; // Theme-appropriate secondary text

  // Automatic light/dark variants via factory constructors
  factory AppColorExtension.light() { ... }
  factory AppColorExtension.dark() { ... }
}
```

## Advanced Usage

### Design System Integration

#### Complete Component Example

```dart
class DesignSystemCard extends StatelessWidget {
  const DesignSystemCard({
    super.key,
    required this.title,
    required this.content,
    this.onTap,
  });

  final String title;
  final String content;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final appColors = GetIt.instance<AppColors>();
    final appTextStyles = GetIt.instance<AppTextStyles>();
    final appSizes = GetIt.instance<AppSizes>();
    final colorExtension = context.theme.extension<AppColorExtension>()!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: appSizes.r280,
        padding: EdgeInsets.all(appSizes.r16),
        decoration: BoxDecoration(
          color: colorExtension.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(appSizes.borderRadiusMd),
          border: Border.all(
            color: appColors.greyLight,
            width: 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: appTextStyles.headingMedium(
                color: colorExtension.textPrimary,
              ),
            ),
            SizedBox(height: appSizes.v8),
            Text(
              content,
              style: appTextStyles.bodyMedium(
                color: colorExtension.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

#### State Management Integration

```dart
class StatefulDesignButton extends StatefulWidget {
  const StatefulDesignButton({super.key});

  @override
  State<StatefulDesignButton> createState() => _StatefulDesignButtonState();
}

class _StatefulDesignButtonState extends State<StatefulDesignButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final appColors = GetIt.instance<AppColors>();
    final appTextStyles = GetIt.instance<AppTextStyles>();
    final appSizes = GetIt.instance<AppSizes>();

    // Use design system state colors
    final buttonColor = switch ((_isPressed, _isHovered)) {
      (true, _) => appColors.amberNormalActive,
      (false, true) => appColors.amberNormalHover,
      (false, false) => appColors.amberNormal,
    };

    final textColor = switch ((_isPressed, _isHovered)) {
      (true, _) => appColors.charcoal,
      (false, true) => appColors.charcoal,
      (false, false) => appColors.charcoal,
    };

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: appSizes.h20,
            vertical: appSizes.v12,
          ),
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(appSizes.borderRadiusMd),
          ),
          child: Text(
            'Stateful Button',
            style: appTextStyles.bodyLarge(color: textColor),
          ),
        ),
      ),
    );
  }
}
```

## Testing

### Design System Testing Strategy

The design system includes comprehensive testing patterns:

#### Color Consistency Testing

```dart
testWidgets('should use design system colors consistently', (tester) async {
  final appColors = const AppColorsImpl();

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: appColors.amberNormal,
          ),
          onPressed: () {},
          child: Text('Test Button'),
        ),
      ),
    ),
  );

  expect(find.byType(ElevatedButton), findsOneWidget);

  final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
  final buttonStyle = button.style!;

  // Verify design system color is applied correctly
  expect(
    buttonStyle.backgroundColor!.resolve({}),
    equals(appColors.amberNormal),
  );
});
```

#### Responsive Sizing Testing

```dart
testWidgets('should apply responsive sizing correctly', (tester) async {
  final appSizes = AppSizesImpl();

  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) {
          ScreenUtil.init(context, designSize: const Size(375, 812));
          return Container(
            width: appSizes.r100,   // Should become 100.w
            height: appSizes.v80,   // Should become 80.h
            child: Text('Responsive Container'),
          );
        },
      ),
    ),
  );

  expect(find.byType(Container), findsOneWidget);
  expect(find.text('Responsive Container'), findsOneWidget);
});
```

#### Typography Testing

```dart
testWidgets('should apply typography styles correctly', (tester) async {
  final appTextStyles = AppTextStylesImpl();

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Text(
          'Test Typography',
          style: appTextStyles.headingLarge(),
        ),
      ),
    ),
  );

  expect(find.text('Test Typography'), findsOneWidget);

  final textWidget = tester.widget<Text>(find.text('Test Typography'));
  final textStyle = textWidget.style!;

  // Verify typography properties
  expect(textStyle.fontSize, equals(24.0));  // headingLarge size
  expect(textStyle.fontFamily, equals('Public Sans'));
  expect(textStyle.fontWeight, equals(FontWeight.w400));
});
```

#### Theme Extension Testing

```dart
testWidgets('should switch colors with theme changes', (tester) async {
  final lightTheme = AppTheme.lightTheme();
  final darkTheme = AppTheme.darkTheme();

  Widget buildThemedWidget(ThemeData theme) {
    return MaterialApp(
      theme: theme,
      home: Builder(
        builder: (context) {
          final colorExtension = context.theme.extension<AppColorExtension>()!;
          return Container(
            color: colorExtension.primary,
            child: Text('Themed Widget'),
          );
        },
      ),
    );
  }

  // Test light theme
  await tester.pumpWidget(buildThemedWidget(lightTheme));
  expect(find.text('Themed Widget'), findsOneWidget);

  // Test dark theme
  await tester.pumpWidget(buildThemedWidget(darkTheme));
  expect(find.text('Themed Widget'), findsOneWidget);
});
```

## Migration Guide

### From Manual Styling

#### Before (Manual Colors and Sizing)

```dart
Widget buildOldStyleButton() {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFFFF6B35), // Magic number
      padding: EdgeInsets.all(16.0),      // Fixed padding
    ),
    onPressed: () {},
    child: Text(
      'Old Style Button',
      style: TextStyle(
        fontSize: 16.0,                    // Fixed font size
        fontWeight: FontWeight.w400,
        color: Color(0xFF2D3436),         // Magic number
      ),
    ),
  );
}
```

#### After (Design System)

```dart
Widget buildDesignSystemButton() {
  final appColors = GetIt.instance<AppColors>();
  final appTextStyles = GetIt.instance<AppTextStyles>();
  final appSizes = GetIt.instance<AppSizes>();

  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: appColors.amberNormal,        // Semantic color
      padding: EdgeInsets.all(appSizes.r16),        // Responsive padding
    ),
    onPressed: () {},
    child: Text(
      'Design System Button',
      style: appTextStyles.bodyLarge(
        color: appColors.charcoal,                   // Semantic text color
      ),
    ),
  );
}
```

### From Theme Data Only

#### Before (ThemeData Colors)

```dart
Widget buildThemedWidget(BuildContext context) {
  return Container(
    color: Theme.of(context).primaryColor,          // Limited theme colors
    child: Text(
      'Themed Content',
      style: Theme.of(context).textTheme.bodyLarge, // Limited text styles
    ),
  );
}
```

#### After (Design System + Theme Extensions)

```dart
Widget buildDesignSystemThemedWidget(BuildContext context) {
  final appTextStyles = GetIt.instance<AppTextStyles>();
  final colorExtension = context.theme.extension<AppColorExtension>()!;

  return Container(
    color: colorExtension.primary,                  // Rich theme colors
    child: Text(
      'Design System Themed Content',
      style: appTextStyles.bodyLarge(              // Consistent typography
        color: colorExtension.textPrimary,         // Theme-aware text
      ),
    ),
  );
}
```

## Best Practices

### 1. Always Use Design System Services

- Never use hard-coded colors, sizes, or text styles
- Always inject services via `GetIt.instance<T>()`

### 2. Use Semantic Color Names

- Use `amberNormal` instead of `orangeColor`
- Use `greenNormal` for success states
- Use `redNormal` for error states

### 3. Leverage Interactive States

- Use hover/active color variants for better UX
- Implement proper state management for interactive elements

### 4. Maintain Responsive Design

- Use `r`/`v`/`h` sizing variants appropriately
- Test on different screen sizes

### 5. Follow Typography Hierarchy

- Use appropriate text styles for content hierarchy
- Maintain consistent line height and spacing

### 6. Theme-Aware Development

- Use theme extensions for automatic light/dark switching
- Test both theme modes

### 7. Test Design System Integration

- Write tests for color consistency
- Test responsive behavior
- Verify theme switching

## Troubleshooting

### Common Issues

1. **Colors not showing correctly**

   - Verify `AppColors` is registered in DI
   - Check color usage (use `appColors.amberNormal` not `appColors.amber`)
   - Ensure Material 3 is enabled

2. **Responsive sizing not working**

   - Check `ScreenUtil` initialization in app startup
   - Verify `AppSizes` is registered in DI
   - Use correct sizing variants (`r`/`v`/`h`)

3. **Typography not applying**

   - Verify `AppTextStyles` is registered in DI
   - Check font family installation (Public Sans)
   - Ensure text styles are applied correctly

4. **Theme extensions not working**
   - Verify theme extensions are added to `ThemeData`
   - Check theme extension registration
   - Use `context.theme.extension<T>()!` correctly

### Debug Commands

```bash
# Verify design system services are registered
flutter test test/core/di_setup_test.dart

# Test design system integration
flutter test test/core/styles/
flutter test test/core/themes/

# Test responsive behavior
flutter test --dart-define=ENVIRONMENT=development

# Check theme switching
flutter run --dart-define=ENVIRONMENT=development
```

## Performance Considerations

### Service Registration

- All design system services are registered as `@LazySingleton`
- Services are created only once and reused
- Minimal memory footprint

### Color Performance

- `MaterialColor` objects are const and cached
- Color calculations are performed at build time
- No runtime color generation overhead

### Responsive Calculations

- `ScreenUtil` calculations are cached
- Responsive values are computed once per screen size change
- Minimal performance impact

### Theme Switching

- Theme extensions use Flutter's built-in theme interpolation
- Smooth theme transitions with `lerp` methods
- No custom animation overhead

## Conclusion

This design system provides a complete, type-safe, and maintainable styling solution for Flutter applications. By following the established patterns and using dependency injection, developers can create consistent, responsive, and theme-aware user interfaces with minimal effort and maximum reliability.

The system scales from simple components to complex applications while maintaining design consistency and developer productivity. Regular testing and adherence to the documented patterns ensure long-term maintainability and design system evolution.
