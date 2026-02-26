import '../../models/user_model.dart';

/// Abstract auth repository contract.
/// Defines all authentication operations the app needs.
/// Implementation lives in auth_repository_impl.dart.
abstract class AuthRepository {
  /// Stream of auth state changes. Emits null when signed out.
  Stream<UserModel?> get authStateChanges;

  /// Get the currently authenticated user, or null.
  UserModel? get currentUser;

  /// Sign in with email and password.
  Future<UserModel> signInWithEmail(String email, String password);

  /// Sign in with Google.
  Future<UserModel> signInWithGoogle();

  /// Send phone OTP for verification.
  Future<String> sendPhoneOtp(String phoneNumber);

  /// Verify phone OTP and sign in.
  Future<UserModel> verifyPhoneOtp(String verificationId, String smsCode);

  /// Create a new account with email and password.
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
  });

  /// Sign out the current user.
  Future<void> signOut();

  /// Get the role of the currently authenticated user.
  Future<String> getUserRole();

  /// Save/update the user's FCM token for push notifications.
  Future<void> saveFcmToken(String token);

  /// Create or update the user profile document in Firestore.
  Future<void> saveUserProfile(UserModel user);
}
