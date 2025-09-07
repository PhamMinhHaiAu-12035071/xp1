import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:xp1/core/styles/app_text_styles.dart';

@UseCase(name: 'Typography', type: Typography)
Widget typographyUseCase(BuildContext context) {
  return const Material(
    color: Colors.white,
    child: Typography(),
  );
}

class Typography extends StatelessWidget {
  const Typography({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyles = GetIt.I<AppTextStyles>();
    const sampleText = 'The quick brown fox jumps over the lazy dog';

    return ColoredBox(
      color: const Color(0xFFF8F9FA),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDesignSystemHeader(textStyles),
            const SizedBox(height: 48),
            // Typography showcase
            _buildTypographyShowcase(
              label: 'Display Large',
              size: '36px / 2.25rem',
              textStyle: textStyles.displayLarge(color: Colors.black87),
              sampleText: sampleText,
              usage: 'Hero text, main page titles, prominent CTAs',
            ),
            const SizedBox(height: 24),
            _buildTypographyShowcase(
              label: 'Display Medium',
              size: '32px / 2.0rem',
              textStyle: textStyles.displayMedium(color: Colors.black87),
              sampleText: sampleText,
              usage: 'Section headings, important announcements',
            ),
            const SizedBox(height: 24),
            _buildTypographyShowcase(
              label: 'Heading Large',
              size: '24px / 1.5rem',
              textStyle: textStyles.headingLarge(color: Colors.black87),
              sampleText: sampleText,
              usage: 'Page titles, major section headers',
            ),
            const SizedBox(height: 24),
            _buildTypographyShowcase(
              label: 'Heading Medium',
              size: '20px / 1.25rem',
              textStyle: textStyles.headingMedium(color: Colors.black87),
              sampleText: sampleText,
              usage: 'Subsection headings, card titles',
            ),
            const SizedBox(height: 24),
            _buildTypographyShowcase(
              label: 'Body Large',
              size: '16px / 1.0rem',
              textStyle: textStyles.bodyLarge(color: Colors.black87),
              sampleText: sampleText,
              usage: 'Primary body text, paragraphs, main content',
            ),
            const SizedBox(height: 24),
            _buildTypographyShowcase(
              label: 'Body Medium',
              size: '14px / 0.875rem',
              textStyle: textStyles.bodyMedium(color: Colors.black87),
              sampleText: sampleText,
              usage: 'Secondary text, descriptions, supporting content',
            ),
            const SizedBox(height: 24),
            _buildTypographyShowcase(
              label: 'Body Small',
              size: '12px / 0.75rem',
              textStyle: textStyles.bodySmall(color: Colors.black87),
              sampleText: sampleText,
              usage: 'Small text, metadata, less important information',
            ),
            const SizedBox(height: 24),
            _buildTypographyShowcase(
              label: 'Caption',
              size: '10px / 0.625rem',
              textStyle: textStyles.caption(color: Colors.black87),
              sampleText: sampleText,
              usage: 'Fine print, legal text, minimal labels',
            ),
            const SizedBox(height: 32),
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
            'XP1 Typography System',
            style: textStyles.displayLarge(color: const Color(0xFF2D3436)),
          ),
          const SizedBox(height: 16),
          Text(
            'A comprehensive typography scale built for the XP1 application, '
            'featuring Public Sans with modular scale ratios. Optimized for '
            'readability and responsive design across all platforms.',
            style: textStyles.bodyLarge(color: const Color(0xFF8B7355)),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildMetricCard('8', 'Type Scales', textStyles),
              const SizedBox(width: 24),
              _buildMetricCard('1.25x', 'Scale Ratio', textStyles),
              const SizedBox(width: 24),
              _buildMetricCard('16px', 'Base Size', textStyles),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: kIsWeb ? const Color(0xFFEBF3FF) : const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon cannot be const due to conditional icon parameter
                // ignore: prefer_const_constructors
                Icon(
                  kIsWeb ? Icons.web : Icons.phone_android,
                  size: 16,
                  color: kIsWeb
                      ? const Color(0xFF357DFF)
                      : const Color(0xFF10B981),
                ),
                const SizedBox(width: 8),
                Text(
                  kIsWeb
                      ? 'Web: Exact Pixel Sizes'
                      : 'Mobile: Responsive Scaling',
                  style: textStyles.bodySmall(
                    color: kIsWeb
                        ? const Color(0xFF357DFF)
                        : const Color(0xFF10B981),
                  ),
                ),
              ],
            ),
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
              color: Color(0xFF4CAF50),
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

  Widget _buildTypographyShowcase({
    required String label,
    required String size,
    required TextStyle textStyle,
    required String sampleText,
    required String usage,
  }) {
    final textStylesHelper = GetIt.I<AppTextStyles>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Typography metadata
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: textStylesHelper.bodyLarge(
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      size,
                      style: textStylesHelper.bodySmall(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: kIsWeb ? Colors.blue.shade50 : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  kIsWeb
                      ? '${textStyle.fontSize?.toStringAsFixed(0)}px (exact)'
                      : '${textStyle.fontSize?.toStringAsFixed(1)}px (scaled)',
                  style: textStylesHelper.caption(
                    color: kIsWeb
                        ? Colors.blue.shade700
                        : Colors.green.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Sample text showcase
          Text(
            sampleText,
            style: textStyle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          // Usage description
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 14,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    usage,
                    style: textStylesHelper.bodySmall(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
