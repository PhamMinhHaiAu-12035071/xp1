import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:xp1/core/styles/app_text_styles.dart';
import 'package:xp1/core/styles/colors/app_colors.dart';

/// Complete color system showcase
@UseCase(name: 'Colors', type: Colors)
Widget colorsUseCase(BuildContext context) {
  return const Material(
    color: Color(0xFFFFFFFF), // Material Colors.white
    child: Colors(),
  );
}

/// Complete color system showcase
class Colors extends StatelessWidget {
  /// Creates a color system showcase widget
  const Colors({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = GetIt.I<AppColors>();
    final textStyles = GetIt.I<AppTextStyles>();

    return ColoredBox(
      color: const Color(0xFFF8F9FA),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDesignSystemHeader(textStyles),
            const SizedBox(height: 48),
            _buildPrimaryColorSection(colors, textStyles),
            const SizedBox(height: 48),
            _buildComplementaryColorSection(colors, textStyles),
            const SizedBox(height: 48),
            _buildGrayPaletteSection(colors, textStyles),
            const SizedBox(height: 48),
            _buildBluePaletteSection(colors, textStyles),
            const SizedBox(height: 48),
            _buildSlatePaletteSection(colors, textStyles),
            const SizedBox(height: 48),
            _buildGreenPaletteSection(colors, textStyles),
            const SizedBox(height: 48),
            _buildPinkPaletteSection(colors, textStyles),
            const SizedBox(height: 48),
            _buildOrangePaletteSection(colors, textStyles),
            const SizedBox(height: 48),
            _buildRedPaletteSection(colors, textStyles),
          ],
        ),
      ),
    );
  }

  Widget _buildDesignSystemHeader(AppTextStyles textStyles) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF6B35).withValues(alpha: 0.05),
            const Color(0xFF357DFF).withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFFF6B35).withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'DESIGN SYSTEM',
                  style: textStyles.bodySmall(color: const Color(0xFFFFFFFF)),
                ),
              ),
              const Spacer(),
              _buildStatusBadge('v2.0', 'Current', textStyles),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'XP1 Design System Colors',
            style: textStyles.displayLarge(color: const Color(0xFF2D3436)),
          ),
          const SizedBox(height: 16),
          Text(
            'A comprehensive color palette built for the XP1 application, '
            'featuring primary amber tones with complementary color families. '
            'All colors are designed for accessibility and brand consistency.',
            style: textStyles.bodyLarge(color: const Color(0xFF8B7355)),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildMetricCard('80+', 'Color Variants', textStyles),
              const SizedBox(width: 24),
              _buildMetricCard('AA+', 'Accessibility', textStyles),
              const SizedBox(width: 24),
              _buildMetricCard('8', 'Color Families', textStyles),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(
    String version,
    String status,
    AppTextStyles textStyles,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF4CAF50), // Material green
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$version • $status',
            style: textStyles.caption(color: const Color(0xFF2D3436)),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    String value,
    String label,
    AppTextStyles textStyles,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: textStyles.headingMedium(color: const Color(0xFF2D3436)),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: textStyles.caption(color: const Color(0xFF8B7355)),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryColorSection(
    AppColors colors,
    AppTextStyles textStyles,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE5E5E5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              const Row(
                children: [
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Amber',
                      style: TextStyle(
                        color: Color(0xFF2D3436),
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SF Pro Display',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Color swatches
              Column(
                children: [
                  _buildFigmaColorSwatch(
                    'Light',
                    colors.amberLightColor,
                    '#fff6e9',
                    'rgb(255, 246, 233)',
                    '19.61 AAA AAA',
                    '1.07',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Light :hover',
                    colors.amberLightHoverColor,
                    '#fff2dd',
                    'rgb(255, 242, 221)',
                    '19.00 AAA AAA',
                    '1.11',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Light :active',
                    colors.amberLightActiveColor,
                    '#fee4ba',
                    'rgb(254, 228, 186)',
                    '17.02 AAA AAA',
                    '1.23',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Normal',
                    colors.amberNormalColor,
                    '#fca91f',
                    'rgb(252, 169, 31)',
                    '10.83 AAA AAA',
                    '1.94',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Normal :hover',
                    colors.amberNormalHoverColor,
                    '#e3981c',
                    'rgb(227, 152, 28)',
                    '8.77 AAA AAA',
                    '2.39',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Normal :active',
                    colors.amberNormalActiveColor,
                    '#ca8719',
                    'rgb(202, 135, 25)',
                    '6.99 AAA AA',
                    '3.00',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Dark',
                    colors.amberDarkColor,
                    '#bd7f17',
                    'rgb(189, 127, 23)',
                    '6.21 AAA AA',
                    '3.38 AA',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Dark :hover',
                    colors.amberDarkHoverColor,
                    '#976513',
                    'rgb(151, 101, 19)',
                    '4.19 AA',
                    '5.02 AAA AA',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Dark :active',
                    colors.amberDarkActiveColor,
                    '#714c0e',
                    'rgb(113, 76, 14)',
                    '2.74',
                    '7.66 AAA AAA',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Darker',
                    colors.amberDarkerColor,
                    '#583b0b',
                    'rgb(88, 59, 11)',
                    '2.05',
                    '10.27 AAA AAA',
                    textStyles,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildComplementaryColorSection(
    AppColors colors,
    AppTextStyles textStyles,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '🌈 Complementary Colors',
          style: textStyles.headingLarge(color: const Color(0xFF2D3436)),
        ),
        const SizedBox(height: 8),
        Text(
          'Supporting colors that work harmoniously with orange',
          style: textStyles.bodyMedium(color: const Color(0xFF8B7355)),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _buildProfessionalColorCard(
                'Blue Complement',
                colors.blueComplementColor,
                '#357DFF',
                'Links, info states, secondary actions',
                textStyles,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildProfessionalColorCard(
                'Teal Accent',
                colors.tealAccentColor,
                '#35FFB8',
                'Success states, positive feedback',
                textStyles,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGrayPaletteSection(
    AppColors colors,
    AppTextStyles textStyles,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE5E5E5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              const Row(
                children: [
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Grey',
                      style: TextStyle(
                        color: Color(0xFF2D3436),
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SF Pro Display',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Color swatches
              Column(
                children: [
                  _buildFigmaColorSwatch(
                    'Light',
                    colors.greyLightColor,
                    '#e9e9e9',
                    'rgb(233, 233, 233)',
                    '18.54 AAA AAA',
                    '1.15',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Light :hover',
                    colors.greyLightHoverColor,
                    '#dedede',
                    'rgb(222, 222, 222)',
                    '17.89 AAA AAA',
                    '1.18',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Light :active',
                    colors.greyLightActiveColor,
                    '#bbbbbb',
                    'rgb(187, 187, 187)',
                    '14.12 AAA AAA',
                    '1.49',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Normal',
                    colors.greyNormalColor,
                    '#242424',
                    'rgb(36, 36, 36)',
                    '1.96',
                    '10.71 AAA AAA',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Normal :hover',
                    colors.greyNormalHoverColor,
                    '#202020',
                    'rgb(32, 32, 32)',
                    '1.61',
                    '13.01 AAA AAA',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Normal :active',
                    colors.greyNormalActiveColor,
                    '#1d1d1d',
                    'rgb(29, 29, 29)',
                    '1.42',
                    '14.79 AAA AAA',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Dark',
                    colors.greyDarkColor,
                    '#1b1b1b',
                    'rgb(27, 27, 27)',
                    '1.31',
                    '16.05 AAA AAA',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Dark :hover',
                    colors.greyDarkHoverColor,
                    '#161616',
                    'rgb(22, 22, 22)',
                    '1.14',
                    '18.39 AAA AAA',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Dark :active',
                    colors.greyDarkActiveColor,
                    '#101010',
                    'rgb(16, 16, 16)',
                    '0.95',
                    '22.09 AAA AAA',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Darker',
                    colors.greyDarkerColor,
                    '#0d0d0d',
                    'rgb(13, 13, 13)',
                    '0.85',
                    '24.71 AAA AAA',
                    textStyles,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBluePaletteSection(
    AppColors colors,
    AppTextStyles textStyles,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE5E5E5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              const Row(
                children: [
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Blue',
                      style: TextStyle(
                        color: Color(0xFF2D3436),
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SF Pro Display',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Color swatches
              Column(
                children: [
                  _buildFigmaColorSwatch(
                    'Light',
                    colors.blueComplement[50] ?? const Color(0xFFEBF3FF),
                    '#ebf3ff',
                    'rgb(235, 243, 255)',
                    '19.45 AAA AAA',
                    '1.08',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Light :hover',
                    colors.blueComplement[100] ?? const Color(0xFFD7E7FF),
                    '#d7e7ff',
                    'rgb(215, 231, 255)',
                    '18.21 AAA AAA',
                    '1.15',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Light :active',
                    colors.blueComplement[200] ?? const Color(0xFFAFCFFF),
                    '#afcfff',
                    'rgb(175, 207, 255)',
                    '15.82 AAA AAA',
                    '1.33',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Normal',
                    colors.blueComplementColor,
                    '#357dff',
                    'rgb(53, 125, 255)',
                    '5.89 AAA AA',
                    '3.56',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Normal :hover',
                    colors.blueComplement[600] ?? const Color(0xFF2366E6),
                    '#2366e6',
                    'rgb(35, 102, 230)',
                    '4.85 AA',
                    '4.33',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Normal :active',
                    colors.blueComplement[700] ?? const Color(0xFF1C57CC),
                    '#1c57cc',
                    'rgb(28, 87, 204)',
                    '3.91 AA',
                    '5.37',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Dark',
                    colors.blueComplement[800] ?? const Color(0xFF1548B3),
                    '#1548b3',
                    'rgb(21, 72, 179)',
                    '3.12',
                    '6.73 AAA AA',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Dark :hover',
                    colors.blueComplement[900] ?? const Color(0xFF0E3999),
                    '#0e3999',
                    'rgb(14, 57, 153)',
                    '2.45',
                    '8.57 AAA AAA',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Dark :active',
                    const Color(0xFF0A2D80),
                    '#0a2d80',
                    'rgb(10, 45, 128)',
                    '1.95',
                    '10.77 AAA AAA',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Darker',
                    const Color(0xFF072166),
                    '#072166',
                    'rgb(7, 33, 102)',
                    '1.49',
                    '14.08 AAA AAA',
                    textStyles,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSlatePaletteSection(
    AppColors colors,
    AppTextStyles textStyles,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE5E5E5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              const Row(
                children: [
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Slate',
                      style: TextStyle(
                        color: Color(0xFF2D3436),
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SF Pro Display',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Color swatches
              Column(
                children: [
                  _buildFigmaColorSwatch(
                    'Light',
                    const Color(0xFFE8F0FF),
                    '#e8f0ff',
                    'rgb(232, 240, 255)',
                    '19.12 AAA AAA',
                    '1.10',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Light :hover',
                    const Color(0xFFD1E2FF),
                    '#d1e2ff',
                    'rgb(209, 226, 255)',
                    '17.89 AAA AAA',
                    '1.18',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Light :active',
                    const Color(0xFFA3C7FF),
                    '#a3c7ff',
                    'rgb(163, 199, 255)',
                    '15.21 AAA AAA',
                    '1.38',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Normal',
                    const Color(0xFF1E3A8A),
                    '#1e3a8a',
                    'rgb(30, 58, 138)',
                    '2.89',
                    '7.27 AAA AAA',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Normal :hover',
                    const Color(0xFF1B3474),
                    '#1b3474',
                    'rgb(27, 52, 116)',
                    '2.41',
                    '8.71 AAA AAA',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Normal :active',
                    const Color(0xFF182E5E),
                    '#182e5e',
                    'rgb(24, 46, 94)',
                    '1.97',
                    '10.66 AAA AAA',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Dark',
                    const Color(0xFF152848),
                    '#152848',
                    'rgb(21, 40, 72)',
                    '1.59',
                    '13.19 AAA AAA',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Dark :hover',
                    const Color(0xFF122233),
                    '#122233',
                    'rgb(18, 34, 51)',
                    '1.25',
                    '16.81 AAA AAA',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Dark :active',
                    const Color(0xFF0F1C2E),
                    '#0f1c2e',
                    'rgb(15, 28, 46)',
                    '1.01',
                    '20.79 AAA AAA',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Darker',
                    const Color(0xFF0C1629),
                    '#0c1629',
                    'rgb(12, 22, 41)',
                    '0.82',
                    '25.61 AAA AAA',
                    textStyles,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGreenPaletteSection(
    AppColors colors,
    AppTextStyles textStyles,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE5E5E5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              const Row(
                children: [
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Green',
                      style: TextStyle(
                        color: Color(0xFF2D3436),
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SF Pro Display',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Color swatches
              Column(
                children: [
                  _buildFigmaColorSwatch(
                    'Light',
                    const Color(0xFFECFDF5),
                    '#ecfdf5',
                    'rgb(236, 253, 245)',
                    '19.78 AAA AAA',
                    '1.06',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Light :hover',
                    const Color(0xFFD1FAE5),
                    '#d1fae5',
                    'rgb(209, 250, 229)',
                    '18.92 AAA AAA',
                    '1.11',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Light :active',
                    const Color(0xFFA7F3D0),
                    '#a7f3d0',
                    'rgb(167, 243, 208)',
                    '17.21 AAA AAA',
                    '1.22',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Normal',
                    colors.tealAccentColor,
                    '#10b981',
                    'rgb(16, 185, 129)',
                    '7.93 AAA AAA',
                    '2.65',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Normal :hover',
                    const Color(0xFF059669),
                    '#059669',
                    'rgb(5, 150, 105)',
                    '5.98 AAA AA',
                    '3.51',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Normal :active',
                    const Color(0xFF047857),
                    '#047857',
                    'rgb(4, 120, 87)',
                    '4.44 AA',
                    '4.73',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Dark',
                    const Color(0xFF065F46),
                    '#065f46',
                    'rgb(6, 95, 70)',
                    '3.21',
                    '6.54 AAA AA',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Dark :hover',
                    const Color(0xFF064E3B),
                    '#064e3b',
                    'rgb(6, 78, 59)',
                    '2.48',
                    '8.47 AAA AAA',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Dark :active',
                    const Color(0xFF022C22),
                    '#022c22',
                    'rgb(2, 44, 34)',
                    '1.45',
                    '14.48 AAA AAA',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Darker',
                    const Color(0xFF012A20),
                    '#012a20',
                    'rgb(1, 42, 32)',
                    '1.28',
                    '16.41 AAA AAA',
                    textStyles,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPinkPaletteSection(
    AppColors colors,
    AppTextStyles textStyles,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE5E5E5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              const Row(
                children: [
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Pink',
                      style: TextStyle(
                        color: Color(0xFF2D3436),
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SF Pro Display',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Color swatches
              Column(
                children: [
                  _buildFigmaColorSwatch(
                    'Light',
                    colors.pinkLightColor,
                    '#fdf2f8',
                    'rgb(253, 242, 248)',
                    '19.65 AAA AAA',
                    '1.07',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Light :hover',
                    colors.pinkLightHoverColor,
                    '#fce7f3',
                    'rgb(252, 231, 243)',
                    '18.98 AAA AAA',
                    '1.11',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Light :active',
                    colors.pinkLightActiveColor,
                    '#f9a8d4',
                    'rgb(249, 168, 212)',
                    '15.42 AAA AAA',
                    '1.36',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Normal',
                    colors.pinkNormalColor,
                    '#ec4899',
                    'rgb(236, 72, 153)',
                    '6.85 AAA AA',
                    '3.07',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Normal :hover',
                    colors.pinkNormalHoverColor,
                    '#db2777',
                    'rgb(219, 39, 119)',
                    '5.12 AAA AA',
                    '4.10',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Normal :active',
                    colors.pinkNormalActiveColor,
                    '#be185d',
                    'rgb(190, 24, 93)',
                    '3.89 AA',
                    '5.39',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Dark',
                    colors.pinkDarkColor,
                    '#9d174d',
                    'rgb(157, 23, 77)',
                    '2.94',
                    '7.14 AAA AAA',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Dark :hover',
                    colors.pinkDarkHoverColor,
                    '#831843',
                    'rgb(131, 24, 67)',
                    '2.31',
                    '9.08 AAA AAA',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Dark :active',
                    colors.pinkDarkActiveColor,
                    '#701a43',
                    'rgb(112, 26, 67)',
                    '1.88',
                    '11.17 AAA AAA',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Darker',
                    colors.pinkDarkerColor,
                    '#4c1d2e',
                    'rgb(76, 29, 46)',
                    '1.51',
                    '13.93 AAA AAA',
                    textStyles,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrangePaletteSection(
    AppColors colors,
    AppTextStyles textStyles,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE5E5E5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              const Row(
                children: [
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Orange',
                      style: TextStyle(
                        color: Color(0xFF2D3436),
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SF Pro Display',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Color swatches
              Column(
                children: [
                  _buildFigmaColorSwatch(
                    'Light',
                    colors.orangeLightColor,
                    '#fff5e6',
                    'rgb(255, 245, 230)',
                    '19.45 AAA AAA',
                    '1.08',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Light :hover',
                    colors.orangeLightHoverColor,
                    '#ffedcc',
                    'rgb(255, 237, 204)',
                    '18.89 AAA AAA',
                    '1.11',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Light :active',
                    colors.orangeLightActiveColor,
                    '#ffe0b3',
                    'rgb(255, 224, 179)',
                    '17.42 AAA AAA',
                    '1.21',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Normal',
                    colors.orangeNormalColor,
                    '#ff7f00',
                    'rgb(255, 127, 0)',
                    '9.85 AAA AAA',
                    '2.13',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Normal :hover',
                    colors.orangeNormalHoverColor,
                    '#e67300',
                    'rgb(230, 115, 0)',
                    '8.21 AAA AAA',
                    '2.56',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Normal :active',
                    colors.orangeNormalActiveColor,
                    '#cc6600',
                    'rgb(204, 102, 0)',
                    '6.78 AAA AA',
                    '3.10',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Dark',
                    colors.orangeDarkColor,
                    '#b35900',
                    'rgb(179, 89, 0)',
                    '5.52 AAA AA',
                    '3.81',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Dark :hover',
                    colors.orangeDarkHoverColor,
                    '#994d00',
                    'rgb(153, 77, 0)',
                    '4.42 AA',
                    '4.75',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Dark :active',
                    colors.orangeDarkActiveColor,
                    '#804000',
                    'rgb(128, 64, 0)',
                    '3.45 AA',
                    '6.09',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Darker',
                    colors.orangeDarkerColor,
                    '#663300',
                    'rgb(102, 51, 0)',
                    '2.63',
                    '7.99 AAA AAA',
                    textStyles,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRedPaletteSection(
    AppColors colors,
    AppTextStyles textStyles,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE5E5E5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              const Row(
                children: [
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Red',
                      style: TextStyle(
                        color: Color(0xFF2D3436),
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SF Pro Display',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Color swatches
              Column(
                children: [
                  _buildFigmaColorSwatch(
                    'Light',
                    colors.redLightColor,
                    '#fef2f2',
                    'rgb(254, 242, 242)',
                    '19.52 AAA AAA',
                    '1.08',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Light :hover',
                    colors.redLightHoverColor,
                    '#fce7e7',
                    'rgb(252, 231, 231)',
                    '18.98 AAA AAA',
                    '1.11',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Light :active',
                    colors.redLightActiveColor,
                    '#f8d7da',
                    'rgb(248, 215, 218)',
                    '17.15 AAA AAA',
                    '1.23',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Normal',
                    colors.redNormalColor,
                    '#dc3545',
                    'rgb(220, 53, 69)',
                    '6.12 AAA AA',
                    '3.43',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Normal :hover',
                    colors.redNormalHoverColor,
                    '#c82333',
                    'rgb(200, 35, 51)',
                    '5.23 AAA AA',
                    '4.02',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Normal :active',
                    colors.redNormalActiveColor,
                    '#b21e2f',
                    'rgb(178, 30, 47)',
                    '4.12 AA',
                    '5.09',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Dark',
                    colors.redDarkColor,
                    '#9c1a2b',
                    'rgb(156, 26, 43)',
                    '3.21 AA',
                    '6.54',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Dark :hover',
                    colors.redDarkHoverColor,
                    '#861727',
                    'rgb(134, 23, 39)',
                    '2.54 AA',
                    '8.27',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Dark :active',
                    colors.redDarkActiveColor,
                    '#701323',
                    'rgb(112, 19, 35)',
                    '2.01',
                    '10.44 AAA AAA',
                    textStyles,
                  ),
                  const SizedBox(height: 16),
                  _buildFigmaColorSwatch(
                    'Darker',
                    colors.redDarkerColor,
                    '#5a0f1f',
                    'rgb(90, 15, 31)',
                    '1.56',
                    '13.46 AAA AAA',
                    textStyles,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfessionalColorCard(
    String name,
    Color color,
    String hexCode,
    String usage,
    AppTextStyles textStyles,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF), // Material white
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFFFFFF), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF000000).withValues(alpha: 0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: kIsWeb
                    ? Material(
                        color: const Color(0x00000000), // Material transparent
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => _copyToClipboard(hexCode),
                          child: Center(
                            child: Icon(
                              Icons.content_copy,
                              size: 16,
                              color: color.computeLuminance() > 0.5
                                  ? const Color(0x8A000000) // Material black54
                                  : const Color(0xB3FFFFFF), // Material white70
                            ),
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: textStyles.bodyLarge(
                        color: const Color(0xFF2D3436),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hexCode,
                      style: textStyles.bodySmall(
                        color: const Color(0xFF8B7355),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            usage,
            style: textStyles.bodySmall(color: const Color(0xFF8B7355)),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Determines the optimal text color (black or white) based on background
  /// luminance to ensure maximum readability and WCAG compliance.
  ///
  /// Uses the relative luminance formula and follows WCAG guidelines:
  /// - Light backgrounds (luminance > 0.5) → Black text
  /// - Dark backgrounds (luminance ≤ 0.5) → White text
  ///
  /// [backgroundColor] The background color to analyze
  /// Returns optimal text color for maximum contrast
  Color _getOptimalTextColor(Color backgroundColor) {
    // Calculate relative luminance (0.0 = black, 1.0 = white)
    final luminance = backgroundColor.computeLuminance();

    // Use white text on dark backgrounds, black text on light backgrounds
    // Threshold of 0.5 provides optimal contrast for most cases
    return luminance > 0.5
        ? const Color(0xFF000000) // Black text on light background
        : const Color(0xFFFFFFFF); // White text on dark background
  }

  /// Gets the optimal color for accessibility badges based on background
  /// luminance to ensure they remain visible and meet WCAG contrast ratios.
  ///
  /// For contrast ratio badges (dark badge on light bg, light badge on dark bg)
  /// For luminance badges (light badge with dark text on any background)
  ///
  /// [backgroundColor] The background color to analyze
  /// [isContrastBadge] Whether this is a contrast badge (true) or luminance
  /// badge (false)
  Color _getBadgeColor(Color backgroundColor, {required bool isContrastBadge}) {
    final luminance = backgroundColor.computeLuminance();

    if (isContrastBadge) {
      // Contrast badge: dark on light bg, light on dark bg for visibility
      return luminance > 0.5
          ? const Color(0xFF000000) // Dark badge on light background
          : const Color(0xFFFFFFFF); // Light badge on dark background
    } else {
      // Luminance badge: always white/light background for consistency
      return const Color(0xFFFFFFFF);
    }
  }

  /// Gets the optimal text color for badge content to ensure readability
  /// on the badge background.
  ///
  /// [badgeColor] The background color of the badge
  Color _getBadgeTextColor(Color badgeColor) {
    final luminance = badgeColor.computeLuminance();
    return luminance > 0.5
        ? const Color(0xFF000000) // Black text on light badge
        : const Color(0xFFFFFFFF); // White text on dark badge
  }

  /// Builds a Figma-style color swatch that matches the design system
  /// specifications exactly as shown in the design screenshot.
  ///
  /// This widget creates a color card with:
  /// - Left: Rounded rectangular color swatch
  /// - Right: Color information (name, hex, RGB, accessibility)
  /// - Dynamic text colors for optimal readability on any background
  ///
  /// [name] The display name of the color variant
  /// [color] The actual Color value to display
  /// [hexCode] The hexadecimal color code
  /// [rgbCode] The RGB color representation
  /// [contrastRatio] The accessibility contrast ratio with rating
  /// [luminanceValue] The luminance value for the color
  /// [textStyles] Text styling configuration
  Widget _buildFigmaColorSwatch(
    String name,
    Color color,
    String hexCode,
    String rgbCode,
    String contrastRatio,
    String luminanceValue,
    AppTextStyles textStyles,
  ) {
    // Calculate optimal colors for maximum readability
    final optimalTextColor = _getOptimalTextColor(color);
    final contrastBadgeColor = _getBadgeColor(color, isContrastBadge: true);
    final luminanceBadgeColor = _getBadgeColor(color, isContrastBadge: false);
    final contrastBadgeTextColor = _getBadgeTextColor(contrastBadgeColor);
    final luminanceBadgeTextColor = _getBadgeTextColor(luminanceBadgeColor);

    // Ensure circle indicator is always visible with good contrast
    final circleColor = optimalTextColor == const Color(0xFF000000)
        ? const Color(0xFF000000) // Black circle on light background
        : const Color(0xFFFFFFFF); // White circle on dark background

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          // Color swatch indicator (dynamic circle color for visibility)
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 24),

          // Accessibility information (left side)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: contrastBadgeColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    contrastRatio,
                    style: TextStyle(
                      color: contrastBadgeTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SF Pro Text',
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: luminanceBadgeColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    luminanceValue,
                    style: TextStyle(
                      color: luminanceBadgeTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SF Pro Text',
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 40),

          // Color information (right side)
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: optimalTextColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'SF Pro Display',
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hexCode,
                  style: TextStyle(
                    color: optimalTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'SF Pro Text',
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  rgbCode,
                  style: TextStyle(
                    color: optimalTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'SF Pro Text',
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    // Note: In a real app, you'd show a snackbar or toast here
  }
}
