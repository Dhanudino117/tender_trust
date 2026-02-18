import 'package:flutter/material.dart';

class TenderTrustLandingPage extends StatefulWidget {
  const TenderTrustLandingPage({super.key});

  @override
  State<TenderTrustLandingPage> createState() => _TenderTrustLandingPageState();
}

class _TenderTrustLandingPageState extends State<TenderTrustLandingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final ScrollController _scrollController = ScrollController();
  int _currentNavIndex = 0;

  // ─── Neo Brutalism Palette ──────────────────────────────────────────────
  static const Color primaryColor = Color(0xFFFF6B6B);
  static const Color secondaryColor = Color(0xFF4ECDC4);
  static const Color accentYellow = Color(0xFFFFE66D);
  static const Color accentBlue = Color(0xFF6C63FF);
  static const Color bgColor = Color(0xFFFFF8E7);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color surfaceColor = Color(0xFFFFF0D1);
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF4A4A5A);
  static const Color borderColor = Color(0xFF1A1A2E);

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ─── Neo Brutalism Box Helper ──────────────────────────────────────────
  BoxDecoration _brutalistBox({
    Color color = cardColor,
    double borderWidth = 3,
    double shadowX = 4,
    double shadowY = 4,
    double radius = 0,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor, width: borderWidth),
      boxShadow: [
        BoxShadow(
          color: borderColor,
          offset: Offset(shadowX, shadowY),
          blurRadius: 0,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(child: _buildHeroSection()),
            SliverToBoxAdapter(child: _buildStatsBar()),
            SliverToBoxAdapter(child: _buildFeaturesSection()),
            SliverToBoxAdapter(child: _buildHowItWorksSection()),
            SliverToBoxAdapter(child: _buildRolesSection()),
            SliverToBoxAdapter(child: _buildSafetySection()),
            SliverToBoxAdapter(child: _buildTestimonialsSection()),
            SliverToBoxAdapter(child: _buildCTASection()),
            SliverToBoxAdapter(child: _buildFooter()),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // APP BAR
  // ═══════════════════════════════════════════════════════════════════════
  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: bgColor,
      surfaceTintColor: bgColor,
      elevation: 0,
      toolbarHeight: 60,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: _brutalistBox(
              color: primaryColor,
              radius: 4,
              borderWidth: 2.5,
              shadowX: 2,
              shadowY: 2,
            ),
            child: const Icon(
              Icons.child_care_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'TenderTrust',
            style: TextStyle(
              color: textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Container(
            decoration: _brutalistBox(
              color: primaryColor,
              radius: 4,
              borderWidth: 2,
              shadowX: 2,
              shadowY: 2,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(3),
        child: Container(height: 3, color: borderColor),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // HERO SECTION
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildHeroSection() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 28, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: _brutalistBox(
                color: accentYellow,
                radius: 4,
                borderWidth: 2,
                shadowX: 2,
                shadowY: 2,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified_rounded, color: textPrimary, size: 14),
                  SizedBox(width: 6),
                  Text(
                    'TRUSTED BY 10K+ FAMILIES',
                    style: TextStyle(
                      color: textPrimary,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Headline
            const Text(
              'Childcare You\nCan Trust',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textPrimary,
                fontSize: 34,
                fontWeight: FontWeight.w900,
                height: 1.1,
                letterSpacing: -1.5,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Connect with verified, background-checked caregivers. Real-time updates, transparent reviews, and emergency safety — all in one app.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textSecondary,
                fontSize: 14,
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 28),
            // CTA Buttons
            _buildPrimaryButton(
              'Find a Caregiver',
              Icons.search_rounded,
              primaryColor,
            ),
            const SizedBox(height: 12),
            _buildOutlineButton('Join as Caregiver', Icons.person_add_rounded),
            const SizedBox(height: 32),
            // Illustration card
            _buildHeroCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _brutalistBox(
        color: cardColor,
        radius: 4,
        borderWidth: 3,
        shadowX: 6,
        shadowY: 6,
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: _brutalistBox(
              color: secondaryColor,
              radius: 40,
              borderWidth: 3,
              shadowX: 3,
              shadowY: 3,
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Sarah Johnson',
            style: TextStyle(
              color: textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Certified Childcare Provider',
            style: TextStyle(
              color: textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: _brutalistBox(
              color: secondaryColor,
              radius: 4,
              borderWidth: 2,
              shadowX: 2,
              shadowY: 2,
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_rounded, color: Colors.white, size: 14),
                SizedBox(width: 5),
                Text(
                  'Verified',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(
                5,
                (_) => const Icon(
                  Icons.star_rounded,
                  color: Color(0xFFFFD700),
                  size: 20,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                '4.9',
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: _brutalistBox(
              color: surfaceColor,
              radius: 4,
              borderWidth: 2,
              shadowX: 2,
              shadowY: 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _miniStat('Exp', '5 Yrs'),
                Container(width: 2, height: 24, color: borderColor),
                _miniStat('Sessions', '320+'),
                Container(width: 2, height: 24, color: borderColor),
                _miniStat('Rate', '\$18/hr'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // STATS BAR
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildStatsBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: _brutalistBox(
          color: cardColor,
          radius: 4,
          borderWidth: 3,
          shadowX: 5,
          shadowY: 5,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _statItem(
                    '10K+',
                    'Families',
                    Icons.family_restroom_rounded,
                    primaryColor,
                  ),
                ),
                Expanded(
                  child: _statItem(
                    '2.5K+',
                    'Caregivers',
                    Icons.verified_user_rounded,
                    secondaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _statItem(
                    '50K+',
                    'Sessions',
                    Icons.event_available_rounded,
                    accentBlue,
                  ),
                ),
                Expanded(
                  child: _statItem(
                    '4.8★',
                    'Rating',
                    Icons.star_rounded,
                    accentYellow,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String value, String label, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: _brutalistBox(
            color: color,
            radius: 4,
            borderWidth: 2,
            shadowX: 2,
            shadowY: 2,
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // FEATURES SECTION
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildFeaturesSection() {
    final features = [
      _FeatureData(
        icon: Icons.verified_user_rounded,
        title: 'Verified Profiles',
        description: 'Thorough background checks and document verification.',
        color: primaryColor,
      ),
      _FeatureData(
        icon: Icons.star_rounded,
        title: 'Transparent Reviews',
        description: 'Post-booking only reviews linked to real sessions.',
        color: accentYellow,
      ),
      _FeatureData(
        icon: Icons.update_rounded,
        title: 'Real-Time Updates',
        description: 'Live session updates — meals, naps, playtime.',
        color: secondaryColor,
      ),
      _FeatureData(
        icon: Icons.sos_rounded,
        title: 'Emergency SOS',
        description: 'One-tap emergency alerts with instant notification.',
        color: const Color(0xFFFF4444),
      ),
      _FeatureData(
        icon: Icons.book_online_rounded,
        title: 'Smart Bookings',
        description: 'Send, accept, and track bookings seamlessly.',
        color: accentBlue,
      ),
      _FeatureData(
        icon: Icons.security_rounded,
        title: 'Secure Platform',
        description: 'Firebase Auth, role-based rules, encrypted storage.',
        color: const Color(0xFF00897B),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Column(
        children: [
          _sectionBadge('CORE FEATURES'),
          const SizedBox(height: 14),
          const Text(
            'Everything for\nSafe Childcare',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              height: 1.15,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Verification, transparency, and real-time communication in one platform.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textSecondary,
              fontSize: 13,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          ...features.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildFeatureCard(f),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(_FeatureData feature) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _brutalistBox(
        color: cardColor,
        radius: 4,
        borderWidth: 3,
        shadowX: 4,
        shadowY: 4,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: _brutalistBox(
              color: feature.color,
              radius: 4,
              borderWidth: 2.5,
              shadowX: 2,
              shadowY: 2,
            ),
            child: Icon(feature.icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: const TextStyle(
                    color: textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  feature.description,
                  style: const TextStyle(
                    color: textSecondary,
                    fontSize: 13,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // HOW IT WORKS
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildHowItWorksSection() {
    final steps = [
      _StepData(
        number: '01',
        title: 'Create Account',
        description: 'Sign up as Parent or Caregiver with secure auth.',
        icon: Icons.person_add_alt_1_rounded,
        color: primaryColor,
      ),
      _StepData(
        number: '02',
        title: 'Browse & Verify',
        description: 'Parents browse. Caregivers upload ID for approval.',
        icon: Icons.search_rounded,
        color: secondaryColor,
      ),
      _StepData(
        number: '03',
        title: 'Book a Session',
        description: 'Send booking with date, time & notes.',
        icon: Icons.calendar_month_rounded,
        color: accentBlue,
      ),
      _StepData(
        number: '04',
        title: 'Stay Connected',
        description: 'Real-time updates during sessions, reviews after.',
        icon: Icons.favorite_rounded,
        color: accentYellow,
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      decoration: const BoxDecoration(
        color: surfaceColor,
        border: Border(
          top: BorderSide(color: borderColor, width: 3),
          bottom: BorderSide(color: borderColor, width: 3),
        ),
      ),
      child: Column(
        children: [
          _sectionBadge('HOW IT WORKS'),
          const SizedBox(height: 14),
          const Text(
            '4 Simple Steps',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 24),
          ...steps.map(
            (step) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildStepCard(step),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard(_StepData step) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _brutalistBox(
        color: cardColor,
        radius: 4,
        borderWidth: 3,
        shadowX: 4,
        shadowY: 4,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: _brutalistBox(
              color: step.color,
              radius: 4,
              borderWidth: 2.5,
              shadowX: 2,
              shadowY: 2,
            ),
            child: Center(
              child: Text(
                step.number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(step.icon, color: step.color, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      step.title,
                      style: const TextStyle(
                        color: textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  step.description,
                  style: const TextStyle(
                    color: textSecondary,
                    fontSize: 13,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // ROLES SECTION
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildRolesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Column(
        children: [
          _sectionBadge('USER ROLES'),
          const SizedBox(height: 14),
          const Text(
            'Designed for\nBoth Sides',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              height: 1.15,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 24),
          _buildRoleCard(isParent: true),
          const SizedBox(height: 16),
          _buildRoleCard(isParent: false),
        ],
      ),
    );
  }

  Widget _buildRoleCard({required bool isParent}) {
    final color = isParent ? primaryColor : secondaryColor;
    final icon = isParent
        ? Icons.family_restroom_rounded
        : Icons.person_rounded;
    final title = isParent ? 'For Parents' : 'For Caregivers';
    final features = isParent
        ? [
            'Browse verified caregivers',
            'Send booking requests',
            'Real-time session updates',
            'Rate and review caregivers',
            'Emergency SOS alerts',
          ]
        : [
            'Professional profile',
            'Upload verification docs',
            'Accept or reject bookings',
            'Send live activity updates',
            'Build reputation with reviews',
          ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _brutalistBox(
        color: cardColor,
        radius: 4,
        borderWidth: 3,
        shadowX: 5,
        shadowY: 5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: _brutalistBox(
                  color: color,
                  radius: 4,
                  borderWidth: 2.5,
                  shadowX: 2,
                  shadowY: 2,
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 14),
              Text(
                title,
                style: const TextStyle(
                  color: textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...features.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: _brutalistBox(
                      color: color,
                      radius: 2,
                      borderWidth: 1.5,
                      shadowX: 1,
                      shadowY: 1,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    f,
                    style: const TextStyle(
                      color: textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: _brutalistBox(
                color: color,
                radius: 4,
                borderWidth: 3,
                shadowX: 3,
                shadowY: 3,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      isParent ? 'Sign Up as Parent' : 'Join as Caregiver',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // SAFETY SECTION
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildSafetySection() {
    final safetyFeatures = [
      _SafetyItem(
        icon: Icons.fingerprint_rounded,
        title: 'Firebase Auth',
        description: 'Secure email login with role-based access',
      ),
      _SafetyItem(
        icon: Icons.admin_panel_settings_rounded,
        title: 'Role-Based Security',
        description: 'Data access only by authorized users',
      ),
      _SafetyItem(
        icon: Icons.verified_rounded,
        title: 'Verified Only',
        description: 'Only approved caregivers visible',
      ),
      _SafetyItem(
        icon: Icons.rate_review_rounded,
        title: 'Review Protection',
        description: 'Reviews restricted to completed bookings',
      ),
      _SafetyItem(
        icon: Icons.cloud_done_rounded,
        title: 'Secure Storage',
        description: 'Firebase Storage for documents',
      ),
      _SafetyItem(
        icon: Icons.emergency_rounded,
        title: 'SOS System',
        description: 'One-tap emergency alerts',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Column(
        children: [
          _sectionBadge('SECURITY'),
          const SizedBox(height: 14),
          const Text(
            'Safety is Our\nTop Priority',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              height: 1.15,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Multiple layers of security protect every family.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textSecondary,
              fontSize: 13,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          ...safetyFeatures.map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildSafetyCard(s),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyCard(_SafetyItem item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _brutalistBox(
        color: cardColor,
        radius: 4,
        borderWidth: 2.5,
        shadowX: 3,
        shadowY: 3,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: _brutalistBox(
              color: primaryColor,
              radius: 4,
              borderWidth: 2,
              shadowX: 2,
              shadowY: 2,
            ),
            child: Icon(item.icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    color: textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.description,
                  style: const TextStyle(
                    color: textSecondary,
                    fontSize: 12,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // TESTIMONIALS
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildTestimonialsSection() {
    final testimonials = [
      _Testimonial(
        name: 'Emily Parker',
        role: 'Parent of 2',
        text:
            '"TenderTrust gave me peace of mind. Real-time updates let me focus on work knowing my kids are safe."',
        rating: 5,
        color: primaryColor,
      ),
      _Testimonial(
        name: 'Maria Santos',
        role: 'Certified Caregiver',
        text:
            '"Incredible for building reputation. Verified badge and real reviews helped grow my business."',
        rating: 5,
        color: secondaryColor,
      ),
      _Testimonial(
        name: 'David Chen',
        role: 'Parent',
        text:
            '"The SOS feature alone makes this worth it. We used it once — response was instant."',
        rating: 5,
        color: accentBlue,
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      decoration: const BoxDecoration(
        color: surfaceColor,
        border: Border(
          top: BorderSide(color: borderColor, width: 3),
          bottom: BorderSide(color: borderColor, width: 3),
        ),
      ),
      child: Column(
        children: [
          _sectionBadge('TESTIMONIALS'),
          const SizedBox(height: 14),
          const Text(
            'Loved by Families\n& Caregivers',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              height: 1.15,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 24),
          ...testimonials.map(
            (t) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildTestimonialCard(t),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialCard(_Testimonial t) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _brutalistBox(
        color: cardColor,
        radius: 4,
        borderWidth: 3,
        shadowX: 4,
        shadowY: 4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 36, height: 4, color: t.color),
          const SizedBox(height: 12),
          Row(
            children: List.generate(
              t.rating,
              (_) => const Icon(
                Icons.star_rounded,
                color: Color(0xFFFFD700),
                size: 18,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            t.text,
            style: const TextStyle(
              color: textSecondary,
              fontSize: 14,
              height: 1.6,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: _brutalistBox(
                  color: t.color,
                  radius: 19,
                  borderWidth: 2,
                  shadowX: 2,
                  shadowY: 2,
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.name,
                    style: const TextStyle(
                      color: textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    t.role,
                    style: TextStyle(
                      color: t.color,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // CTA SECTION
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildCTASection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        decoration: _brutalistBox(
          color: primaryColor,
          radius: 4,
          borderWidth: 3,
          shadowX: 6,
          shadowY: 6,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: _brutalistBox(
                color: accentYellow,
                radius: 4,
                borderWidth: 2.5,
                shadowX: 3,
                shadowY: 3,
              ),
              child: const Icon(
                Icons.child_care_rounded,
                color: textPrimary,
                size: 32,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Ready to Find\nTrusted Care?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                height: 1.15,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Join thousands of families who trust TenderTrust.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            // Primary CTA — white
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: _brutalistBox(
                  color: cardColor,
                  radius: 4,
                  borderWidth: 3,
                  shadowX: 3,
                  shadowY: 3,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_rounded,
                            color: primaryColor,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Find a Caregiver',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Secondary CTA — outline
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.white24,
                      offset: Offset(3, 3),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_add_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Become a Caregiver',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // FOOTER
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
      decoration: const BoxDecoration(
        color: surfaceColor,
        border: Border(top: BorderSide(color: borderColor, width: 3)),
      ),
      child: Column(
        children: [
          // Brand
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: _brutalistBox(
                  color: primaryColor,
                  radius: 4,
                  borderWidth: 2,
                  shadowX: 2,
                  shadowY: 2,
                ),
                child: const Icon(
                  Icons.child_care_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'TenderTrust',
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Trusted childcare for families everywhere.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textSecondary,
              fontSize: 12,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),
          Container(height: 2, color: borderColor),
          const SizedBox(height: 10),
          const Text(
            '© 2026 TenderTrust. All rights reserved.',
            style: TextStyle(
              color: textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // BOTTOM NAVIGATION BAR
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildBottomNavBar() {
    final items = [
      {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.search_rounded, 'label': 'Search'},
      {'icon': Icons.calendar_month_rounded, 'label': 'Bookings'},
      {'icon': Icons.person_rounded, 'label': 'Profile'},
    ];

    return Container(
      decoration: const BoxDecoration(
        color: cardColor,
        border: Border(top: BorderSide(color: borderColor, width: 3)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              final isActive = i == _currentNavIndex;
              final icon = item['icon'] as IconData;
              final label = item['label'] as String;

              return GestureDetector(
                onTap: () => setState(() => _currentNavIndex = i),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: isActive
                      ? _brutalistBox(
                          color: primaryColor,
                          radius: 4,
                          borderWidth: 2.5,
                          shadowX: 3,
                          shadowY: 3,
                        )
                      : null,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        color: isActive ? Colors.white : textSecondary,
                        size: 22,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        label,
                        style: TextStyle(
                          color: isActive ? Colors.white : textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // SHARED WIDGETS
  // ═══════════════════════════════════════════════════════════════════════
  Widget _sectionBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: _brutalistBox(
        color: accentYellow,
        radius: 4,
        borderWidth: 2,
        shadowX: 2,
        shadowY: 2,
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: textPrimary,
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildPrimaryButton(String text, IconData icon, Color color) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: _brutalistBox(
          color: color,
          radius: 4,
          borderWidth: 3,
          shadowX: 4,
          shadowY: 4,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOutlineButton(String text, IconData icon) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: _brutalistBox(
          color: bgColor,
          radius: 4,
          borderWidth: 3,
          shadowX: 4,
          shadowY: 4,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: textPrimary, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    text,
                    style: const TextStyle(
                      color: textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Data Models ────────────────────────────────────────────────────────
class _FeatureData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  const _FeatureData({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}

class _StepData {
  final String number;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  const _StepData({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class _SafetyItem {
  final IconData icon;
  final String title;
  final String description;
  const _SafetyItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class _Testimonial {
  final String name;
  final String role;
  final String text;
  final int rating;
  final Color color;
  const _Testimonial({
    required this.name,
    required this.role,
    required this.text,
    required this.rating,
    required this.color,
  });
}
