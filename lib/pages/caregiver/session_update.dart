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

class SessionUpdatePage extends StatefulWidget {
  final BookingModel booking;
  const SessionUpdatePage({super.key, required this.booking});

  @override
  State<SessionUpdatePage> createState() => _SessionUpdatePageState();
}

class _SessionUpdatePageState extends State<SessionUpdatePage> {
  final _noteController = TextEditingController();
  // Local activity list for UI display (mock — in production, these go to Firestore)
  final List<SessionActivity> _activities = [];
  late BookingStatus _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.booking.status;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _sendUpdate(SessionActivityType type) {
    final note = _noteController.text.trim();
    setState(() {
      _activities.add(
        SessionActivity(
          id: 'act_${DateTime.now().millisecondsSinceEpoch}',
          type: type,
          message: note.isNotEmpty ? note : null,
          caregiverId: widget.booking.caregiverId,
          timestamp: DateTime.now(),
        ),
      );
      if (type == SessionActivityType.sessionEnded) {
        _currentStatus = BookingStatus.completed;
      } else if (type == SessionActivityType.emergencySOS) {
        _currentStatus = BookingStatus.emergency;
      } else if (_currentStatus == BookingStatus.accepted) {
        _currentStatus = BookingStatus.ongoing;
      }
    });
    _noteController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          type == SessionActivityType.emergencySOS
              ? '🚨 Emergency SOS sent!'
              : 'Update sent! ✓',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: type == SessionActivityType.emergencySOS
            ? const Color(0xFFE53935)
            : _secondaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
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
          'Session Updates',
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
            // Parent info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _borderColor.withValues(alpha: 0.2),
                    blurRadius: 12,
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
                      color: _accentBlue.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        widget.booking.parentName[0],
                        style: const TextStyle(
                          color: _accentBlue,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.booking.parentName,
                          style: const TextStyle(
                            color: _textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          widget.booking.timeSlot,
                          style: const TextStyle(
                            color: _textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: _secondaryColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _currentStatus.label,
                      style: const TextStyle(
                        color: _secondaryColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Note field
            const Text(
              'Add a note (optional)',
              style: TextStyle(
                color: _textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(
                color: _cardColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                controller: _noteController,
                style: const TextStyle(color: _textPrimary, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'e.g., Kids are having lunch...',
                  hintStyle: TextStyle(
                    color: _textSecondary.withValues(alpha: 0.4),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: _borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: _borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: _primaryColor,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(14),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Activity buttons
            const Text(
              'Send Update',
              style: TextStyle(
                color: _textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            _activityButton(
              SessionActivityType.sessionStarted,
              Icons.play_circle_rounded,
              'Session Started',
              _secondaryColor,
            ),
            _activityButton(
              SessionActivityType.mealGiven,
              Icons.restaurant_rounded,
              'Meal Given',
              _primaryColor,
            ),
            _activityButton(
              SessionActivityType.napTime,
              Icons.bedtime_rounded,
              'Nap Time',
              _accentBlue,
            ),
            _activityButton(
              SessionActivityType.playTime,
              Icons.toys_rounded,
              'Play Time',
              _accentYellow,
            ),
            _activityButton(
              SessionActivityType.sessionEnded,
              Icons.stop_circle_rounded,
              'Session Ended',
              _textSecondary,
            ),
            const SizedBox(height: 24),

            // SOS Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () => _showSOSConfirmation(context),
                icon: const Icon(Icons.warning_rounded, size: 24),
                label: const Text(
                  '🚨 Emergency SOS',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935),
                  foregroundColor: Colors.white,
                  elevation: 6,
                  shadowColor: const Color(0xFFE53935).withValues(alpha: 0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Timeline of sent updates
            if (_activities.isNotEmpty) ...[
              const Text(
                'Sent Updates',
                style: TextStyle(
                  color: _textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              ..._activities.reversed.map((a) => _updateChip(a)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _activityButton(
    SessionActivityType type,
    IconData icon,
    String label,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => _sendUpdate(type),
          icon: Icon(icon, color: color, size: 20),
          label: Text(
            label,
            style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w700),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: color.withValues(alpha: 0.4), width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
            backgroundColor: color.withValues(alpha: 0.05),
          ),
        ),
      ),
    );
  }

  Widget _updateChip(SessionActivity activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(
            activity.type.label,
            style: const TextStyle(
              color: _textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const Spacer(),
          Text(
            '${activity.timestamp.hour}:${activity.timestamp.minute.toString().padLeft(2, '0')}',
            style: const TextStyle(color: _textSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }

  void _showSOSConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_rounded, color: Color(0xFFE53935), size: 28),
            SizedBox(width: 10),
            Text(
              'Emergency SOS',
              style: TextStyle(
                color: _textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        content: const Text(
          'This will immediately alert the parent and mark this booking as an emergency. Are you sure?',
          style: TextStyle(color: _textSecondary, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: _textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _sendUpdate(SessionActivityType.emergencySOS);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Send SOS',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}
