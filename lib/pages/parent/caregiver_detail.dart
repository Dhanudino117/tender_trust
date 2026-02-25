// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import '../../auth_state.dart';
import '../../models/caregiver_model.dart';
import '../../models/booking_model.dart';
import '../../models/review_model.dart';
import '../../data/mock_data.dart';
import '../../widgets/rating_stars.dart';

const Color _primaryColor = Color(0xFFFF7E67);
const Color _secondaryColor = Color(0xFF56C6A9);
const Color _accentYellow = Color(0xFFFFD166);
const Color _accentBlue = Color(0xFF7F9CF5);
const Color _bgColor = Color(0xFFFFF9F0);
const Color _cardColor = Color(0xFFFFFFFF);
const Color _surfaceColor = Color(0xFFFFF1DB);
const Color _textPrimary = Color(0xFF2D3047);
const Color _textSecondary = Color(0xFF6B7280);
const Color _borderColor = Color(0xFFE8D5C4);

class CaregiverDetailPage extends StatelessWidget {
  final CaregiverModel caregiver;

  const CaregiverDetailPage({super.key, required this.caregiver});

  @override
  Widget build(BuildContext context) {
    final reviews = mockReviews
        .where((r) => r.caregiverId == caregiver.id)
        .toList();

    return Scaffold(
      backgroundColor: _bgColor,
      body: CustomScrollView(
        slivers: [
          // Custom app bar with gradient
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: _primaryColor,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_primaryColor, Color(0xFFFF9A85)],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: Center(
                          child: Text(
                            caregiver.initials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            caregiver.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          if (caregiver.isVerified) ...[
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.verified_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats row
                  Row(
                    children: [
                      _statChip(
                        Icons.star_rounded,
                        '${caregiver.rating}',
                        'Rating',
                        _accentYellow,
                      ),
                      const SizedBox(width: 10),
                      _statChip(
                        Icons.work_rounded,
                        '${caregiver.experienceYears}yr',
                        'Exp.',
                        _accentBlue,
                      ),
                      const SizedBox(width: 10),
                      _statChip(
                        Icons.reviews_rounded,
                        '${caregiver.totalReviews}',
                        'Reviews',
                        _secondaryColor,
                      ),
                      const SizedBox(width: 10),
                      _statChip(
                        Icons.currency_rupee_rounded,
                        '${caregiver.hourlyRate.toInt()}',
                        '/hour',
                        _primaryColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Location
                  _sectionTitle('Location'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: _primaryColor,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        caregiver.location,
                        style: const TextStyle(
                          color: _textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // About
                  _sectionTitle('About'),
                  const SizedBox(height: 8),
                  Text(
                    caregiver.bio,
                    style: const TextStyle(
                      color: _textSecondary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Specialties
                  _sectionTitle('Specialties'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: caregiver.specialties
                        .map(
                          (s) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _accentBlue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: _accentBlue.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              s,
                              style: const TextStyle(
                                color: _accentBlue,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 24),

                  // Reviews
                  _sectionTitle('Reviews (${reviews.length})'),
                  const SizedBox(height: 12),
                  if (reviews.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'No reviews yet',
                          style: TextStyle(color: _textSecondary),
                        ),
                      ),
                    )
                  else
                    ...reviews.map((r) => _reviewCard(r)),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),

      // Book Now FAB
      floatingActionButton: AuthState().isLoggedIn
          ? FloatingActionButton.extended(
              onPressed: () => _showBookingDialog(context),
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              elevation: 6,
              icon: const Icon(Icons.calendar_today_rounded),
              label: const Text(
                'Book Now',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _statChip(IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: _textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: _textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: _textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  Widget _reviewCard(ReviewModel review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: _borderColor.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: _accentBlue.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    review.parentName[0],
                    style: const TextStyle(
                      color: _accentBlue,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.parentName,
                      style: const TextStyle(
                        color: _textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    RatingStars(rating: review.rating.toDouble(), size: 12),
                  ],
                ),
              ),
              Text(
                '${review.createdAt.day}/${review.createdAt.month}',
                style: const TextStyle(color: _textSecondary, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.comment,
            style: const TextStyle(
              color: _textSecondary,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  void _showBookingDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
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
              'Confirm Booking',
              style: TextStyle(
                color: _textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),
            _bookingInfoRow('Caregiver', caregiver.name),
            _bookingInfoRow('Rate', '₹${caregiver.hourlyRate.toInt()}/hour'),
            _bookingInfoRow('Date', 'Tomorrow'),
            _bookingInfoRow('Time', '9:00 AM – 1:00 PM'),
            _bookingInfoRow('Total', '₹${(caregiver.hourlyRate * 4).toInt()}'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  // Add mock booking
                  mockBookings.add(
                    BookingModel(
                      id: 'bk_new_${DateTime.now().millisecondsSinceEpoch}',
                      parentId: 'p1',
                      parentName: AuthState().userName,
                      caregiverId: caregiver.id,
                      caregiverName: caregiver.name,
                      status: BookingStatus.pending,
                      date: DateTime.now().add(const Duration(days: 1)),
                      timeSlot: '9:00 AM – 1:00 PM',
                      totalCost: caregiver.hourlyRate * 4,
                    ),
                  );
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Booking request sent! ✓',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      backgroundColor: _secondaryColor,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Send Booking Request',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _bookingInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: _textSecondary, fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(
              color: _textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
