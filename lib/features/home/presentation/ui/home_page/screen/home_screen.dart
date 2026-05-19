part of '../home_page.dart';

class _HomeScreen extends ConsumerWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Continue')),
      body: const SafeArea(child: _HomeBodySection()),
    );
  }
}
