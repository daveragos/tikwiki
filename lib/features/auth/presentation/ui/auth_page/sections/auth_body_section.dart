part of '../auth_page.dart';

class _AuthBodySection extends ConsumerStatefulWidget {
  const _AuthBodySection();

  @override
  ConsumerState<_AuthBodySection> createState() => _AuthBodySectionState();
}

class _AuthBodySectionState extends ConsumerState<_AuthBodySection> {
  var _isSubmitting = false;

  // 14 fixed starry offsets (fractions) for a consistent celestial map
  static const List<Offset> _starOffsets = [
    Offset(0.15, 0.12),
    Offset(0.85, 0.18),
    Offset(0.35, 0.25),
    Offset(0.72, 0.28),
    Offset(0.20, 0.38),
    Offset(0.88, 0.45),
    Offset(0.55, 0.52),
    Offset(0.12, 0.58),
    Offset(0.92, 0.65),
    Offset(0.28, 0.70),
    Offset(0.78, 0.75),
    Offset(0.45, 0.82),
    Offset(0.82, 0.90),
    Offset(0.22, 0.94),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.0, -0.2),
          radius: 1.5,
          colors: [
            Color(0xFF1F232D), // Lighter radial center
            Color(0xFF090A0D), // Midnight dark edge
          ],
        ),
      ),
      child: Stack(
        children: [
          // Celestial Starry Layer
          ..._starOffsets.map((offset) {
            final x = offset.dx * size.width;
            final y = offset.dy * size.height;
            final double starSize = (offset.dx * 3).clamp(1.0, 2.5);
            final double opacity = (offset.dy * 0.4).clamp(0.15, 0.45);

            return Positioned(
              left: x,
              top: y,
              child: Container(
                width: starSize,
                height: starSize,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: opacity),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: opacity * 0.5),
                      blurRadius: starSize,
                      spreadRadius: 0.5,
                    ),
                  ],
                ),
              ),
            );
          }),

          // Content Layer
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 24.0,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Top capsule badge
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(
                                0xFF8AB4F8,
                              ), // Soft blue indicator dot
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'V1.2 BETA',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(flex: 3),

                  // Brand identity block
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'TikWiki',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w800,
                            color: Color(
                              0xFFD4E2FC,
                            ), // Premium soft blue/indigo hue
                            letterSpacing: -0.8,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Knowledge in your pocket',
                          style: TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Georgia',
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(flex: 4),

                  // Interactive Bottom Area (Button and Terms)
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 380),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Continue/Sign In with Google Button
                        GestureDetector(
                          onTap: _isSubmitting ? null : _signInWithGoogle,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 56,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEBEAEA),
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: _isSubmitting
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFF1F1F1F),
                                      ),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.network(
                                        'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1024px-Google_%22G%22_logo.svg.png',
                                        width: 20,
                                        height: 20,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Container(
                                                width: 20,
                                                height: 20,
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  'G',
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              );
                                            },
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Sign in with Google',
                                        style: TextStyle(
                                          color: Color(0xFF1F1F1F),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Legalese section
                        Text(
                          'By signing in, you agree to our',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Add click behaviour if desired
                              },
                              child: Text(
                                'Terms of Service',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              ' & ',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.4),
                                fontSize: 12,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Add click behaviour if desired
                              },
                              child: Text(
                                'Privacy Policy',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    if (_isSubmitting) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final notifier = ref.read(authProvider.notifier);
    final result = await notifier.signInWithGoogle();

    if (!mounted) {
      return;
    }

    setState(() {
      _isSubmitting = false;
    });

    if (result case Failure(error: final error)) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(error.userMessage)));
    }
  }
}
