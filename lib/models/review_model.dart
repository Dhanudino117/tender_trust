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
}
