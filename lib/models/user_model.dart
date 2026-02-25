class UserModel {
  final String id;
  final String name;
  final String email;
  final String role; // 'Parent' or 'Caregiver'
  final bool isVerified;
  final String? profileImageUrl;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.isVerified = false,
    this.profileImageUrl,
  });
}
