// import 'package:flutter/material.dart';
// import 'landing_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// // Exact color palette (use only these colors)
// const Color primaryColor = Color(0xFFFF6B6B);
// const Color secondaryColor = Color(0xFF4ECDC4);
// const Color accentYellow = Color(0xFFFFE66D);
// const Color accentBlue = Color(0xFF6C63FF);
// const Color bgColor = Color(0xFFFFF8E7);
// const Color cardColor = Color(0xFFFFFFFF);
// const Color surfaceColor = Color(0xFFFFF0D1);
// const Color textPrimary = Color(0xFF1A1A2E);
// const Color textSecondary = Color(0xFF4A4A5A);
// const Color borderColor = Color(0xFF1A1A2E);

// class WelcomePage extends StatelessWidget {
// 	const WelcomePage({super.key});

// 	@override
// 	Widget build(BuildContext context) {
// 		final cs = Theme.of(context).colorScheme;

// 		return Scaffold(
// 			backgroundColor: bgColor,
// 			body: SafeArea(
// 				child: LayoutBuilder(builder: (context, constraints) {
// 					final isNarrow = constraints.maxWidth < 420;
// 					return Center(
// 						child: ConstrainedBox(
// 							constraints: BoxConstraints(maxWidth: 760),
// 							child: Padding(
// 								padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
// 								child: Column(
// 									mainAxisSize: MainAxisSize.min,
// 									crossAxisAlignment: CrossAxisAlignment.center,
// 									children: [
// 										// Top centered logo
// 										Container(
// 											width: isNarrow ? 88 : 120,
// 											height: isNarrow ? 88 : 120,
// 											decoration: BoxDecoration(
// 												color: cs.primary,
// 												borderRadius: BorderRadius.circular(20),
// 												boxShadow: [
// 													BoxShadow(
// 														color: Colors.white.withValues(alpha: 0.12),
// 														blurRadius: 18,
// 														offset: const Offset(0, 8),
// 													),
// 												],
// 											),
// 											child: Icon(Icons.child_care_rounded, color: cs.onPrimary, size: isNarrow ? 44 : 64),
// 										),

// 										const SizedBox(height: 24),

// 										// Headline (bold)
// 										Text(
// 											'Welcome to TenderTrust',
// 											textAlign: TextAlign.center,
// 											style: TextStyle(
// 												color: textPrimary,
// 												fontSize: isNarrow ? 22 : 28,
// 												fontWeight: FontWeight.w900,
// 												height: 1.05,
// 											),
// 										),

// 										const SizedBox(height: 12),

// 										// Subtitle
// 										Text(
// 											'Find verified caregivers, get live updates, and book securely.',
// 											textAlign: TextAlign.center,
// 											style: TextStyle(
// 												color: textSecondary,
// 												fontSize: 14,
// 												height: 1.45,
// 												fontWeight: FontWeight.w500,
// 											),
// 										),

// 										const SizedBox(height: 26),

// 										// Buttons (stack on narrow screens)
// 										if (isNarrow) ...[
// 											SizedBox(
// 												width: double.infinity,
// 												child: ElevatedButton(
// 													style: ElevatedButton.styleFrom(
// 														backgroundColor: primaryColor,
// 														foregroundColor: cardColor,
// 														elevation: 6,
// 														shadowColor: borderColor.withValues(alpha: 0.12),
// 														shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
// 														padding: const EdgeInsets.symmetric(vertical: 14),
// 													),
// 													onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const TenderTrustLandingPage())),
// 													child: const Text('Get Started', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
// 												),
// 											),
// 											const SizedBox(height: 12),
// 											SizedBox(
// 												width: double.infinity,
// 												child: OutlinedButton(
// 													style: OutlinedButton.styleFrom(
// 														foregroundColor: accentBlue,
// 														side: BorderSide(color: accentBlue, width: 2),
// 														shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
// 														padding: const EdgeInsets.symmetric(vertical: 14),
// 													),
// 													onPressed: () {},
// 													child: const Text('Join as Caregiver', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
// 												),
// 											),
// 										] else ...[
// 											Row(
// 												mainAxisSize: MainAxisSize.min,
// 												children: [
// 													ElevatedButton(
// 														style: ElevatedButton.styleFrom(
// 															backgroundColor: primaryColor,
// 															foregroundColor: cardColor,
// 															elevation: 6,
// 															shadowColor: borderColor.withValues(alpha: 0.12),
// 															shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
// 															padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
// 														),
// 														onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const TenderTrustLandingPage())),
// 														child: const Text('Get Started', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
// 													),
// 													const SizedBox(width: 14),
// 													OutlinedButton(
// 														style: OutlinedButton.styleFrom(
// 															foregroundColor: accentBlue,
// 															side: BorderSide(color: accentBlue, width: 2),
// 															shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
// 															padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
// 														),
// 														onPressed: () {},
// 														child: const Text('Join as Caregiver', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
// 													),
// 												],
// 											),
// 										],

// 										const SizedBox(height: 20),

// 										// Soft card with small info (uses only palette colors)
// 										Container(
// 											width: isNarrow ? double.infinity : 420,
// 											padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
// 											decoration: BoxDecoration(
// 												color: cardColor,
// 												borderRadius: BorderRadius.circular(16),
// 												boxShadow: [BoxShadow(color: borderColor.withValues(alpha: 0.06), blurRadius: 14, offset: const Offset(0, 8))],
// 											),
// 											child: Row(
// 												mainAxisAlignment: MainAxisAlignment.center,
// 												children: [
// 													Icon(Icons.verified_user_rounded, color: secondaryColor, size: 20),
// 													const SizedBox(width: 10),
// 													Text('Verified caregivers • Secure bookings', style: TextStyle(color: textPrimary, fontWeight: FontWeight.w600)),
// 												],
// 											),
// 										),
// 									],
// 								),
// 							),
// 						),
// 					);
// 				}),
// 			),
// 		);
// 	}
// }


import 'package:flutter/material.dart';
import 'login_page.dart';
import 'parent/parent_home.dart';

// ─── Childcare Color Palette ──────────────────────────────────────────────
const Color primaryColor = Color(0xFFFF7E67); // Warm Coral
const Color secondaryColor = Color(0xFF56C6A9); // Mint Green
const Color accentYellow = Color(0xFFFFD166); // Sunny Yellow
const Color accentBlue = Color(0xFF7F9CF5); // Gentle Lavender-Blue
const Color bgColor = Color(0xFFFFF9F0); // Warm Cream Background
const Color cardColor = Color(0xFFFFFFFF); // White
const Color surfaceColor = Color(0xFFFFF1DB); // Soft Peach Surface
const Color textPrimary = Color(0xFF2D3047); // Warm Navy
const Color textSecondary = Color(0xFF6B7280); // Soft Grey
const Color borderColor = Color(0xFFE8D5C4); // Warm Tan Border
import 'package:firebase_auth/firebase_auth.dart';

// Colors
const Color primaryColor = Color(0xFFFF6B6B);
const Color bgColor = Color(0xFFFFF8E7);
const Color cardColor = Color(0xFFFFFFFF);
const Color textPrimary = Color(0xFF1A1A2E);
const Color textSecondary = Color(0xFF4A4A5A);

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;

  // Staggered animations
  late Animation<double> _logoScale;
  late Animation<double> _logoRotate;
  late Animation<double> _logoOpacity;
  late Animation<Offset> _titleSlide;
  late Animation<double> _titleOpacity;
  late Animation<Offset> _subtitleSlide;
  late Animation<double> _subtitleOpacity;
  late Animation<Offset> _buttonsSlide;
  late Animation<double> _buttonsOpacity;
  late Animation<Offset> _cardSlide;
  late Animation<double> _cardOpacity;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Main staggered animation (1.6 seconds total)
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    );

    // Gentle pulse loop for the logo (breathing effect)
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // ── Logo: 0ms → 500ms (bouncy scale + slight rotation) ──
    _logoScale =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween(
              begin: 0.0,
              end: 1.15,
            ).chain(CurveTween(curve: Curves.easeOutBack)),
            weight: 70,
          ),
          TweenSequenceItem(
            tween: Tween(
              begin: 1.15,
              end: 1.0,
            ).chain(CurveTween(curve: Curves.easeInOut)),
            weight: 30,
          ),
        ]).animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.0, 0.38),
          ),
        );
    _logoRotate = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.38, curve: Curves.elasticOut),
      ),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.2, curve: Curves.easeOut),
      ),
    );

    // ── Title: 250ms → 700ms ──
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.18, 0.50, curve: Curves.easeOutCubic),
          ),
        );
    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.18, 0.42, curve: Curves.easeOut),
      ),
    );

    // ── Subtitle: 400ms → 850ms ──
    _subtitleSlide =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.30, 0.58, curve: Curves.easeOutCubic),
          ),
        );
    _subtitleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.30, 0.50, curve: Curves.easeOut),
      ),
    );

    // ── Buttons: 550ms → 1050ms ──
    _buttonsSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.42, 0.72, curve: Curves.easeOutCubic),
          ),
        );
    _buttonsOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.42, 0.62, curve: Curves.easeOut),
      ),
    );

    // ── Info card: 700ms → 1200ms ──
    _cardSlide = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.55, 0.85, curve: Curves.easeOutCubic),
          ),
        );
    _cardOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.55, 0.75, curve: Curves.easeOut),
      ),
    );

    // ── Gentle pulse for logo after entrance ──
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Start the entrance animation
    _mainController.forward().then((_) {
      // After entrance completes, start gentle breathing pulse
      _pulseController.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    super.dispose();
class _WelcomePageState extends State<WelcomePage> {
  Future<void> _testSignup() async {
    try {
      final email =
          "test${DateTime.now().millisecondsSinceEpoch}@gmail.com";

      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: "123456",
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("User created: ${userCredential.user?.email}"),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Signup failed"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: Listenable.merge([_mainController, _pulseController]),
          builder: (context, _) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 420;
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 36,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // ── Animated Logo ──
                          _buildAnimatedLogo(cs, isNarrow),

                          const SizedBox(height: 24),

                          // ── Animated Title ──
                          SlideTransition(
                            position: _titleSlide,
                            child: FadeTransition(
                              opacity: _titleOpacity,
                              child: Text(
                                'Welcome to TenderTrust',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: textPrimary,
                                  fontSize: isNarrow ? 22 : 28,
                                  fontWeight: FontWeight.w900,
                                  height: 1.05,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // ── Animated Subtitle ──
                          SlideTransition(
                            position: _subtitleSlide,
                            child: FadeTransition(
                              opacity: _subtitleOpacity,
                              child: const Text(
                                'Find verified caregivers, get live updates, and book securely.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: textSecondary,
                                  fontSize: 14,
                                  height: 1.45,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 26),

                          // ── Animated Buttons ──
                          SlideTransition(
                            position: _buttonsSlide,
                            child: FadeTransition(
                              opacity: _buttonsOpacity,
                              child: _buildButtons(context, isNarrow),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // ── Animated Info Card ──
                          SlideTransition(
                            position: _cardSlide,
                            child: FadeTransition(
                              opacity: _cardOpacity,
                              child: _buildInfoCard(isNarrow),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo(ColorScheme cs, bool isNarrow) {
    final double baseSize = isNarrow ? 88 : 120;
    final double iconSize = isNarrow ? 44 : 64;

    return Opacity(
      opacity: _logoOpacity.value,
      child: Transform.rotate(
        angle: _logoRotate.value,
        child: Transform.scale(
          scale:
              _logoScale.value *
              (_mainController.isCompleted ? _pulseAnimation.value : 1.0),
          child: Container(
            width: baseSize,
            height: baseSize,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primaryColor, Color(0xFFFF9A85)],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.15),
                  blurRadius: 48,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Subtle inner glow
                Container(
                  width: baseSize - 8,
                  height: baseSize - 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                  ),
                ),
                Icon(
                  Icons.child_care_rounded,
                  color: cs.onPrimary,
                  size: iconSize,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context, bool isNarrow) {
    if (isNarrow) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: cardColor,
                elevation: 6,
                shadowColor: primaryColor.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const ParentHome()),
                (route) => false,
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: accentBlue,
                side: const BorderSide(color: accentBlue, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const LoginPage())),
              child: const Text(
                'Join as Caregiver',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: cardColor,
            elevation: 6,
            shadowColor: primaryColor.withValues(alpha: 0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          ),
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const ParentHome()),
            (route) => false,
          ),
          child: const Text(
            'Get Started',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 14),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: accentBlue,
            side: const BorderSide(color: accentBlue, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          ),
          onPressed: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const LoginPage())),
          child: const Text(
            'Join as Caregiver',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(bool isNarrow) {
    return Container(
      width: isNarrow ? double.infinity : 420,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: borderColor.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.verified_user_rounded, color: secondaryColor, size: 20),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              'Verified caregivers • Secure bookings',
              style: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: cs.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.child_care_rounded,
                    color: cs.onPrimary,
                    size: 60,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Welcome to TenderTrust',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Find verified caregivers, get live updates, and book securely.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: cardColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 14),
                  ),
                  onPressed: _testSignup,
                  child: const Text(
                    'Test Firebase Signup',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
