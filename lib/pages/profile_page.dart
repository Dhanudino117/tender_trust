import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth_state.dart';
import 'welcome.dart';
import 'login_page.dart';

// ─── Childcare Color Palette ──────────────────────────────────────────────
const Color _primaryColor = Color(0xFFFF7E67);
const Color _secondaryColor = Color(0xFF56C6A9);
const Color _accentYellow = Color(0xFFFFD166);
const Color _accentBlue = Color(0xFF7F9CF5);
const Color _bgColor = Color(0xFFFFF9F0);
const Color _cardColor = Color(0xFFFFFFFF);
const Color _textPrimary = Color(0xFF2D3047);
const Color _textSecondary = Color(0xFF6B7280);
const Color _borderColor = Color(0xFFE8D5C4);

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  // Profile photo state
  String? _profileImageUrl;
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.1, 0.7, curve: Curves.easeOutCubic),
          ),
        );
    _animController.forward();
    _loadProfileImage();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  /// Load existing profile photo URL from Firestore
  Future<void> _loadProfileImage() async {
    final auth = AuthState();
    if (!auth.isLoggedIn) return;
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.userId)
          .get();
      final data = doc.data();
      if (data != null && data['photoUrl'] != null && mounted) {
        setState(() => _profileImageUrl = data['photoUrl'] as String);
      }
    } catch (_) {
      // Silently fail — will show initials
    }
  }

  /// Upload image to Firebase Storage and save URL to Firestore
  Future<void> _uploadProfileImage(File imageFile) async {
    final auth = AuthState();
    if (!auth.isLoggedIn) return;

    setState(() => _isUploading = true);

    try {
      // Upload to Firebase Storage
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_photos')
          .child('${auth.userId}.jpg');

      await ref.putFile(imageFile, SettableMetadata(contentType: 'image/jpeg'));

      final downloadUrl = await ref.getDownloadURL();

      // Save photo URL in Firestore user document
      await FirebaseFirestore.instance.collection('users').doc(auth.userId).set(
        {'photoUrl': downloadUrl, 'updatedAt': FieldValue.serverTimestamp()},
        SetOptions(merge: true),
      );

      if (mounted) {
        setState(() {
          _profileImageUrl = downloadUrl;
          _isUploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile photo updated!'),
            backgroundColor: _secondaryColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload photo: $e'),
            backgroundColor: const Color(0xFFE53935),
          ),
        );
      }
    }
  }

  /// Remove profile photo from Firebase Storage and Firestore
  Future<void> _removeProfileImage() async {
    final auth = AuthState();
    if (!auth.isLoggedIn) return;

    setState(() => _isUploading = true);

    try {
      // Delete from Firebase Storage
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_photos')
          .child('${auth.userId}.jpg');
      try {
        await ref.delete();
      } catch (_) {
        // File may not exist, that's fine
      }

      // Remove URL from Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.userId)
          .update({'photoUrl': FieldValue.delete()});

      if (mounted) {
        setState(() {
          _profileImageUrl = null;
          _isUploading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  void _handleLogout() {
    AuthState().logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const WelcomePage()),
      (route) => false,
    );
  }

  Future<void> _pickProfileImage() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: _cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: _borderColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Change Profile Photo',
                style: TextStyle(
                  color: _textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: _primaryColor,
                  ),
                ),
                title: const Text(
                  'Take Photo',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: _textPrimary,
                  ),
                ),
                onTap: () => Navigator.pop(ctx, 'camera'),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _accentBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.photo_library_rounded,
                    color: _accentBlue,
                  ),
                ),
                title: const Text(
                  'Choose from Gallery',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: _textPrimary,
                  ),
                ),
                onTap: () => Navigator.pop(ctx, 'gallery'),
              ),
              if (_profileImageUrl != null) ...[
                const SizedBox(height: 8),
                ListTile(
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.delete_rounded,
                      color: Color(0xFFE53935),
                    ),
                  ),
                  title: const Text(
                    'Remove Photo',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFE53935),
                    ),
                  ),
                  onTap: () => Navigator.pop(ctx, 'remove'),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    if (result == null) return;

    if (result == 'remove') {
      await _removeProfileImage();
      return;
    }

    final source = result == 'camera'
        ? ImageSource.camera
        : ImageSource.gallery;

    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (picked != null) {
        await _uploadProfileImage(File(picked.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not pick image: $e'),
            backgroundColor: const Color(0xFFE53935),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthState();

    // ── Auth Guard: redirect to login if not authenticated ──
    if (!auth.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        }
      });
      return const Scaffold(
        backgroundColor: _bgColor,
        body: Center(child: CircularProgressIndicator(color: _primaryColor)),
      );
    }

    // Detect whether we can pop (i.e., page was pushed as a route)
    final canGoBack = Navigator.of(context).canPop();

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        surfaceTintColor: _bgColor,
        elevation: 0,
        leading: canGoBack
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: _textPrimary),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        automaticallyImplyLeading: false,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: _textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: SlideTransition(
            position: _slideAnim,
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Column(
                children: [
                  // ── Avatar & Name ──
                  _buildAvatarSection(auth),
                  const SizedBox(height: 28),

                  // ── Info Cards ──
                  _buildInfoCard(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: auth.userEmail,
                    color: _accentBlue,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: auth.userRole == 'Parent'
                        ? Icons.family_restroom_rounded
                        : Icons.volunteer_activism_rounded,
                    label: 'Role',
                    value: auth.userRole,
                    color: _secondaryColor,
                  ),
                  const SizedBox(height: 28),

                  // ── Stats Section ──
                  _buildStatsSection(auth),
                  const SizedBox(height: 28),

                  // ── Quick Actions ──
                  _buildQuickActions(),
                  const SizedBox(height: 28),

                  // ── Logout Button ──
                  if (auth.isLoggedIn) ...[
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: _handleLogout,
                        icon: const Icon(Icons.logout_rounded, size: 20),
                        label: const Text(
                          'Log Out',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFE53935),
                          side: const BorderSide(
                            color: Color(0xFFE53935),
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection(AuthState auth) {
    return Column(
      children: [
        GestureDetector(
          onTap: _isUploading ? null : _pickProfileImage,
          child: Stack(
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_primaryColor, Color(0xFFFF9A85)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _primaryColor.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: _isUploading
                    ? const Center(
                        child: SizedBox(
                          width: 36,
                          height: 36,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        ),
                      )
                    : _profileImageUrl != null
                    ? ClipOval(
                        child: Image.network(
                          _profileImageUrl!,
                          width: 110,
                          height: 110,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                    : null,
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Text(
                              auth.initials,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          auth.initials,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
              ),
              // Camera overlay badge
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _secondaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: _bgColor, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: _secondaryColor.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          auth.userName,
          style: const TextStyle(
            color: _textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: _secondaryColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                auth.userRole == 'Parent'
                    ? Icons.family_restroom_rounded
                    : Icons.volunteer_activism_rounded,
                size: 16,
                color: _secondaryColor,
              ),
              const SizedBox(width: 6),
              Text(
                auth.userRole,
                style: const TextStyle(
                  color: _secondaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _borderColor.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: _textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: _textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(AuthState auth) {
    final isParent = auth.userRole == 'Parent';
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _borderColor.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Activity',
            style: TextStyle(
              color: _textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _statTile(
                  icon: Icons.calendar_month_rounded,
                  value: isParent ? '12' : '48',
                  label: 'Bookings',
                  color: _primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _statTile(
                  icon: Icons.star_rounded,
                  value: isParent ? '8' : '4.9',
                  label: isParent ? 'Reviews' : 'Rating',
                  color: _accentYellow,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _statTile(
                  icon: Icons.favorite_rounded,
                  value: isParent ? '3' : '24',
                  label: isParent ? 'Favorites' : 'Families',
                  color: _secondaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statTile({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: _textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: _textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _borderColor.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              color: _textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          _actionRow(Icons.edit_rounded, 'Edit Profile', _accentBlue),
          _actionRow(
            Icons.notifications_outlined,
            'Notifications',
            _primaryColor,
          ),
          _actionRow(
            Icons.shield_outlined,
            'Privacy & Safety',
            _secondaryColor,
          ),
          _actionRow(
            Icons.help_outline_rounded,
            'Help & Support',
            _accentYellow,
          ),
        ],
      ),
    );
  }

  Widget _actionRow(IconData icon, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: _textSecondary,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
