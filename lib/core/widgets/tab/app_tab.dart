import 'package:basecode/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum AppTabVariant { primary, secondary, danger, warning, info, dark }

enum AppTabSize {
  small(fontSize: 13, horizontalPadding: 12),
  medium(fontSize: 14, horizontalPadding: 16),
  large(fontSize: 16, horizontalPadding: 20);

  const AppTabSize({required this.fontSize, required this.horizontalPadding});

  final double fontSize;
  final double horizontalPadding;
}

class AppTab extends StatelessWidget {
  const AppTab({
    super.key,
    required this.tabs,
    required this.children,
    this.controller,
    this.variant = AppTabVariant.primary,
    this.size = AppTabSize.medium,
    this.isScrollable = false,
    this.padding,
  });

  final List<Tab> tabs;
  final List<Widget> children;

  final TabController? controller;

  final AppTabVariant variant;
  final AppTabSize size;

  final bool isScrollable;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.appColors;

    final tabColor = switch (variant) {
      AppTabVariant.primary => c.primary,
      AppTabVariant.secondary => c.secondary,
      AppTabVariant.danger => c.danger,
      AppTabVariant.warning => c.warning,
      AppTabVariant.info => c.info,
      AppTabVariant.dark => c.ink,
    };

    return DefaultTabController(
      length: tabs.length,
      child: Column(
        children: [
          TabBar(
            controller: controller,
            isScrollable: isScrollable,
            padding: padding,
            labelColor: tabColor,
            unselectedLabelColor: c.inkSoft,
            labelStyle: theme.textTheme.labelMedium?.copyWith(
              fontSize: size.fontSize,
            ),
            indicatorColor: tabColor,
            indicatorWeight: 2,
            tabs: tabs,
          ),
          Expanded(
            child: TabBarView(controller: controller, children: children),
          ),
        ],
      ),
    );
  }
}
