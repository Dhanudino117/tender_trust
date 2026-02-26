import 'package:cloud_firestore/cloud_firestore.dart';

/// Review left by a parent for a caregiver after a completed booking.
/// Stored in Firestore at: `caregiverProfiles/{uid}/reviews/{id}`
class ReviewModel {
  final String id;
  final String bookingId;
  final String parentId;
  final String parentName;
  final String caregiverId;
  final int rating; // 1–5
  final String comment;
  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.bookingId,
    required this.parentId,
    required this.parentName,
    required this.caregiverId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory ReviewModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReviewModel.fromMap(data, doc.id);
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map, String id) {
    return ReviewModel(
      id: id,
      bookingId: map['bookingId'] as String? ?? '',
      parentId: map['parentId'] as String? ?? '',
      parentName: map['parentName'] as String? ?? '',
      caregiverId: map['caregiverId'] as String? ?? '',
      rating: map['rating'] as int? ?? 0,
      comment: map['comment'] as String? ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'parentId': parentId,
      'parentName': parentName,
      'caregiverId': caregiverId,
      'rating': rating,
      'comment': comment,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
