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