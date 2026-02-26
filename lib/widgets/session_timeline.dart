import 'package:flutter/material.dart';
import '../models/session_model.dart';

// ─── Childcare Color Palette ──────────────────────────────────────────────
const Color _primaryColor = Color(0xFFFF7E67);
const Color _secondaryColor = Color(0xFF56C6A9);
const Color _accentYellow = Color(0xFFFFD166);
const Color _accentBlue = Color(0xFF7F9CF5);
const Color _cardColor = Color(0xFFFFFFFF);
const Color _textPrimary = Color(0xFF2D3047);
const Color _textSecondary = Color(0xFF6B7280);
const Color _borderColor = Color(0xFFE8D5C4);
const Color _sosRed = Color(0xFFE53935);

/// A vertical timeline widget that displays a list of [SessionActivity] items.
///
/// Each activity is shown as a dot + connecting line on the left, with a
/// content card on the right containing the activity label, time, and
/// optional message/photo.
///
/// Usage:
/// ```dart
/// SessionTimeline(activities: myActivities)
/// ```
class SessionTimeline extends StatelessWidget {
  /// The list of activities to display, in chronological order.
  final List<SessionActivity> activities;

  /// Optional empty state message.
  final String emptyMessage;

  /// Whether to show the timeline in reverse (newest first).
  final bool reversed;

  const SessionTimeline({
    super.key,
    required this.activities,
    this.emptyMessage = 'Waiting for updates...',
    this.reversed = false,
  });

  /// Returns the icon for a given activity type.
  static IconData activityIcon(SessionActivityType type) {
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

  /// Returns the color for a given activity type.
  static Color activityColor(SessionActivityType type) {
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
        return _sosRed;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.hourglass_empty_rounded,
                size: 48,
                color: _textSecondary.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 12),
              Text(
                emptyMessage,
                style: const TextStyle(
                  color: _textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final displayList = reversed ? activities.reversed.toList() : activities;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: displayList.asMap().entries.map((entry) {
        final i = entry.key;
        final activity = entry.value;
        final isLast = i == displayList.length - 1;
        return _TimelineItem(
          activity: activity,
          isLast: isLast,
          icon: activityIcon(activity.type),
          color: activityColor(activity.type),
        );
      }).toList(),
    );
  }
}

/// A single timeline item with a dot, connecting line, and content card.
class _TimelineItem extends StatelessWidget {
  final SessionActivity activity;
  final bool isLast;
  final IconData icon;
  final Color color;

  const _TimelineItem({
    required this.activity,
    required this.isLast,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isEmergency = activity.type == SessionActivityType.emergencySOS;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Timeline rail: dot + line ──
        SizedBox(
          width: 44,
          child: Column(
            children: [
              // Activity dot
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: isEmergency
                      ? Border.all(color: color, width: 2)
                      : null,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              // Connecting line
              if (!isLast)
                Container(
                  width: 2.5,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        color.withValues(alpha: 0.4),
                        _borderColor.withValues(alpha: 0.3),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 12),

        // ── Content card ──
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isEmergency ? color.withValues(alpha: 0.06) : _cardColor,
              borderRadius: BorderRadius.circular(14),
              border: isEmergency
                  ? Border.all(color: color.withValues(alpha: 0.3))
                  : null,
              boxShadow: [
                if (!isEmergency)
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
                // Header: label + time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        activity.type.label,
                        style: TextStyle(
                          color: color,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      _formatTime(activity.timestamp),
                      style: const TextStyle(
                        color: _textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                // Optional message
                if (activity.message != null &&
                    activity.message!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _textSecondary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.format_quote_rounded,
                          size: 14,
                          color: _textSecondary.withValues(alpha: 0.4),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            activity.message!,
                            style: const TextStyle(
                              color: _textSecondary,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Optional photo
                if (activity.photoUrl != null &&
                    activity.photoUrl!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      activity.photoUrl!,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: _textSecondary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.broken_image_rounded,
                            color: _textSecondary,
                          ),
                        ),
                      ),
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

  String _formatTime(DateTime dt) {
    final h = dt.hour;
    final m = dt.minute.toString().padLeft(2, '0');
    final period = h >= 12 ? 'PM' : 'AM';
    final hour12 = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    return '$hour12:$m $period';
  }
}
