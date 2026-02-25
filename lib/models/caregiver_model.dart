class CaregiverModel {
  final String id;
  final String name;
  final String email;
  final String bio;
  final String location;
  final int experienceYears;
  final double hourlyRate;
  final double rating;
  final int totalReviews;
  final bool isVerified;
  final List<String> specialties;
  final String availability; // 'Available', 'Busy', 'Offline'

  const CaregiverModel({
    required this.id,
    required this.name,
    required this.email,
    required this.bio,
    required this.location,
    required this.experienceYears,
    required this.hourlyRate,
    this.rating = 0.0,
    this.totalReviews = 0,
    this.isVerified = false,
    this.specialties = const [],
    this.availability = 'Available',
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return parts[0][0].toUpperCase();
  }
}
