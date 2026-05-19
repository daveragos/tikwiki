part of '../auth_page.dart';

class _AuthScreen extends ConsumerWidget {
  const _AuthScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(body: _AuthBodySection());
  }
}
