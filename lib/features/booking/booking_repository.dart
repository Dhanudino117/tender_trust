import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/firebase_providers.dart';
import '../../models/booking_model.dart';
import '../firestore/firestore_service.dart';

/// ─── Firestore Service Provider ──────────────────────────────────────────
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService(firestore: ref.watch(firestoreProvider));
});

/// ─── Booking Repository ──────────────────────────────────────────────────
/// Handles all booking CRUD operations with real-time support.
class BookingRepository {
  final FirestoreService _service;
  static const String _collection = 'bookings';

  BookingRepository(this._service);

  /// Create a new booking
  Future<BookingModel> createBooking(BookingModel booking) async {
    await _service.setDoc(
      _collection,
      booking.id,
      booking.toMap(),
      merge: false,
    );
    return booking;
  }

  /// Get a single booking by ID
  Future<BookingModel?> getBooking(String bookingId) async {
    final doc = await _service.getDoc(_collection, bookingId);
    if (!doc.exists) return null;
    return BookingModel.fromFirestore(doc);
  }

  /// Get all bookings for a parent (paginated)
  Future<List<BookingModel>> getBookingsForParent(
    String parentId, {
    int limit = 20,
    DocumentSnapshot? startAfter,
    BookingStatus? statusFilter,
  }) async {
    final filters = [
      QueryFilter(
        field: 'parentId',
        operator: FilterOp.equals,
        value: parentId,
      ),
      if (statusFilter != null)
        QueryFilter(
          field: 'status',
          operator: FilterOp.equals,
          value: statusFilter.name,
        ),
    ];

    final snapshot = await _service.queryCollection(
      _collection,
      filters: filters,
      orderBy: 'createdAt',
      descending: true,
      limit: limit,
      startAfter: startAfter,
    );

    return snapshot.docs.map((doc) => BookingModel.fromFirestore(doc)).toList();
  }

  /// Get all bookings for a caregiver (paginated)
  Future<List<BookingModel>> getBookingsForCaregiver(
    String caregiverId, {
    int limit = 20,
    DocumentSnapshot? startAfter,
    BookingStatus? statusFilter,
  }) async {
    final filters = [
      QueryFilter(
        field: 'caregiverId',
        operator: FilterOp.equals,
        value: caregiverId,
      ),
      if (statusFilter != null)
        QueryFilter(
          field: 'status',
          operator: FilterOp.equals,
          value: statusFilter.name,
        ),
    ];

    final snapshot = await _service.queryCollection(
      _collection,
      filters: filters,
      orderBy: 'createdAt',
      descending: true,
      limit: limit,
      startAfter: startAfter,
    );

    return snapshot.docs.map((doc) => BookingModel.fromFirestore(doc)).toList();
  }

  /// Update booking status (atomic via transaction for safety)
  Future<void> updateBookingStatus(
    String bookingId,
    BookingStatus newStatus,
  ) async {
    await _service.updateDoc(_collection, bookingId, {
      'status': newStatus.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ─── Real-Time Streams ──────────────────────────────────────────────

  /// Watch a single booking for real-time status changes
  Stream<BookingModel?> watchBooking(String bookingId) {
    return _service.watchDoc(_collection, bookingId).map((doc) {
      if (!doc.exists) return null;
      return BookingModel.fromFirestore(doc);
    });
  }

  /// Watch all bookings for a parent in real-time
  Stream<List<BookingModel>> watchBookingsForParent(String parentId) {
    return _service
        .watchCollection(
          _collection,
          filters: [
            QueryFilter(
              field: 'parentId',
              operator: FilterOp.equals,
              value: parentId,
            ),
          ],
          orderBy: 'createdAt',
          descending: true,
          limit: 50,
        )
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => BookingModel.fromFirestore(doc))
              .toList(),
        );
  }

  /// Watch all bookings for a caregiver in real-time
  Stream<List<BookingModel>> watchBookingsForCaregiver(String caregiverId) {
    return _service
        .watchCollection(
          _collection,
          filters: [
            QueryFilter(
              field: 'caregiverId',
              operator: FilterOp.equals,
              value: caregiverId,
            ),
          ],
          orderBy: 'createdAt',
          descending: true,
          limit: 50,
        )
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => BookingModel.fromFirestore(doc))
              .toList(),
        );
  }

  /// Watch only active bookings (pending, accepted, ongoing)
  Stream<List<BookingModel>> watchActiveBookings(
    String userId, {
    required bool isParent,
  }) {
    final field = isParent ? 'parentId' : 'caregiverId';
    return _service
        .watchCollection(
          _collection,
          filters: [
            QueryFilter(field: field, operator: FilterOp.equals, value: userId),
            QueryFilter(
              field: 'status',
              operator: FilterOp.whereIn,
              value: ['pending', 'accepted', 'ongoing'],
            ),
          ],
          orderBy: 'date',
          descending: false,
        )
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => BookingModel.fromFirestore(doc))
              .toList(),
        );
  }
}

/// ─── Booking Repository Provider ─────────────────────────────────────────
final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return BookingRepository(ref.watch(firestoreServiceProvider));
});
