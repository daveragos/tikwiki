import 'package:flutter_test/flutter_test.dart';
import 'package:tikwiki/core/router/route_names.dart';
import 'package:tikwiki/core/router/router_redirect.dart';

void main() {
  group('appRouterRedirect', () {
    test('redirects signed-out users to auth', () {
      expect(
        appRouterRedirect(isAuthenticated: false, location: RouteNames.home),
        RouteNames.auth,
      );
    });

    test('redirects signed-in users away from auth', () {
      expect(
        appRouterRedirect(isAuthenticated: true, location: RouteNames.auth),
        RouteNames.home,
      );
    });

    test('allows matching routes to continue', () {
      expect(
        appRouterRedirect(isAuthenticated: true, location: RouteNames.home),
        isNull,
      );
      expect(
        appRouterRedirect(isAuthenticated: false, location: RouteNames.auth),
        isNull,
      );
    });
  });
}
