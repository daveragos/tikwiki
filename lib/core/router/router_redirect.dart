import 'package:tikwiki/core/router/route_names.dart';

String? appRouterRedirect({
  required bool isAuthenticated,
  required String location,
}) {
  final isAuthRoute = location == RouteNames.auth;

  if (!isAuthenticated && !isAuthRoute) {
    return RouteNames.auth;
  }

  if (isAuthenticated && isAuthRoute) {
    return RouteNames.home;
  }

  return null;
}
