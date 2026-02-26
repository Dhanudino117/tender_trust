// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a user in the TenderTrust platform.
/// Stored in Firestore at: `users/{uid}`
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String role; // 'Parent' or 'Caregiver'
  final bool isVerified;
  final String? profileImageUrl;
  final String? city;
  final String? country;
  final List<String> fcmTokens;
  final String? stripeCustomerId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    this.isVerified = false,
    this.profileImageUrl,
    this.city,
    this.country,
    this.fcmTokens = const [],
    this.stripeCustomerId,
    this.createdAt,
    this.updatedAt,
  });

  /// Create from Firestore document snapshot
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromMap(data, doc.id);
  }

  /// Create from a plain map (useful for subcollection queries)
  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String?,
      role: map['role'] as String? ?? 'Parent',
      isVerified: map['isVerified'] as bool? ?? false,
      profileImageUrl: map['profileImageUrl'] as String?,
      city: map['city'] as String?,
      country: map['country'] as String?,
      fcmTokens: List<String>.from(map['fcmTokens'] ?? []),
      stripeCustomerId: map['stripeCustomerId'] as String?,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Convert to Firestore-compatible map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'isVerified': isVerified,
      'profileImageUrl': profileImageUrl,
      'city': city,
      'country': country,
      'fcmTokens': fcmTokens,
      'stripeCustomerId': stripeCustomerId,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  /// Create a copy with specific fields changed
  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? role,
    bool? isVerified,
    String? profileImageUrl,
    String? city,
    String? country,
    List<String>? fcmTokens,
    String? stripeCustomerId,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      city: city ?? this.city,
      country: country ?? this.country,
      fcmTokens: fcmTokens ?? this.fcmTokens,
      stripeCustomerId: stripeCustomerId ?? this.stripeCustomerId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    if (parts.isNotEmpty && parts[0].isNotEmpty)
      return parts[0][0].toUpperCase();
    return '?';
  }
}
