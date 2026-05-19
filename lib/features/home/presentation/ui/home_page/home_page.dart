import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tikwiki/core/error/result.dart';
import 'package:tikwiki/features/auth/presentation/providers/auth_notifier/auth_notifier.dart';

part 'screen/home_screen.dart';
part 'sections/home_body_section.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const _HomeScreen();
  }
}
