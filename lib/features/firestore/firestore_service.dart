import 'package:cloud_firestore/cloud_firestore.dart';

/// Generic Firestore service providing type-safe CRUD and real-time operations.
/// All collection-specific repositories delegate to this service.
class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Reference to a collection
  CollectionReference<Map<String, dynamic>> collection(String path) =>
      _firestore.collection(path);

  /// Reference to a document
  DocumentReference<Map<String, dynamic>> doc(
    String collectionPath,
    String docId,
  ) => _firestore.collection(collectionPath).doc(docId);

  // ─── Single Document Operations ────────────────────────────────────

  /// Get a single document by ID
  Future<DocumentSnapshot<Map<String, dynamic>>> getDoc(
    String collectionPath,
    String docId,
  ) {
    return doc(collectionPath, docId).get();
  }

  /// Create or merge a document
  Future<void> setDoc(
    String collectionPath,
    String docId,
    Map<String, dynamic> data, {
    bool merge = true,
  }) {
    return doc(collectionPath, docId).set(data, SetOptions(merge: merge));
  }

  /// Update specific fields on a document
  Future<void> updateDoc(
    String collectionPath,
    String docId,
    Map<String, dynamic> data,
  ) {
    return doc(collectionPath, docId).update(data);
  }

  /// Delete a document
  Future<void> deleteDoc(String collectionPath, String docId) {
    return doc(collectionPath, docId).delete();
  }

  // ─── Collection Queries ─────────────────────────────────────────────

  /// Query a collection with optional filters
  Future<QuerySnapshot<Map<String, dynamic>>> queryCollection(
    String collectionPath, {
    List<QueryFilter>? filters,
    String? orderBy,
    bool descending = false,
    int? limit,
    DocumentSnapshot? startAfter,
  }) {
    Query<Map<String, dynamic>> query = _firestore.collection(collectionPath);

    // Apply filters
    if (filters != null) {
      for (final filter in filters) {
        switch (filter.operator) {
          case FilterOp.equals:
            query = query.where(filter.field, isEqualTo: filter.value);
          case FilterOp.notEquals:
            query = query.where(filter.field, isNotEqualTo: filter.value);
          case FilterOp.lessThan:
            query = query.where(filter.field, isLessThan: filter.value);
          case FilterOp.greaterThan:
            query = query.where(filter.field, isGreaterThan: filter.value);
          case FilterOp.arrayContains:
            query = query.where(filter.field, arrayContains: filter.value);
          case FilterOp.whereIn:
            query = query.where(filter.field, whereIn: filter.value as List);
        }
      }
    }

    // Apply ordering
    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }

    // Apply cursor for pagination
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    // Apply limit
    if (limit != null) {
      query = query.limit(limit);
    }

    return query.get();
  }

  // ─── Real-Time Streams ──────────────────────────────────────────────

  /// Watch a single document for real-time updates
  Stream<DocumentSnapshot<Map<String, dynamic>>> watchDoc(
    String collectionPath,
    String docId,
  ) {
    return doc(collectionPath, docId).snapshots();
  }

  /// Watch a collection query for real-time updates
  Stream<QuerySnapshot<Map<String, dynamic>>> watchCollection(
    String collectionPath, {
    List<QueryFilter>? filters,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) {
    Query<Map<String, dynamic>> query = _firestore.collection(collectionPath);

    if (filters != null) {
      for (final filter in filters) {
        switch (filter.operator) {
          case FilterOp.equals:
            query = query.where(filter.field, isEqualTo: filter.value);
          case FilterOp.notEquals:
            query = query.where(filter.field, isNotEqualTo: filter.value);
          case FilterOp.lessThan:
            query = query.where(filter.field, isLessThan: filter.value);
          case FilterOp.greaterThan:
            query = query.where(filter.field, isGreaterThan: filter.value);
          case FilterOp.arrayContains:
            query = query.where(filter.field, arrayContains: filter.value);
          case FilterOp.whereIn:
            query = query.where(filter.field, whereIn: filter.value as List);
        }
      }
    }

    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots();
  }

  // ─── Batch & Transaction ────────────────────────────────────────────

  /// Run a Firestore transaction
  Future<T> runTransaction<T>(
    Future<T> Function(Transaction transaction) handler,
  ) {
    return _firestore.runTransaction(handler);
  }

  /// Get a write batch
  WriteBatch batch() => _firestore.batch();
}

// ─── Query Filter Helper ──────────────────────────────────────────────────

enum FilterOp {
  equals,
  notEquals,
  lessThan,
  greaterThan,
  arrayContains,
  whereIn,
}

class QueryFilter {
  final String field;
  final FilterOp operator;
  final dynamic value;

  const QueryFilter({
    required this.field,
    required this.operator,
    required this.value,
  });
}
