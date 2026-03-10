import 'package:cloud_firestore/cloud_firestore.dart';

/// Booking status lifecycle:
/// pending → accepted → ongoing → completed
///                   ↘ rejected
///        ↘ cancelled
///              ongoing → emergency → completed
enum BookingStatus {
  pending,
  accepted,
  ongoing,
  completed,
  emergency,
  rejected,
  cancelled;

  String get label {
    switch (this) {
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
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  static BookingStatus fromString(String value) {
    return BookingStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => BookingStatus.pending,
    );
  }
}

/// Represents a booking between a parent and caregiver.
/// Stored in Firestore at: `bookings/{id}`
/// Immutable — status transitions happen via Cloud Functions.
class BookingModel {
  final String id;
  final String parentId;
  final String parentName;
  final String caregiverId;
  final String caregiverName;
  final BookingStatus status;
  final DateTime date;
  final String startTime;
  final String endTime;
  final int duration; // hours
  final double totalCost;
  final double platformFee;
  final double caregiverPayout;
  final String currency;
  final String? notes;
  final String? paymentId;
  final String? paymentStatus;
  final String? sessionId;
  final bool reviewEligible;
  final String? reviewId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BookingModel({
    required this.id,
    required this.parentId,
    required this.parentName,
    required this.caregiverId,
    required this.caregiverName,
    this.status = BookingStatus.pending,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.totalCost,
    this.platformFee = 0,
    this.caregiverPayout = 0,
    this.currency = 'INR',
    this.notes,
    this.paymentId,
    this.paymentStatus,
    this.sessionId,
    this.reviewEligible = false,
    this.reviewId,
    this.createdAt,
    this.updatedAt,
  });

  factory BookingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BookingModel.fromMap(data, doc.id);
  }

  factory BookingModel.fromMap(Map<String, dynamic> map, String id) {
    return BookingModel(
      id: id,
      parentId: map['parentId'] as String? ?? '',
      parentName: map['parentName'] as String? ?? '',
      caregiverId: map['caregiverId'] as String? ?? '',
      caregiverName: map['caregiverName'] as String? ?? '',
      status: BookingStatus.fromString(map['status'] as String? ?? 'pending'),
      date: (map['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      startTime: map['startTime'] as String? ?? '',
      endTime: map['endTime'] as String? ?? '',
      duration: map['duration'] as int? ?? 0,
      totalCost: (map['totalCost'] as num?)?.toDouble() ?? 0.0,
      platformFee: (map['platformFee'] as num?)?.toDouble() ?? 0.0,
      caregiverPayout: (map['caregiverPayout'] as num?)?.toDouble() ?? 0.0,
      currency: map['currency'] as String? ?? 'INR',
      notes: map['notes'] as String?,
      paymentId: map['paymentId'] as String?,
      paymentStatus: map['paymentStatus'] as String?,
      sessionId: map['sessionId'] as String?,
      reviewEligible: map['reviewEligible'] as bool? ?? false,
      reviewId: map['reviewId'] as String?,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'parentId': parentId,
      'parentName': parentName,
      'caregiverId': caregiverId,
      'caregiverName': caregiverName,
      'status': status.name,
      'date': Timestamp.fromDate(date),
      'startTime': startTime,
      'endTime': endTime,
      'duration': duration,
      'totalCost': totalCost,
      'platformFee': platformFee,
      'caregiverPayout': caregiverPayout,
      'currency': currency,
      'notes': notes,
      'paymentId': paymentId,
      'paymentStatus': paymentStatus,
      'sessionId': sessionId,
      'reviewEligible': reviewEligible,
      'reviewId': reviewId,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  BookingModel copyWith({
    BookingStatus? status,
    String? paymentId,
    String? paymentStatus,
    String? sessionId,
    bool? reviewEligible,
    String? reviewId,
    String? notes,
  }) {
    return BookingModel(
      id: id,
      parentId: parentId,
      parentName: parentName,
      caregiverId: caregiverId,
      caregiverName: caregiverName,
      status: status ?? this.status,
      date: date,
      startTime: startTime,
      endTime: endTime,
      duration: duration,
      totalCost: totalCost,
      platformFee: platformFee,
      caregiverPayout: caregiverPayout,
      currency: currency,
      notes: notes ?? this.notes,
      paymentId: paymentId ?? this.paymentId,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      sessionId: sessionId ?? this.sessionId,
      reviewEligible: reviewEligible ?? this.reviewEligible,
      reviewId: reviewId ?? this.reviewId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Legacy compatibility — timeSlot getter for existing UI
  String get timeSlot => '$startTime – $endTime';

  /// Legacy compatibility — statusLabel getter for existing UI
  String get statusLabel => status.label;
}
