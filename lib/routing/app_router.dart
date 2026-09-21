import 'package:basecode/features/showcase/view/app_bar/app_bar_showcase_screen.dart';
import 'package:basecode/features/showcase/view/avatar/avatar_showcase_screen.dart';
import 'package:basecode/features/showcase/view/bottom_sheet/bottom_sheet_showcase_screen.dart';
import 'package:basecode/features/showcase/view/button/button_showcase_screen.dart';
import 'package:basecode/features/showcase/view/button/icon_button_showcase_screen.dart';
import 'package:basecode/features/showcase/view/card/card_showcase_screen.dart';
import 'package:basecode/features/showcase/view/carousel/carousel_showcase_screen.dart';
import 'package:basecode/features/showcase/view/checkbox/checkbox_radio_showcase_screen.dart';
import 'package:basecode/features/showcase/view/chip/chip_badge_showcase_screen.dart';
import 'package:basecode/features/showcase/view/dropdown/dropdown_showcase_screen.dart';
import 'package:basecode/features/showcase/view/empty_error/empty_error_showcase_screen.dart';
import 'package:basecode/features/showcase/view/feedback/feedback_showcase_screen.dart';
import 'package:basecode/features/showcase/view/form/form_showcase_screen.dart';
import 'package:basecode/features/showcase/view/foundation/breakpoints_showcase_screen.dart';
import 'package:basecode/features/showcase/view/foundation/colors_showcase_screen.dart';
import 'package:basecode/features/showcase/view/foundation/elevation_showcase_screen.dart';
import 'package:basecode/features/showcase/view/foundation/spacing_showcase_screen.dart';
import 'package:basecode/features/showcase/view/foundation/typography_showcase_screen.dart';
import 'package:basecode/features/showcase/view/list_tile/list_tile_showcase_screen.dart';
import 'package:basecode/features/showcase/view/loading/loading_showcase_screen.dart';
import 'package:basecode/features/showcase/view/progress/progress_showcase_screen.dart';
import 'package:basecode/features/showcase/view/showcase_screen.dart';
import 'package:basecode/features/showcase/view/skeleton/skeleton_showcase_screen.dart';
import 'package:basecode/features/showcase/view/slider/slider_showcase_screen.dart';
import 'package:basecode/features/showcase/view/switch/switch_showcase_screen.dart';
import 'package:basecode/features/showcase/view/tab/tab_bussines_showcase_screen.dart';
import 'package:basecode/features/showcase/view/tab/tab_showcase_screen.dart';
import 'package:basecode/features/showcase/view/text_field/text_field_showcase_screen.dart';
import 'package:basecode/routing/routes.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.showcase,
  routes: [
    // showcase
    GoRoute(
      path: AppRoutes.showcase,
      builder: (context, state) => const ShowcaseScreen(),
    ),
    GoRoute(
      path: AppRoutes.showcaseButton,
      builder: (context, state) => const ButtonShowcaseScreen(),
    ),
    GoRoute(
      path: AppRoutes.showcaseCard,
      builder: (context, state) => const CardShowcaseScreen(),
    ),
    GoRoute(
      path: AppRoutes.showcaseSkeleton,
      builder: (context, state) => const SkeletonShowcaseScreen(),
    ),
    GoRoute(
      path: AppRoutes.showcaseIconButton,
      builder: (context, state) => const IconButtonShowcaseScreen(),
    ),
    GoRoute(
      path: AppRoutes.showcaseTextField,
      builder: (context, state) => const TextFieldShowcaseScreen(),
    ),
    GoRoute(
      path: AppRoutes.showcaseCheckboxRadio,
      builder: (context, state) => const CheckboxRadioShowcaseScreen(),
    ),
    GoRoute(
      path: AppRoutes.showcaseSwitch,
      builder: (context, state) => const SwitchShowcaseScreen(),
    ),
    GoRoute(
      path: AppRoutes.showcaseListTile,
      builder: (context, state) => const ListTileShowcaseScreen(),
    ),
    GoRoute(
      path: AppRoutes.showcaseAvatar,
      builder: (context, state) => const AvatarShowcaseScreen(),
    ),
    GoRoute(
      path: AppRoutes.showcaseEmptyError,
      builder: (context, state) => const EmptyErrorShowcaseScreen(),
    ),
    GoRoute(
      path: AppRoutes.showcaseFeedback,
      builder: (context, state) => const FeedbackShowcaseScreen(),
    ),
    GoRoute(
      path: AppRoutes.showcaseChipBadge,
      builder: (context, state) => const ChipBadgeShowcaseScreen(),
    ),
    GoRoute(
      path: AppRoutes.showcaseBottomSheet,
      builder: (context, state) => const BottomSheetShowcaseScreen(),
    ),
    GoRoute(
      path: AppRoutes.showcaseForm,
      builder: (context, state) => const FormShowcaseScreen(),
    ),
    GoRoute(
      path: AppRoutes.showcaseDropdown,
      builder: (context, state) => const DropdownShowcaseScreen(),
    ),
    GoRoute(
      path: AppRoutes.showcaseProgress,
      builder: (context, state) => const ProgressShowcaseScreen(),
    ),
    GoRoute(
      path: AppRoutes.showcaseLoading,
      builder: (context, state) => const LoadingShowcaseScreen(),
    ),
    GoRoute(
      path: AppRoutes.showcaseAppBar,
      builder: (context, state) => const AppBarShowcaseScreen(),
    ),
    GoRoute(
      path: AppRoutes.showcaseTabs,
      builder: (context, state) => const TabShowcaseScreen(),
    ),
    GoRoute(
      path: AppRoutes.showcaseMainTabs,
      builder: (context, state) => const TabBussinesShowcaseScreen(),
    ),

    // showcase - foundation
    GoRoute(
      path: AppRoutes.showcaseColors,
      builder: (context, state) => const ColorsShowcaseScreen(),
    ),
    GoRoute(
      path: AppRoutes.showcaseTypography,
      builder: (context, state) => const TypographyShowcaseScreen(),
    ),
    GoRoute(
      path: AppRoutes.showcaseSpacing,
      builder: (context, state) => const SpacingShowcaseScreen(),
    ),
    GoRoute(
      path: AppRoutes.showcaseElevation,
      builder: (context, state) => const ElevationShowcaseScreen(),
    ),
    GoRoute(
      path: AppRoutes.showcaseBreakpoints,
      builder: (context, state) => const BreakpointsShowcaseScreen(),
    ),
    GoRoute(
      path: AppRoutes.showcaseSlider,
      builder: (context, state) => const SliderShowcaseScreen(),
    ),
    GoRoute(
      path: AppRoutes.showcaseCarousel,
      builder: (context, state) => const CarouselShowcaseScreen(),
    ),
  ],
);
