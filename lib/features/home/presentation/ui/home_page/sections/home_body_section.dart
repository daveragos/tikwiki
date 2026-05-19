part of '../home_page.dart';

class _HomeBodySection extends ConsumerStatefulWidget {
  const _HomeBodySection();

  @override
  ConsumerState<_HomeBodySection> createState() => _HomeBodySectionState();
}

class _HomeBodySectionState extends ConsumerState<_HomeBodySection> {
  var _isSigningOut = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);
    final user = authState.asData?.value;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Welcome back',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          user?.displayName?.trim().isNotEmpty == true
              ? user?.displayName ?? user?.email ?? 'Signed in'
              : user?.email ?? 'Signed in',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Account',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                _InfoRow(
                  icon: Icons.mail_outline,
                  label: 'Email',
                  value: user?.email ?? 'No email found',
                ),
                const SizedBox(height: 12),
                _InfoRow(
                  icon: Icons.perm_identity,
                  label: 'User ID',
                  value: user?.uid ?? 'Unavailable',
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _isSigningOut ? null : _signOut,
                    icon: _isSigningOut
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.logout),
                    label: Text(_isSigningOut ? 'Signing out...' : 'Sign out'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _signOut() async {
    setState(() {
      _isSigningOut = true;
    });

    final result = await ref.read(authProvider.notifier).signOut();

    if (!mounted) {
      return;
    }

    setState(() {
      _isSigningOut = false;
    });

    if (result case Failure(error: final error)) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(error.userMessage)));
    }
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(value, style: theme.textTheme.bodyLarge),
            ],
          ),
        ),
      ],
    );
  }
}
