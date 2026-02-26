// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a caregiver profile in the platform.
/// Stored in Firestore at: `caregiverProfiles/{uid}`
/// Separate from users collection for efficient querying.
class CaregiverModel {
  final String id;
  final String name;
  final String email;
  final String bio;
  final String location;
  final int experienceYears;
  final double hourlyRate;
  final String currency;
  final double rating;
  final int totalReviews;
  final bool isVerified;
  final bool isActive;
  final List<String> specialties;
  final List<String> languages;
  final int completedSessions;
  final bool documentsSubmitted;
  final bool documentsApproved;
  final String availability; // 'Available', 'Busy', 'Offline'
  final DateTime? createdAt;

  const CaregiverModel({
    required this.id,
    required this.name,
    required this.email,
    required this.bio,
    required this.location,
    required this.experienceYears,
    required this.hourlyRate,
    this.currency = 'INR',
    this.rating = 0.0,
    this.totalReviews = 0,
    this.isVerified = false,
    this.isActive = true,
    this.specialties = const [],
    this.languages = const ['en'],
    this.completedSessions = 0,
    this.documentsSubmitted = false,
    this.documentsApproved = false,
    this.availability = 'Available',
    this.createdAt,
  });

  factory CaregiverModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CaregiverModel.fromMap(data, doc.id);
  }

  factory CaregiverModel.fromMap(Map<String, dynamic> map, String id) {
    return CaregiverModel(
      id: id,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      bio: map['bio'] as String? ?? '',
      location: map['location'] as String? ?? '',
      experienceYears: map['experienceYears'] as int? ?? 0,
      hourlyRate: (map['hourlyRate'] as num?)?.toDouble() ?? 0.0,
      currency: map['currency'] as String? ?? 'INR',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: map['totalReviews'] as int? ?? 0,
      isVerified: map['isVerified'] as bool? ?? false,
      isActive: map['isActive'] as bool? ?? true,
      specialties: List<String>.from(map['specialties'] ?? []),
      languages: List<String>.from(map['languages'] ?? ['en']),
      completedSessions: map['completedSessions'] as int? ?? 0,
      documentsSubmitted: map['documentsSubmitted'] as bool? ?? false,
      documentsApproved: map['documentsApproved'] as bool? ?? false,
      availability: map['availability'] as String? ?? 'Available',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'bio': bio,
      'location': location,
      'experienceYears': experienceYears,
      'hourlyRate': hourlyRate,
      'currency': currency,
      'rating': rating,
      'totalReviews': totalReviews,
      'isVerified': isVerified,
      'isActive': isActive,
      'specialties': specialties,
      'languages': languages,
      'completedSessions': completedSessions,
      'documentsSubmitted': documentsSubmitted,
      'documentsApproved': documentsApproved,
      'availability': availability,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }

  CaregiverModel copyWith({
    String? name,
    String? bio,
    String? location,
    int? experienceYears,
    double? hourlyRate,
    double? rating,
    int? totalReviews,
    bool? isVerified,
    bool? isActive,
    List<String>? specialties,
    List<String>? languages,
    int? completedSessions,
    String? availability,
  }) {
    return CaregiverModel(
      id: id,
      name: name ?? this.name,
      email: email,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      experienceYears: experienceYears ?? this.experienceYears,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      currency: currency,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
      specialties: specialties ?? this.specialties,
      languages: languages ?? this.languages,
      completedSessions: completedSessions ?? this.completedSessions,
      documentsSubmitted: documentsSubmitted,
      documentsApproved: documentsApproved,
      availability: availability ?? this.availability,
      createdAt: createdAt,
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
