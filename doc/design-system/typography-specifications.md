# Typography Specifications

This document contains the complete typography specifications extracted from the Figma design system and comprehensive Flutter implementation guidelines.

## Typography Scale

**Base Value:** 16px  
**Scale:** 1.25 (Major Third)

## Typography Styles

### 1. Display Large (36px)

- **font-family:** Public Sans
- **font-weight:** 400
- **font-style:** Regular
- **font-size:** 36px
- **leading-trim:** NONE
- **line-height:** 120%
- **letter-spacing:** 0%
- **text-align:** LEFT
- **text-align-vertical:** TOP

### 2. Display Medium (32px)

- **font-family:** Public Sans
- **font-weight:** 400
- **font-style:** Regular
- **font-size:** 32px
- **leading-trim:** NONE
- **line-height:** 120%
- **letter-spacing:** 0%
- **text-align:** LEFT
- **text-align-vertical:** TOP

### 3. Heading Large (24px)

- **font-family:** Public Sans
- **font-weight:** 400
- **font-style:** Regular
- **font-size:** 24px
- **leading-trim:** NONE
- **line-height:** 120%
- **letter-spacing:** 0%
- **text-align:** LEFT
- **text-align-vertical:** TOP

### 4. Heading Medium (20px)

- **font-family:** Public Sans
- **font-weight:** 400
- **font-style:** Regular
- **font-size:** 20px
- **leading-trim:** NONE
- **line-height:** 120%
- **letter-spacing:** 0%
- **text-align:** LEFT
- **text-align-vertical:** TOP

### 5. Body Large (16px)

- **font-family:** Public Sans
- **font-weight:** 400
- **font-style:** Regular
- **font-size:** 16px
- **leading-trim:** NONE
- **line-height:** 120%
- **letter-spacing:** 0%
- **text-align:** LEFT
- **text-align-vertical:** TOP

### 6. Body Medium (14px)

- **font-family:** Public Sans
- **font-weight:** 400
- **font-style:** Regular
- **font-size:** 14px
- **leading-trim:** NONE
- **line-height:** 120%
- **letter-spacing:** 0%
- **text-align:** LEFT
- **text-align-vertical:** TOP

### 7. Body Small (12px)

- **font-family:** Public Sans
- **font-weight:** 400
- **font-style:** Regular
- **font-size:** 12px
- **leading-trim:** NONE
- **line-height:** 120%
- **letter-spacing:** 0%
- **text-align:** LEFT
- **text-align-vertical:** TOP

### 8. Caption (10px)

- **font-family:** Public Sans
- **font-weight:** 400
- **font-style:** Regular
- **font-size:** 10px
- **leading-trim:** NONE
- **line-height:** 120%
- **letter-spacing:** 0%
- **text-align:** LEFT
- **text-align-vertical:** TOP

## Typography Scale Reference

| Size           | Pixels | REM      | Usage                     |
| -------------- | ------ | -------- | ------------------------- |
| Display Large  | 36px   | 2.438rem | Large headings, hero text |
| Display Medium | 32px   | 1.938rem | Section headings          |
| Heading Large  | 24px   | 1.562rem | Page titles               |
| Heading Medium | 20px   | 1.250rem | Subsection headings       |
| Body Large     | 16px   | 1.000rem | Primary body text         |
| Body Medium    | 14px   | 0.812rem | Secondary body text       |
| Body Small     | 12px   | 0.625rem | Small text, captions      |
| Caption        | 10px   | 0.500rem | Fine print, labels        |

## Flutter Implementation Guidelines

### Prerequisites

Ensure these packages are added to your `pubspec.yaml`:

```yaml
dependencies:
  google_fonts: ^6.1.0
  flutter_screenutil: ^5.9.0
```

### Conversion Principles

#### 1. **Font Family**

```dart
// Figma: font-family: Public Sans
GoogleFonts.publicSans() // Use Google Fonts package
```

#### 2. **Font Weight**

```dart
// Figma: font-weight: 400
fontWeight: FontWeight.w400  // or FontWeight.normal
```

#### 3. **Font Size**

```dart
// Figma: font-size: 36px
fontSize: 36.0  // Use double values in Flutter
// For responsive: fontSize: 36.sp (with flutter_screenutil)
```

#### 4. **Line Height**

```dart
// Figma: line-height: 120%
height: 1.2  // 120% = 1.2 ratio in Flutter
```

#### 5. **Letter Spacing**

```dart
// Figma: letter-spacing: 0%
letterSpacing: 0.0  // 0% = 0.0 in Flutter
```

#### 6. **Text Alignment**

```dart
// Figma: text-align: LEFT, text-align-vertical: TOP
textAlign: TextAlign.left
textAlignVertical: TextAlignVertical.top
```

### Flutter Code Examples

#### Display Large (36px)

```dart
Text(
  'Your text content here',
  style: GoogleFonts.publicSans(
    fontWeight: FontWeight.w400,
    fontSize: 36.0,  // or 36.sp for responsive
    height: 1.2,
    letterSpacing: 0.0,
    color: Colors.black,
  ),
  textAlign: TextAlign.left,
  textAlignVertical: TextAlignVertical.top,
)
```

#### Display Medium (32px)

```dart
Text(
  'Section Heading',
  style: GoogleFonts.publicSans(
    fontWeight: FontWeight.w400,
    fontSize: 32.0,  // or 32.sp for responsive
    height: 1.2,
    letterSpacing: 0.0,
    color: Colors.black,
  ),
  textAlign: TextAlign.left,
  textAlignVertical: TextAlignVertical.top,
)
```

#### Heading Large (24px)

```dart
Text(
  'Page Title',
  style: GoogleFonts.publicSans(
    fontWeight: FontWeight.w400,
    fontSize: 24.0,  // or 24.sp for responsive
    height: 1.2,
    letterSpacing: 0.0,
    color: Colors.black,
  ),
  textAlign: TextAlign.left,
  textAlignVertical: TextAlignVertical.top,
)
```

#### Heading Medium (20px)

```dart
Text(
  'Subsection Heading',
  style: GoogleFonts.publicSans(
    fontWeight: FontWeight.w400,
    fontSize: 20.0,  // or 20.sp for responsive
    height: 1.2,
    letterSpacing: 0.0,
    color: Colors.black,
  ),
  textAlign: TextAlign.left,
  textAlignVertical: TextAlignVertical.top,
)
```

#### Body Large (16px)

```dart
Text(
  'Primary body text content',
  style: GoogleFonts.publicSans(
    fontWeight: FontWeight.w400,
    fontSize: 16.0,  // or 16.sp for responsive
    height: 1.2,
    letterSpacing: 0.0,
    color: Colors.black,
  ),
  textAlign: TextAlign.left,
  textAlignVertical: TextAlignVertical.top,
)
```

#### Body Medium (14px)

```dart
Text(
  'Secondary body text',
  style: GoogleFonts.publicSans(
    fontWeight: FontWeight.w400,
    fontSize: 14.0,  // or 14.sp for responsive
    height: 1.2,
    letterSpacing: 0.0,
    color: Colors.black,
  ),
  textAlign: TextAlign.left,
  textAlignVertical: TextAlignVertical.top,
)
```

#### Body Small (12px)

```dart
Text(
  'Small text and captions',
  style: GoogleFonts.publicSans(
    fontWeight: FontWeight.w400,
    fontSize: 12.0,  // or 12.sp for responsive
    height: 1.2,
    letterSpacing: 0.0,
    color: Colors.black,
  ),
  textAlign: TextAlign.left,
  textAlignVertical: TextAlignVertical.top,
)
```

#### Caption (10px)

```dart
Text(
  'Fine print and labels',
  style: GoogleFonts.publicSans(
    fontWeight: FontWeight.w400,
    fontSize: 10.0,  // or 10.sp for responsive
    height: 1.2,
    letterSpacing: 0.0,
    color: Colors.black,
  ),
  textAlign: TextAlign.left,
  textAlignVertical: TextAlignVertical.top,
)
```

### Responsive Implementation with flutter_screenutil

For responsive typography that adapts to different screen sizes:

```dart
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Initialize ScreenUtil in your main.dart
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: child,
        );
      },
      child: MyHomePage(),
    );
  }
}

// Use responsive font sizes
Text(
  'Responsive Typography',
  style: GoogleFonts.publicSans(
    fontWeight: FontWeight.w400,
    fontSize: 36.sp,  // Responsive font size
    height: 1.2,
    letterSpacing: 0.0,
    color: Colors.black,
  ),
)
```

### Complete Widget Example

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TypographyExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Typography System',
          style: GoogleFonts.publicSans(
            fontWeight: FontWeight.w400,
            fontSize: 20.sp,
            height: 1.2,
            letterSpacing: 0.0,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display Large
            Text(
              'Display Large Heading',
              style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w400,
                fontSize: 36.sp,
                height: 1.2,
                letterSpacing: 0.0,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16.h),

            // Body Large
            Text(
              'This is the primary body text that should be used for most content. It provides excellent readability and follows the design system specifications.',
              style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                height: 1.2,
                letterSpacing: 0.0,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16.h),

            // Body Small
            Text(
              'This is smaller text used for captions and secondary information.',
              style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
                height: 1.2,
                letterSpacing: 0.0,
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Text Style Extensions (Recommended)

Create reusable text styles for better maintainability:

```dart
// lib/core/styles/text_styles.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  // Display Large
  static TextStyle get displayLarge => GoogleFonts.publicSans(
    fontWeight: FontWeight.w400,
    fontSize: 36.sp,
    height: 1.2,
    letterSpacing: 0.0,
  );

  // Display Medium
  static TextStyle get displayMedium => GoogleFonts.publicSans(
    fontWeight: FontWeight.w400,
    fontSize: 32.sp,
    height: 1.2,
    letterSpacing: 0.0,
  );

  // Heading Large
  static TextStyle get headingLarge => GoogleFonts.publicSans(
    fontWeight: FontWeight.w400,
    fontSize: 24.sp,
    height: 1.2,
    letterSpacing: 0.0,
  );

  // Heading Medium
  static TextStyle get headingMedium => GoogleFonts.publicSans(
    fontWeight: FontWeight.w400,
    fontSize: 20.sp,
    height: 1.2,
    letterSpacing: 0.0,
  );

  // Body Large
  static TextStyle get bodyLarge => GoogleFonts.publicSans(
    fontWeight: FontWeight.w400,
    fontSize: 16.sp,
    height: 1.2,
    letterSpacing: 0.0,
  );

  // Body Medium
  static TextStyle get bodyMedium => GoogleFonts.publicSans(
    fontWeight: FontWeight.w400,
    fontSize: 14.sp,
    height: 1.2,
    letterSpacing: 0.0,
  );

  // Body Small
  static TextStyle get bodySmall => GoogleFonts.publicSans(
    fontWeight: FontWeight.w400,
    fontSize: 12.sp,
    height: 1.2,
    letterSpacing: 0.0,
  );

  // Caption
  static TextStyle get caption => GoogleFonts.publicSans(
    fontWeight: FontWeight.w400,
    fontSize: 10.sp,
    height: 1.2,
    letterSpacing: 0.0,
  );
}

// Usage in widgets
Text(
  'Hello World',
  style: AppTextStyles.headingLarge.copyWith(
    color: Colors.blue,
  ),
)
```

## Implementation Notes

- All typography styles use the **Public Sans** font family
- Font weight is consistently **400 (Regular)** across all styles
- Line height is consistently **120%** for optimal readability
- Letter spacing is **0%** (normal) for all styles
- Text alignment is **LEFT** horizontally and **TOP** vertically
- The typography scale follows a **1.25 (Major Third)** ratio
- Base value is **16px** which equals **1.000rem**

## Usage Guidelines

1. **Display Large (36px)** - Use for hero text, main page titles, and prominent call-to-action text
2. **Display Medium (32px)** - Use for section headings and important announcements
3. **Heading Large (24px)** - Use for page titles and major section headers
4. **Heading Medium (20px)** - Use for subsection headings and card titles
5. **Body Large (16px)** - Use for primary body text, paragraphs, and main content
6. **Body Medium (14px)** - Use for secondary text, descriptions, and supporting content
7. **Body Small (12px)** - Use for small text, metadata, and less important information
8. **Caption (10px)** - Use for fine print, legal text, and minimal labels

## Color Specifications

- **Primary Text Color:** #000000 (Black)
- **Secondary Text Color:** #000000 with 40% opacity (for labels and metadata)

## Responsive Considerations

- All font sizes are designed to work well on mobile devices
- The 1.25 scale ratio ensures good hierarchy and readability
- Line height of 120% provides optimal reading experience
- Use `flutter_screenutil` for responsive font sizes across different screen densities
- Consider adjusting font sizes for different screen densities if needed

## Best Practices

1. **Consistency**: Always use the predefined text styles from `AppTextStyles`
2. **Responsive**: Use `.sp` extension for responsive font sizes
3. **Accessibility**: Ensure sufficient color contrast for text readability
4. **Performance**: Use `GoogleFonts.publicSans()` for optimal font loading
5. **Maintainability**: Keep all typography definitions in a centralized location

## Troubleshooting

### Common Issues

1. **Font not loading**: Ensure `google_fonts` package is properly configured
2. **Responsive issues**: Make sure `ScreenUtilInit` is properly set up in main.dart
3. **Text overflow**: Use `overflow: TextOverflow.ellipsis` for long text
4. **Line height issues**: Use `height` property instead of `lineHeight` for better control

### Performance Tips

1. **Font caching**: Google Fonts automatically caches fonts for better performance
2. **Text style reuse**: Create reusable text styles to avoid recreating styles
3. **Responsive optimization**: Use `minTextAdapt: true` in ScreenUtilInit for better text scaling

---

_Generated from Figma design: Mobile App (3rhdjKqT4amsnWZw0nV9Y7)_  
_Last updated: September 4, 2025_
