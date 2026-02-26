import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a live caregiving session.
/// Stored in Firestore at: `sessions/{id}`
/// Activities are stored in subcollection: `sessions/{id}/activities/{id}`
class SessionModel {
  final String id;
  final String bookingId;
  final String parentId;
  final String caregiverId;
  final String status; // 'active', 'completed', 'emergency'
  final DateTime? startedAt;
  final DateTime? endedAt;
  final DateTime? lastActivityAt;
  final int activityCount;

  const SessionModel({
    required this.id,
    required this.bookingId,
    required this.parentId,
    required this.caregiverId,
    this.status = 'active',
    this.startedAt,
    this.endedAt,
    this.lastActivityAt,
    this.activityCount = 0,
  });

  bool get isActive => status == 'active';
  bool get isEmergency => status == 'emergency';

  factory SessionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SessionModel.fromMap(data, doc.id);
  }

  factory SessionModel.fromMap(Map<String, dynamic> map, String id) {
    return SessionModel(
      id: id,
      bookingId: map['bookingId'] as String? ?? '',
      parentId: map['parentId'] as String? ?? '',
      caregiverId: map['caregiverId'] as String? ?? '',
      status: map['status'] as String? ?? 'active',
      startedAt: (map['startedAt'] as Timestamp?)?.toDate(),
      endedAt: (map['endedAt'] as Timestamp?)?.toDate(),
      lastActivityAt: (map['lastActivityAt'] as Timestamp?)?.toDate(),
      activityCount: map['activityCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'parentId': parentId,
      'caregiverId': caregiverId,
      'status': status,
      'startedAt': startedAt != null
          ? Timestamp.fromDate(startedAt!)
          : FieldValue.serverTimestamp(),
      'endedAt': endedAt != null ? Timestamp.fromDate(endedAt!) : null,
      'lastActivityAt': FieldValue.serverTimestamp(),
      'activityCount': activityCount,
    };
  }
}

/// Activity types for session updates
enum SessionActivityType {
  sessionStarted,
  mealGiven,
  napTime,
  playTime,
  diaperChange,
  medication,
  photo,
  note,
  sessionEnded,
  emergencySOS;

  String get label {
    switch (this) {
      case SessionActivityType.sessionStarted:
        return '🟢 Session Started';
      case SessionActivityType.mealGiven:
        return '🍽️ Meal Given';
      case SessionActivityType.napTime:
        return '😴 Nap Time';
      case SessionActivityType.playTime:
        return '🎮 Play Time';
      case SessionActivityType.diaperChange:
        return '👶 Diaper Change';
      case SessionActivityType.medication:
        return '💊 Medication';
      case SessionActivityType.photo:
        return '📸 Photo Update';
      case SessionActivityType.note:
        return '📝 Note';
      case SessionActivityType.sessionEnded:
        return '🔴 Session Ended';
      case SessionActivityType.emergencySOS:
        return '🚨 Emergency SOS';
    }
  }

  static SessionActivityType fromString(String value) {
    return SessionActivityType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => SessionActivityType.note,
    );
  }
}

/// An individual activity posted during a live session.
/// Stored in Firestore at: `sessions/{id}/activities/{id}`
class SessionActivity {
  final String id;
  final SessionActivityType type;
  final String? message;
  final String? photoUrl;
  final String caregiverId;
  final DateTime timestamp;

  const SessionActivity({
    required this.id,
    required this.type,
    this.message,
    this.photoUrl,
    required this.caregiverId,
    required this.timestamp,
  });

  factory SessionActivity.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SessionActivity.fromMap(data, doc.id);
  }

  factory SessionActivity.fromMap(Map<String, dynamic> map, String id) {
    return SessionActivity(
      id: id,
      type: SessionActivityType.fromString(map['type'] as String? ?? 'note'),
      message: map['message'] as String?,
      photoUrl: map['photoUrl'] as String?,
      caregiverId: map['caregiverId'] as String? ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'message': message,
      'photoUrl': photoUrl,
      'caregiverId': caregiverId,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}
