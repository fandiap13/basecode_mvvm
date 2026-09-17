import 'package:basecode/features/showcase/model/showcase_entry.dart';
import 'package:basecode/routing/routes.dart';
import 'package:flutter/material.dart';

// Tambahkan entry di sini setiap ada komponen baru di core/widgets/.
// Set isReady: true setelah screen tujuannya dibuat.
const showcaseEntries = <ShowcaseEntry>[
  ShowcaseEntry(
    title: 'Button',
    subtitle: 'Action & State',
    route: AppRoutes.showcaseButton,
    icon: Icons.smart_button_outlined,
    isReady: true,
  ),
  ShowcaseEntry(
    title: 'Icon Button',
    subtitle: 'Compact Action',
    route: AppRoutes.showcaseIconButton,
    icon: Icons.touch_app_outlined,
  ),
  ShowcaseEntry(
    title: 'Text Field',
    subtitle: 'Input & Validation',
    route: AppRoutes.showcaseTextField,
    icon: Icons.text_fields_outlined,
  ),
  ShowcaseEntry(
    title: 'Form',
    subtitle: 'Layout & Submit',
    route: AppRoutes.showcaseForm,
    icon: Icons.assignment_outlined,
  ),
  ShowcaseEntry(
    title: 'Dropdown',
    subtitle: 'Selection',
    route: AppRoutes.showcaseDropdown,
    icon: Icons.arrow_drop_down_circle_outlined,
  ),
  ShowcaseEntry(
    title: 'Checkbox & Radio',
    subtitle: 'Multiple & Single',
    route: AppRoutes.showcaseCheckboxRadio,
    icon: Icons.check_box_outlined,
  ),
  ShowcaseEntry(
    title: 'Switch',
    subtitle: 'Toggle',
    route: AppRoutes.showcaseSwitch,
    icon: Icons.toggle_on_outlined,
  ),
  ShowcaseEntry(
    title: 'Slider',
    subtitle: 'Range & Value',
    route: AppRoutes.showcaseSlider,
    icon: Icons.tune_outlined,
  ),
  ShowcaseEntry(
    title: 'Card',
    subtitle: 'Container & Surface',
    route: AppRoutes.showcaseCard,
    icon: Icons.credit_card_outlined,
  ),
  ShowcaseEntry(
    title: 'List Tile',
    subtitle: 'Row & Leading',
    route: AppRoutes.showcaseListTile,
    icon: Icons.view_list_outlined,
  ),
  ShowcaseEntry(
    title: 'Chip & Badge',
    subtitle: 'Label & Status',
    route: AppRoutes.showcaseChipBadge,
    icon: Icons.label_outline,
  ),
  ShowcaseEntry(
    title: 'Avatar',
    subtitle: 'Image & Initial',
    route: AppRoutes.showcaseAvatar,
    icon: Icons.account_circle_outlined,
  ),
  ShowcaseEntry(
    title: 'App Bar',
    subtitle: 'Title & Action',
    route: AppRoutes.showcaseAppBar,
    icon: Icons.web_asset_outlined,
  ),
  ShowcaseEntry(
    title: 'Tabs',
    subtitle: 'In-screen Nav',
    route: AppRoutes.showcaseTabs,
    icon: Icons.tab_outlined,
  ),
  ShowcaseEntry(
    title: 'Progress',
    subtitle: 'Bar & Percentage',
    route: AppRoutes.showcaseProgress,
    icon: Icons.donut_large_outlined,
  ),
  ShowcaseEntry(
    title: 'Loading',
    subtitle: 'Spinner & Skeleton',
    route: AppRoutes.showcaseLoading,
    icon: Icons.hourglass_empty_outlined,
  ),
  ShowcaseEntry(
    title: 'Empty & Error',
    subtitle: 'Placeholder State',
    route: AppRoutes.showcaseEmptyError,
    icon: Icons.error_outline,
  ),
  ShowcaseEntry(
    title: 'Feedback',
    subtitle: 'Dialog & Snackbar',
    route: AppRoutes.showcaseFeedback,
    icon: Icons.feedback_outlined,
  ),
  ShowcaseEntry(
    title: 'Bottom Sheet',
    subtitle: 'Modal & Persistent',
    route: AppRoutes.showcaseBottomSheet,
    icon: Icons.vertical_align_bottom_outlined,
  ),
  ShowcaseEntry(
    title: 'Colors',
    subtitle: 'Palette & Scheme',
    route: AppRoutes.showcaseColors,
    icon: Icons.palette_outlined,
    category: ShowcaseCategory.foundation,
  ),
  ShowcaseEntry(
    title: 'Typography',
    subtitle: 'Text Styles',
    route: AppRoutes.showcaseTypography,
    icon: Icons.text_format_outlined,
    category: ShowcaseCategory.foundation,
  ),
  ShowcaseEntry(
    title: 'Spacing',
    subtitle: 'Radius & Layout',
    route: AppRoutes.showcaseSpacing,
    icon: Icons.space_bar_outlined,
    category: ShowcaseCategory.foundation,
  ),
  ShowcaseEntry(
    title: 'Elevation',
    subtitle: 'Shadow & Depth',
    route: AppRoutes.showcaseElevation,
    icon: Icons.layers_outlined,
    category: ShowcaseCategory.foundation,
  ),
  ShowcaseEntry(
    title: 'Icons',
    subtitle: 'Icon Set',
    route: AppRoutes.showcaseIcons,
    icon: Icons.emoji_symbols_outlined,
    category: ShowcaseCategory.foundation,
  ),
  ShowcaseEntry(
    title: 'Breakpoints',
    subtitle: 'Responsive Size',
    route: AppRoutes.showcaseBreakpoints,
    icon: Icons.devices_outlined,
    category: ShowcaseCategory.foundation,
  ),
];
