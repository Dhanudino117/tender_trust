import 'package:flutter/material.dart';
import '../../models/booking_model.dart';
import '../../models/session_model.dart';

const Color _primaryColor = Color(0xFFFF7E67);
const Color _secondaryColor = Color(0xFF56C6A9);
const Color _accentYellow = Color(0xFFFFD166);
const Color _accentBlue = Color(0xFF7F9CF5);
const Color _bgColor = Color(0xFFFFF9F0);
const Color _cardColor = Color(0xFFFFFFFF);
const Color _textPrimary = Color(0xFF2D3047);
const Color _textSecondary = Color(0xFF6B7280);
const Color _borderColor = Color(0xFFE8D5C4);

class ActiveSessionPage extends StatelessWidget {
  final BookingModel booking;

  /// Optional list of activities to display (from mock data or Firestore stream)
  final List<SessionActivity> activities;

  const ActiveSessionPage({
    super.key,
    required this.booking,
    this.activities = const [],
  });

  IconData _activityIcon(SessionActivityType type) {
    switch (type) {
      case SessionActivityType.sessionStarted:
        return Icons.play_circle_rounded;
      case SessionActivityType.mealGiven:
        return Icons.restaurant_rounded;
      case SessionActivityType.napTime:
        return Icons.bedtime_rounded;
      case SessionActivityType.playTime:
        return Icons.toys_rounded;
      case SessionActivityType.diaperChange:
        return Icons.child_care_rounded;
      case SessionActivityType.medication:
        return Icons.medical_services_rounded;
      case SessionActivityType.photo:
        return Icons.camera_alt_rounded;
      case SessionActivityType.note:
        return Icons.note_rounded;
      case SessionActivityType.sessionEnded:
        return Icons.stop_circle_rounded;
      case SessionActivityType.emergencySOS:
        return Icons.warning_rounded;
    }
  }

  Color _activityColor(SessionActivityType type) {
    switch (type) {
      case SessionActivityType.sessionStarted:
        return _secondaryColor;
      case SessionActivityType.mealGiven:
        return _primaryColor;
      case SessionActivityType.napTime:
        return _accentBlue;
      case SessionActivityType.playTime:
        return _accentYellow;
      case SessionActivityType.diaperChange:
        return const Color(0xFFA78BFA);
      case SessionActivityType.medication:
        return const Color(0xFF10B981);
      case SessionActivityType.photo:
        return const Color(0xFFF59E0B);
      case SessionActivityType.note:
        return _textSecondary;
      case SessionActivityType.sessionEnded:
        return _textSecondary;
      case SessionActivityType.emergencySOS:
        return const Color(0xFFE53935);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        surfaceTintColor: _bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: _textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Live Session',
          style: TextStyle(
            color: _textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Session info card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_primaryColor, Color(0xFFFF9A85)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.caregiverName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          booking.timeSlot,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      '● LIVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Activity timeline
            const Text(
              'Activity Updates',
              style: TextStyle(
                color: _textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),

            if (activities.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      Icon(
                        Icons.hourglass_empty_rounded,
                        size: 48,
                        color: _textSecondary.withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Waiting for updates...',
                        style: TextStyle(color: _textSecondary),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...activities.asMap().entries.map((entry) {
                final i = entry.key;
                final activity = entry.value;
                final isLast = i == activities.length - 1;
                return _timelineItem(activity, isLast);
              }),
          ],
        ),
      ),
    );
  }

  Widget _timelineItem(SessionActivity activity, bool isLast) {
    final color = _activityColor(activity.type);
    final icon = _activityIcon(activity.type);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline line + dot
        SizedBox(
          width: 40,
          child: Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              if (!isLast) Container(width: 2, height: 50, color: _borderColor),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Content
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: _borderColor.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      activity.type.label,
                      style: TextStyle(
                        color: color,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '${activity.timestamp.hour}:${activity.timestamp.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        color: _textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                if (activity.message != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    activity.message!,
                    style: const TextStyle(
                      color: _textSecondary,
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
