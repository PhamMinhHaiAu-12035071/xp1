import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:injectable/injectable.dart';
import 'package:xp1/core/sizes/app_sizes.dart';

/// Implementation of application sizes
/// that can be injected and mocked for testing
@LazySingleton(as: AppSizes)
class AppSizesImpl implements AppSizes {
  /// Creates an instance of AppSizesImpl
  const AppSizesImpl();

  // 2 pixel variations
  @override
  double get r2 => 2.r;
  @override
  double get v2 => 2.h;
  @override
  double get h2 => 2.w;

  // 4 pixel variations
  @override
  double get r4 => 4.r;
  @override
  double get v4 => 4.h;
  @override
  double get h4 => 4.w;

  // 5 pixel variations
  @override
  double get r5 => 5.r;
  @override
  double get v5 => 5.h;
  @override
  double get h5 => 5.w;

  // 6 pixel variations
  @override
  double get r6 => 6.r;
  @override
  double get v6 => 6.h;
  @override
  double get h6 => 6.w;

  // 8 pixel variations
  @override
  double get r8 => 8.r;
  @override
  double get v8 => 8.h;
  @override
  double get h8 => 8.w;

  // 10 pixel variations
  @override
  double get r10 => 10.r;
  @override
  double get v10 => 10.h;
  @override
  double get h10 => 10.w;

  // 12 pixel variations
  @override
  double get r12 => 12.r;
  @override
  double get v12 => 12.h;
  @override
  double get h12 => 12.w;

  // 14 pixel variations
  @override
  double get r14 => 14.r;
  @override
  double get v14 => 14.h;
  @override
  double get h14 => 14.w;

  // 16 pixel variations
  @override
  double get r16 => 16.r;
  @override
  double get v16 => 16.h;
  @override
  double get h16 => 16.w;

  // 20 pixel variations
  @override
  double get r20 => 20.r;
  @override
  double get v20 => 20.h;
  @override
  double get h20 => 20.w;

  // 22 pixel variations
  @override
  double get r22 => 22.r;
  @override
  double get v22 => 22.h;
  @override
  double get h22 => 22.w;

  // 23 pixel variations
  @override
  double get r23 => 23.r;
  @override
  double get v23 => 23.h;
  @override
  double get h23 => 23.w;

  // 24 pixel variations
  @override
  double get r24 => 24.r;
  @override
  double get v24 => 24.h;
  @override
  double get h24 => 24.w;

  // 32 pixel variations
  @override
  double get r32 => 32.r;
  @override
  double get v32 => 32.h;
  @override
  double get h32 => 32.w;

  // 40 pixel variations
  @override
  double get r40 => 40.r;
  @override
  double get v40 => 40.h;
  @override
  double get h40 => 40.w;

  // 42 pixel variations
  @override
  double get r42 => 42.r;
  @override
  double get v42 => 42.h;
  @override
  double get h42 => 42.w;

  // 48 pixel variations
  @override
  double get r48 => 48.r;
  @override
  double get v48 => 48.h;
  @override
  double get h48 => 48.w;

  // 54 pixel variations
  @override
  double get r54 => 54.r;
  @override
  double get v54 => 54.h;
  @override
  double get h54 => 54.w;

  // 56 pixel variations
  @override
  double get r56 => 56.r;
  @override
  double get v56 => 56.h;
  @override
  double get h56 => 56.w;

  // 58 pixel variations
  @override
  double get r58 => 58.r;
  @override
  double get v58 => 58.h;
  @override
  double get h58 => 58.w;

  // 60 pixel variations
  @override
  double get r60 => 60.r;
  @override
  double get v60 => 60.h;
  @override
  double get h60 => 60.w;

  // 64 pixel variations
  @override
  double get r64 => 64.r;
  @override
  double get v64 => 64.h;
  @override
  double get h64 => 64.w;

  // 72 pixel variations
  @override
  double get r72 => 72.r;
  @override
  double get v72 => 72.h;
  @override
  double get h72 => 72.w;

  // 78 pixel variations
  @override
  double get r78 => 78.r;
  @override
  double get v78 => 78.h;
  @override
  double get h78 => 78.w;

  // 80 pixel variations
  @override
  double get r80 => 80.r;
  @override
  double get v80 => 80.h;
  @override
  double get h80 => 80.w;

  // 90 pixel variations
  @override
  double get r90 => 90.r;
  @override
  double get v90 => 90.h;
  @override
  double get h90 => 90.w;

  // 120 pixel variations
  @override
  double get r120 => 120.r;
  @override
  double get v120 => 120.h;
  @override
  double get h120 => 120.w;

  // 128 pixel variations
  @override
  double get r128 => 128.r;
  @override
  double get v128 => 128.h;
  @override
  double get h128 => 128.w;

  // 130 pixel variations
  @override
  double get r130 => 130.r;
  @override
  double get v130 => 130.h;
  @override
  double get h130 => 130.w;

  // 156 pixel variations
  @override
  double get r156 => 156.r;
  @override
  double get v156 => 156.h;
  @override
  double get h156 => 156.w;

  // 160 pixel variations
  @override
  double get r160 => 160.r;
  @override
  double get v160 => 160.h;
  @override
  double get h160 => 160.w;

  // 192 pixel variations
  @override
  double get r192 => 192.r;
  @override
  double get v192 => 192.h;
  @override
  double get h192 => 192.w;

  // 224 pixel variations

  @override
  double get r224 => 224.r;
  @override
  double get v224 => 224.h;
  @override
  double get h224 => 224.w;

  // 256 pixel variations
  @override
  double get r256 => 256.r;
  @override
  double get v256 => 256.h;
  @override
  double get h256 => 256.w;

  // 260 pixel variations (specific for onboarding image size)
  @override
  double get r260 => 260.r;
  @override
  double get v260 => 260.h;
  @override
  double get h260 => 260.w;

  // 360 pixel variations
  @override
  double get r360 => 360.r;
  @override
  double get v360 => 360.h;
  @override
  double get h360 => 360.w;

  // 372 pixel variations

  @override
  double get r372 => 372.r;
  @override
  double get v372 => 372.h;
  @override
  double get h372 => 372.w;

  // 500 pixel variations
  @override
  double get r500 => 500.r;
  @override
  double get v500 => 500.h;
  @override
  double get h500 => 500.w;

  // 570 pixel variations
  @override
  double get r570 => 570.r;
  @override
  double get v570 => 570.h;
  @override
  double get h570 => 570.w;

  // 680 pixel variations
  @override
  double get r680 => 680.r;
  @override
  double get v680 => 680.h;
  @override
  double get h680 => 680.w;

  // Border radius dimensions
  @override
  double get borderRadiusXs => 6.r;
  @override
  double get borderRadiusSm => 8.r;
  @override
  double get borderRadiusMd => 12.r;
  @override
  double get borderRadiusLg => 16.r;
}
