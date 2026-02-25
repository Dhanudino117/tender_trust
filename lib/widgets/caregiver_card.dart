import 'package:flutter/material.dart';
import '../models/caregiver_model.dart';
import 'rating_stars.dart';

const Color _primaryColor = Color(0xFFFF7E67);
const Color _secondaryColor = Color(0xFF56C6A9);
const Color _accentYellow = Color(0xFFFFD166);
const Color _cardColor = Color(0xFFFFFFFF);
const Color _textPrimary = Color(0xFF2D3047);
const Color _textSecondary = Color(0xFF6B7280);
const Color _borderColor = Color(0xFFE8D5C4);

class CaregiverCard extends StatelessWidget {
  final CaregiverModel caregiver;
  final VoidCallback onTap;

  const CaregiverCard({
    super.key,
    required this.caregiver,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: _borderColor.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_primaryColor.withValues(alpha: 0.9), _primaryColor],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  caregiver.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          caregiver.name,
                          style: const TextStyle(
                            color: _textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (caregiver.isVerified) ...[
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.verified_rounded,
                          color: _secondaryColor,
                          size: 18,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: _textSecondary,
                        size: 14,
                      ),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          caregiver.location,
                          style: const TextStyle(
                            color: _textSecondary,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      RatingStars(rating: caregiver.rating, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        '${caregiver.rating} (${caregiver.totalReviews})',
                        style: const TextStyle(
                          color: _textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Rate & availability
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${caregiver.hourlyRate.toInt()}',
                  style: const TextStyle(
                    color: _primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Text(
                  '/hour',
                  style: TextStyle(color: _textSecondary, fontSize: 11),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: caregiver.availability == 'Available'
                        ? _secondaryColor.withValues(alpha: 0.12)
                        : _accentYellow.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    caregiver.availability,
                    style: TextStyle(
                      color: caregiver.availability == 'Available'
                          ? _secondaryColor
                          : const Color(0xFFD97706),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
