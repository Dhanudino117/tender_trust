import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents an emergency SOS event triggered during a session.
/// Stored in Firestore at: `emergencies/{id}`
class EmergencyModel {
  final String id;
  final String bookingId;
  final String sessionId;
  final String triggeredBy; // uid of person who triggered
  final String triggerRole; // 'parent' or 'caregiver'
  final String reason;
  final String status; // 'active', 'resolved', 'escalated'
  final bool notifiedParent;
  final bool notifiedAdmin;
  final DateTime? createdAt;
  final DateTime? resolvedAt;

  const EmergencyModel({
    required this.id,
    required this.bookingId,
    required this.sessionId,
    required this.triggeredBy,
    required this.triggerRole,
    required this.reason,
    this.status = 'active',
    this.notifiedParent = false,
    this.notifiedAdmin = false,
    this.createdAt,
    this.resolvedAt,
  });

  bool get isActive => status == 'active';

  factory EmergencyModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EmergencyModel.fromMap(data, doc.id);
  }

  factory EmergencyModel.fromMap(Map<String, dynamic> map, String id) {
    return EmergencyModel(
      id: id,
      bookingId: map['bookingId'] as String? ?? '',
      sessionId: map['sessionId'] as String? ?? '',
      triggeredBy: map['triggeredBy'] as String? ?? '',
      triggerRole: map['triggerRole'] as String? ?? '',
      reason: map['reason'] as String? ?? '',
      status: map['status'] as String? ?? 'active',
      notifiedParent: map['notifiedParent'] as bool? ?? false,
      notifiedAdmin: map['notifiedAdmin'] as bool? ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      resolvedAt: (map['resolvedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'sessionId': sessionId,
      'triggeredBy': triggeredBy,
      'triggerRole': triggerRole,
      'reason': reason,
      'status': status,
      'notifiedParent': notifiedParent,
      'notifiedAdmin': notifiedAdmin,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'resolvedAt': resolvedAt != null ? Timestamp.fromDate(resolvedAt!) : null,
    };
  }
}
