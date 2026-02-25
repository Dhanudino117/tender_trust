enum BookingStatus {
  pending,
  accepted,
  ongoing,
  completed,
  emergency,
  rejected,
}

class BookingModel {
  final String id;
  final String parentId;
  final String parentName;
  final String caregiverId;
  final String caregiverName;
  BookingStatus status;
  final DateTime date;
  final String timeSlot; // e.g. '9:00 AM – 1:00 PM'
  final double totalCost;
  final String? notes;
  final List<SessionUpdate> sessionUpdates;

  BookingModel({
    required this.id,
    required this.parentId,
    required this.parentName,
    required this.caregiverId,
    required this.caregiverName,
    this.status = BookingStatus.pending,
    required this.date,
    required this.timeSlot,
    required this.totalCost,
    this.notes,
    List<SessionUpdate>? sessionUpdates,
  }) : sessionUpdates = sessionUpdates ?? [];

  String get statusLabel {
    switch (status) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.accepted:
        return 'Accepted';
      case BookingStatus.ongoing:
        return 'Ongoing';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.emergency:
        return '⚠ Emergency';
      case BookingStatus.rejected:
        return 'Rejected';
    }
  }
}

enum SessionActivityType {
  sessionStarted,
  mealGiven,
  napTime,
  playTime,
  sessionEnded,
  emergencySOS,
}

class SessionUpdate {
  final SessionActivityType type;
  final DateTime timestamp;
  final String? note;

  const SessionUpdate({required this.type, required this.timestamp, this.note});

  String get label {
    switch (type) {
      case SessionActivityType.sessionStarted:
        return 'Session Started';
      case SessionActivityType.mealGiven:
        return 'Meal Given';
      case SessionActivityType.napTime:
        return 'Nap Time';
      case SessionActivityType.playTime:
        return 'Play Time';
      case SessionActivityType.sessionEnded:
        return 'Session Ended';
      case SessionActivityType.emergencySOS:
        return '🚨 Emergency SOS';
    }
  }
}
