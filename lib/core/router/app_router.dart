import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tikwiki/core/di/injection.dart';
import 'package:tikwiki/core/router/route_names.dart';
import 'package:tikwiki/core/router/router_redirect.dart';
import 'package:tikwiki/core/router/router_refresh_listenable.dart';
import 'package:tikwiki/features/auth/domain/repositories/auth_repository.dart';
import 'package:tikwiki/features/auth/presentation/ui/auth_page/auth_page.dart';
import 'package:tikwiki/features/home/presentation/ui/home_page/home_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final repository = container<AuthRepository>();
  final refreshListenable = RouterRefreshListenable(
    repository.authStateChanges,
  );

  ref.onDispose(refreshListenable.dispose);

  return GoRouter(
    initialLocation: RouteNames.home,
    refreshListenable: refreshListenable,
    redirect: (context, state) => appRouterRedirect(
      isAuthenticated: repository.currentUser != null,
      location: state.matchedLocation,
    ),
    routes: [
      GoRoute(
        path: RouteNames.home,
        name: RouteNames.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: RouteNames.auth,
        name: RouteNames.auth,
        builder: (context, state) => const AuthPage(),
      ),
    ],
  );
});
