import 'package:flutter/material.dart';

/// Defines standard color contracts for the application
abstract class AppColors {
  /// Primary brand color in light theme
  MaterialColor get primary;

  /// Secondary brand color in light theme
  MaterialColor get secondary;

  /// Black color variations
  MaterialColor get black;

  /// White color variations
  MaterialColor get white;

  /// Grey color variations
  MaterialColor get grey;

  /// Onboarding blue color variations
  MaterialColor get onboardingBlue;

  /// Error state color variations
  MaterialColor get error;

  /// Title text color variations
  MaterialColor get title;

  /// Placeholder text color variations
  MaterialColor get placeholder;

  /// Neutral color variations
  MaterialColor get neutral;

  /// Button color variations
  MaterialColor get button;

  /// Body text color variations
  MaterialColor get bodyText;

  /// Red color variations
  MaterialColor get red;

  /// Delete action color variations
  MaterialColor get delete;

  /// Blue color variations
  MaterialColor get blue;

  /// Divider color variations
  MaterialColor get divider;

  /// Green color variations
  MaterialColor get green;

  /// Main background color for light theme
  Color get bgMain;

  /// Accent color for light theme
  Color get accent;

  /// Primary text color for light theme
  Color get textPrimary;

  /// Secondary text color for light theme
  Color get textSecondary;

  /// Slate blue color
  Color get slateBlue;

  /// Placeholder text color (#8B95A7)
  /// Used for input field placeholder text
  Color get placeholderText;

  /// Onboarding background color
  Color get onboardingBackground;

  /// Onboarding gradient start color
  Color get onboardingGradientStart;

  /// Onboarding gradient end color
  Color get onboardingGradientEnd;

  /// Main background color for dark theme
  Color get bgMainDark;

  /// Primary brand color for dark theme
  Color get primaryDark;

  /// Secondary brand color for dark theme
  Color get secondaryDark;

  /// Accent color for dark theme
  Color get accentDark;

  /// Primary text color for dark theme
  Color get textPrimaryDark;

  /// Secondary text color for dark theme
  Color get textSecondaryDark;

  /// Transparent color
  Color get transparent;

  // === AMBER PALETTE (Based on Figma Design System) ===

  /// Amber light color (#FF9575)
  /// Used for light backgrounds, subtle highlights, soft accents
  MaterialColor get amberLight;

  /// Amber light hover state (#FF8C5C)
  /// Used for hover states of light amber elements
  MaterialColor get amberLightHover;

  /// Amber light active state (#FF8347)
  /// Used for active/pressed states of light amber elements
  MaterialColor get amberLightActive;

  /// Amber normal color (#FF6B35) - Main brand color
  /// Used for primary buttons, main CTAs, brand elements
  MaterialColor get amberNormal;

  /// Amber normal hover state (#FF5A1F)
  /// Used for hover states of primary amber elements
  MaterialColor get amberNormalHover;

  /// Amber normal active state (#E55A2B)
  /// Used for active/pressed states of primary amber elements
  MaterialColor get amberNormalActive;

  /// Amber dark color (#CC5429)
  /// Used for secondary buttons, icons, borders
  MaterialColor get amberDark;

  /// Amber dark hover state (#B8481F)
  /// Used for hover states of dark amber elements
  MaterialColor get amberDarkHover;

  /// Amber dark active state (#A53D1A)
  /// Used for active/pressed states of dark amber elements
  MaterialColor get amberDarkActive;

  /// Amber darker color (#923315)
  /// Used for strong emphasis, deep shadows, text highlights
  MaterialColor get amberDarker;

  // === BACKWARD COMPATIBILITY ===
  // Legacy amber getters mapped to new system

  /// Amber pale color for backgrounds (#FFF4F0)
  /// Used for background tints, cards, subtle highlights
  MaterialColor get amberPale;

  // === COMPLEMENTARY COLORS ===

  /// Blue complement color for contrast (#357DFF)
  /// Used for links, information states, secondary actions
  MaterialColor get blueComplement;

  /// Teal accent color for success states (#35FFB8)
  /// Used for success messages, positive indicators
  MaterialColor get tealAccent;

  // === NEUTRAL COLORS ===

  /// Charcoal color for primary text (#2D3436)
  /// Used for primary text, headings, labels
  MaterialColor get charcoal;

  /// Warm gray color for secondary text (#8B7355)
  /// Used for secondary text, placeholders, borders
  MaterialColor get warmGray;

  /// Light gray color for backgrounds (#F8F9FA)
  /// Used for page backgrounds, card backgrounds
  MaterialColor get lightGray;

  // === MaterialColor Usage Note ===
  // All MaterialColor getters above can be used directly as Color
  // since MaterialColor extends Color. Use materialColor[shade] for
  // specific shades if needed.

  // === GREY PALETTE (Based on Figma Design System) ===

  /// Grey light color (#E9E9E9)
  /// Used for light backgrounds, subtle highlights, soft accents
  MaterialColor get greyLight;

  /// Grey light hover state (#DEDEDE)
  /// Used for hover states of light grey elements
  MaterialColor get greyLightHover;

  /// Grey light active state (#BBBBBB)
  /// Used for active/pressed states of light grey elements
  MaterialColor get greyLightActive;

  /// Grey normal color (#242424) - Main neutral color
  /// Used for primary text, secondary buttons, neutral elements
  MaterialColor get greyNormal;

  /// Grey normal hover state (#202020)
  /// Used for hover states of primary grey elements
  MaterialColor get greyNormalHover;

  /// Grey normal active state (#1D1D1D)
  /// Used for active/pressed states of primary grey elements
  MaterialColor get greyNormalActive;

  /// Grey dark color (#1B1B1B)
  /// Used for dark text, strong contrast elements
  MaterialColor get greyDark;

  /// Grey dark hover state (#161616)
  /// Used for hover states of dark grey elements
  MaterialColor get greyDarkHover;

  /// Grey dark active state (#101010)
  /// Used for active/pressed states of dark grey elements
  MaterialColor get greyDarkActive;

  /// Grey darker color (#0D0D0D)
  /// Used for strongest contrast, darkest backgrounds
  MaterialColor get greyDarker;

  // === BLUE PALETTE (Complete Design System) ===

  /// Blue light color (#EBF3FF)
  /// Used for light backgrounds, subtle highlights, soft accents
  MaterialColor get blueLight;

  /// Blue light hover state (#D7E7FF)
  /// Used for hover states of light blue elements
  MaterialColor get blueLightHover;

  /// Blue light active state (#AFCFFF)
  /// Used for active/pressed states of light blue elements
  MaterialColor get blueLightActive;

  /// Blue normal color (#357DFF) - Main blue color
  /// Used for links, info states, secondary actions
  MaterialColor get blueNormal;

  /// Blue normal hover state (#2366E6)
  /// Used for hover states of primary blue elements
  MaterialColor get blueNormalHover;

  /// Blue normal active state (#1C57CC)
  /// Used for active/pressed states of primary blue elements
  MaterialColor get blueNormalActive;

  /// Blue dark color (#1548B3)
  /// Used for dark blue elements, strong contrast
  MaterialColor get blueDark;

  /// Blue dark hover state (#0E3999)
  /// Used for hover states of dark blue elements
  MaterialColor get blueDarkHover;

  /// Blue dark active state (#0A2D80)
  /// Used for active/pressed states of dark blue elements
  MaterialColor get blueDarkActive;

  /// Blue darker color (#072166)
  /// Used for strongest blue contrast, darkest blue backgrounds
  MaterialColor get blueDarker;

  // === SLATE PALETTE (Dark Blue System) ===

  /// Slate light color (#E8F0FF)
  /// Used for light backgrounds, subtle highlights, soft accents
  MaterialColor get slateLight;

  /// Slate light hover state (#D1E2FF)
  /// Used for hover states of light slate elements
  MaterialColor get slateLightHover;

  /// Slate light active state (#A3C7FF)
  /// Used for active/pressed states of light slate elements
  MaterialColor get slateLightActive;

  /// Slate normal color (#1E3A8A) - Main slate color
  /// Used for dark themes, professional UI elements
  MaterialColor get slateNormal;

  /// Slate normal hover state (#1B3474)
  /// Used for hover states of primary slate elements
  MaterialColor get slateNormalHover;

  /// Slate normal active state (#182E5E)
  /// Used for active/pressed states of primary slate elements
  MaterialColor get slateNormalActive;

  /// Slate dark color (#152848)
  /// Used for dark slate elements, strong contrast
  MaterialColor get slateDark;

  /// Slate dark hover state (#122233)
  /// Used for hover states of dark slate elements
  MaterialColor get slateDarkHover;

  /// Slate dark active state (#0F1C2E)
  /// Used for active/pressed states of dark slate elements
  MaterialColor get slateDarkActive;

  /// Slate darker color (#0C1629)
  /// Used for strongest slate contrast, darkest slate backgrounds
  MaterialColor get slateDarker;

  // === GREEN PALETTE (Complete Design System) ===

  /// Green light color (#ECFDF5)
  /// Used for light backgrounds, subtle highlights, soft accents
  MaterialColor get greenLight;

  /// Green light hover state (#D1FAE5)
  /// Used for hover states of light green elements
  MaterialColor get greenLightHover;

  /// Green light active state (#A7F3D0)
  /// Used for active/pressed states of light green elements
  MaterialColor get greenLightActive;

  /// Green normal color (#10B981) - Main green color
  /// Used for success states, positive indicators
  MaterialColor get greenNormal;

  /// Green normal hover state (#059669)
  /// Used for hover states of primary green elements
  MaterialColor get greenNormalHover;

  /// Green normal active state (#047857)
  /// Used for active/pressed states of primary green elements
  MaterialColor get greenNormalActive;

  /// Green dark color (#065F46)
  /// Used for dark green elements, strong contrast
  MaterialColor get greenDark;

  /// Green dark hover state (#064E3B)
  /// Used for hover states of dark green elements
  MaterialColor get greenDarkHover;

  /// Green dark active state (#022C22)
  /// Used for active/pressed states of dark green elements
  MaterialColor get greenDarkActive;

  /// Green darker color (#012A20)
  /// Used for strongest green contrast, darkest green backgrounds
  MaterialColor get greenDarker;

  // === PINK PALETTE (Complete Design System) ===

  /// Pink light color (#FDF2F8)
  /// Used for light backgrounds, subtle highlights, soft accents
  MaterialColor get pinkLight;

  /// Pink light hover state (#FCE7F3)
  /// Used for hover states of light pink elements
  MaterialColor get pinkLightHover;

  /// Pink light active state (#F9A8D4)
  /// Used for active/pressed states of light pink elements
  MaterialColor get pinkLightActive;

  /// Pink normal color (#EC4899) - Main pink color
  /// Used for accent elements, feminine design, highlights
  MaterialColor get pinkNormal;

  /// Pink normal hover state (#DB2777)
  /// Used for hover states of primary pink elements
  MaterialColor get pinkNormalHover;

  /// Pink normal active state (#BE185D)
  /// Used for active/pressed states of primary pink elements
  MaterialColor get pinkNormalActive;

  /// Pink dark color (#9D174D)
  /// Used for dark pink elements, strong contrast
  MaterialColor get pinkDark;

  /// Pink dark hover state (#831843)
  /// Used for hover states of dark pink elements
  MaterialColor get pinkDarkHover;

  /// Pink dark active state (#701A43)
  /// Used for active/pressed states of dark pink elements
  MaterialColor get pinkDarkActive;

  /// Pink darker color (#4C1D2E)
  /// Used for strongest pink contrast, darkest pink backgrounds
  MaterialColor get pinkDarker;

  // === ORANGE PALETTE (Complete Design System) ===

  /// Orange light color (#FFF5E6)
  /// Used for light backgrounds, subtle highlights, soft accents
  MaterialColor get orangeLight;

  /// Orange light hover state (#FFEDCC)
  /// Used for hover states of light orange elements
  MaterialColor get orangeLightHover;

  /// Orange light active state (#FFE0B3)
  /// Used for active/pressed states of light orange elements
  MaterialColor get orangeLightActive;

  /// Orange normal color (#FF7F00) - Main orange color
  /// Used for accent elements, highlights, call-to-action buttons
  MaterialColor get orangeNormal;

  /// Orange normal hover state (#E67300)
  /// Used for hover states of primary orange elements
  MaterialColor get orangeNormalHover;

  /// Orange normal active state (#CC6600)
  /// Used for active/pressed states of primary orange elements
  MaterialColor get orangeNormalActive;

  /// Orange dark color (#B35900)
  /// Used for dark orange elements, strong contrast
  MaterialColor get orangeDark;

  /// Orange dark hover state (#994D00)
  /// Used for hover states of dark orange elements
  MaterialColor get orangeDarkHover;

  /// Orange dark active state (#804000)
  /// Used for active/pressed states of dark orange elements
  MaterialColor get orangeDarkActive;

  /// Orange darker color (#663300)
  /// Used for strongest orange contrast, darkest orange backgrounds
  MaterialColor get orangeDarker;

  // === RED PALETTE (Complete Design System) ===

  /// Red light color (#FEF2F2)
  /// Used for light backgrounds, subtle highlights, soft accents
  MaterialColor get redLight;

  /// Red light hover state (#FCE7E7)
  /// Used for hover states of light red elements
  MaterialColor get redLightHover;

  /// Red light active state (#F8D7DA)
  /// Used for active/pressed states of light red elements
  MaterialColor get redLightActive;

  /// Red normal color (#DC3545) - Main red color
  /// Used for error states, danger alerts, critical actions
  MaterialColor get redNormal;

  /// Red normal hover state (#C82333)
  /// Used for hover states of primary red elements
  MaterialColor get redNormalHover;

  /// Red normal active state (#B21E2F)
  /// Used for active/pressed states of primary red elements
  MaterialColor get redNormalActive;

  /// Red dark color (#9C1A2B)
  /// Used for dark red elements, strong contrast
  MaterialColor get redDark;

  /// Red dark hover state (#861727)
  /// Used for hover states of dark red elements
  MaterialColor get redDarkHover;

  /// Red dark active state (#701323)
  /// Used for active/pressed states of dark red elements
  MaterialColor get redDarkActive;

  /// Red darker color (#5A0F1F)
  /// Used for strongest red contrast, darkest red backgrounds
  MaterialColor get redDarker;
}
