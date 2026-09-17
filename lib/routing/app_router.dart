import 'package:basecode/features/showcase/view/showcase_screen.dart';
import 'package:basecode/routing/routes.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.showcase,
  routes: [
    GoRoute(
      path: AppRoutes.showcase,
      builder: (context, state) => const ShowcaseScreen(),
    ),
  ],
);
