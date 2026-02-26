import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/session_model.dart';
import '../../models/emergency_model.dart';
import '../firestore/firestore_service.dart';
import '../booking/booking_repository.dart';

/// ─── Session Repository ──────────────────────────────────────────────────
/// Handles live session tracking, activity feeds, and SOS emergency triggers.
class SessionRepository {
  final FirestoreService _service;
  static const String _sessions = 'sessions';
  static const String _emergencies = 'emergencies';

  SessionRepository(this._service);

  // ─── Session CRUD ───────────────────────────────────────────────────

  /// Start a new live session for a booking
  Future<SessionModel> startSession({
    required String sessionId,
    required String bookingId,
    required String parentId,
    required String caregiverId,
  }) async {
    final session = SessionModel(
      id: sessionId,
      bookingId: bookingId,
      parentId: parentId,
      caregiverId: caregiverId,
      status: 'active',
    );

    await _service.setDoc(_sessions, sessionId, session.toMap(), merge: false);

    // Post the first activity: session started
    await postActivity(
      sessionId: sessionId,
      activity: SessionActivity(
        id: '${sessionId}_start',
        type: SessionActivityType.sessionStarted,
        caregiverId: caregiverId,
        timestamp: DateTime.now(),
      ),
    );

    return session;
  }

  /// End a live session
  Future<void> endSession(String sessionId, String caregiverId) async {
    await _service.updateDoc(_sessions, sessionId, {
      'status': 'completed',
      'endedAt': FieldValue.serverTimestamp(),
    });

    // Post the final activity
    await postActivity(
      sessionId: sessionId,
      activity: SessionActivity(
        id: '${sessionId}_end',
        type: SessionActivityType.sessionEnded,
        caregiverId: caregiverId,
        timestamp: DateTime.now(),
      ),
    );
  }

  /// Get a session by ID
  Future<SessionModel?> getSession(String sessionId) async {
    final doc = await _service.getDoc(_sessions, sessionId);
    if (!doc.exists) return null;
    return SessionModel.fromFirestore(doc);
  }

  // ─── Activity Feed ──────────────────────────────────────────────────

  /// Post a new activity update to a session
  Future<void> postActivity({
    required String sessionId,
    required SessionActivity activity,
  }) async {
    final activitiesPath = '$_sessions/$sessionId/activities';
    await _service.setDoc(
      activitiesPath,
      activity.id,
      activity.toMap(),
      merge: false,
    );

    // Update session's last activity timestamp and count
    await _service.updateDoc(_sessions, sessionId, {
      'lastActivityAt': FieldValue.serverTimestamp(),
      'activityCount': FieldValue.increment(1),
    });
  }

  /// Get all activities for a session (ordered chronologically)
  Future<List<SessionActivity>> getActivities(String sessionId) async {
    final snapshot = await _service.queryCollection(
      '$_sessions/$sessionId/activities',
      orderBy: 'timestamp',
      descending: false,
    );

    return snapshot.docs
        .map((doc) => SessionActivity.fromFirestore(doc))
        .toList();
  }

  // ─── Real-Time Streams ──────────────────────────────────────────────

  /// Watch a session for real-time status updates
  Stream<SessionModel?> watchSession(String sessionId) {
    return _service.watchDoc(_sessions, sessionId).map((doc) {
      if (!doc.exists) return null;
      return SessionModel.fromFirestore(doc);
    });
  }

  /// Watch all activities in a session — live feed for parents
  Stream<List<SessionActivity>> watchActivities(String sessionId) {
    return _service
        .watchCollection(
          '$_sessions/$sessionId/activities',
          orderBy: 'timestamp',
          descending: false,
        )
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => SessionActivity.fromFirestore(doc))
              .toList(),
        );
  }

  /// Watch active session for a specific booking
  Stream<SessionModel?> watchActiveSessionForBooking(String bookingId) {
    return _service
        .watchCollection(
          _sessions,
          filters: [
            QueryFilter(
              field: 'bookingId',
              operator: FilterOp.equals,
              value: bookingId,
            ),
            QueryFilter(
              field: 'status',
              operator: FilterOp.equals,
              value: 'active',
            ),
          ],
          limit: 1,
        )
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return null;
          return SessionModel.fromFirestore(snapshot.docs.first);
        });
  }

  // ─── Emergency SOS ──────────────────────────────────────────────────

  /// Trigger an emergency SOS — batch write for atomicity
  Future<EmergencyModel> triggerSOS({
    required String emergencyId,
    required String bookingId,
    required String sessionId,
    required String triggeredBy,
    required String triggerRole,
    required String reason,
  }) async {
    final emergency = EmergencyModel(
      id: emergencyId,
      bookingId: bookingId,
      sessionId: sessionId,
      triggeredBy: triggeredBy,
      triggerRole: triggerRole,
      reason: reason,
      status: 'active',
    );

    // Batch: create emergency + update session status + post SOS activity
    final batch = _service.batch();

    // 1. Create emergency document
    batch.set(_service.doc(_emergencies, emergencyId), emergency.toMap());

    // 2. Update session status to 'emergency'
    batch.update(_service.doc(_sessions, sessionId), {'status': 'emergency'});

    // 3. Post SOS activity to session feed
    final activityRef = _service
        .collection('$_sessions/$sessionId/activities')
        .doc('${sessionId}_sos');
    batch.set(activityRef, {
      'type': SessionActivityType.emergencySOS.name,
      'message': 'EMERGENCY: $reason',
      'caregiverId': triggeredBy,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await batch.commit();

    return emergency;
  }

  /// Resolve an emergency
  Future<void> resolveEmergency(String emergencyId) async {
    await _service.updateDoc(_emergencies, emergencyId, {
      'status': 'resolved',
      'resolvedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Watch active emergencies for a user
  Stream<List<EmergencyModel>> watchActiveEmergencies(String userId) {
    return _service
        .watchCollection(
          _emergencies,
          filters: [
            QueryFilter(
              field: 'triggeredBy',
              operator: FilterOp.equals,
              value: userId,
            ),
            QueryFilter(
              field: 'status',
              operator: FilterOp.equals,
              value: 'active',
            ),
          ],
        )
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => EmergencyModel.fromFirestore(doc))
              .toList(),
        );
  }
}

/// ─── Session Repository Provider ─────────────────────────────────────────
final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  return SessionRepository(ref.watch(firestoreServiceProvider));
});
