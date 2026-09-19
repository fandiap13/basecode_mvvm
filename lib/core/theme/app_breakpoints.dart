import 'package:flutter/widgets.dart';

enum AppScreenSize { compact, medium, expanded, large }

extension AppScreenSizeX on AppScreenSize {
  bool get isCompact => this == AppScreenSize.compact;
  bool get isMedium => this == AppScreenSize.medium;
  bool get isExpanded => this == AppScreenSize.expanded;
  bool get isLarge => this == AppScreenSize.large;

  /// Jumlah kolom grid yang lazim untuk tiap ukuran.
  int get columns => switch (this) {
    AppScreenSize.compact => 4,
    AppScreenSize.medium => 8,
    AppScreenSize.expanded => 12,
    AppScreenSize.large => 12,
  };
}

/// Lebar layar tempat tata letak berganti.
abstract final class AppBreakpoints {
  static const double mobile = 600;
  static const double tablet = 905;
  static const double desktop = 1240;

  static AppScreenSize of(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < mobile) return AppScreenSize.compact;
    if (width < tablet) return AppScreenSize.medium;
    if (width < desktop) return AppScreenSize.expanded;

    return AppScreenSize.large;
  }
}
