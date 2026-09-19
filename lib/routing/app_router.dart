import 'package:basecode/features/showcase/view/button/button_showcase_screen.dart';
import 'package:basecode/features/showcase/view/button/icon_button_showcase_screen.dart';
import 'package:basecode/features/showcase/view/card/card_showcase_screen.dart';
import 'package:basecode/features/showcase/view/showcase_screen.dart';
import 'package:basecode/features/showcase/view/skeleton/skeleton_showcase_screen.dart';
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
  ],
);
