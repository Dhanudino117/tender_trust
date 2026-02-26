/// Base class for all typed failures in the app.
/// Use sealed class so we can exhaustively switch on failure types.
sealed class Failure {
  final String message;
  final String? code;
  const Failure(this.message, {this.code});

  @override
  String toString() => 'Failure($code): $message';
}

/// Authentication failures (login, signup, etc.)
class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code});

  factory AuthFailure.fromFirebase(String code, [String? message]) {
    switch (code) {
      case 'user-not-found':
        return const AuthFailure(
          'No account found with this email',
          code: 'user-not-found',
        );
      case 'wrong-password':
        return const AuthFailure('Incorrect password', code: 'wrong-password');
      case 'invalid-credential':
        return const AuthFailure(
          'Invalid email or password',
          code: 'invalid-credential',
        );
      case 'email-already-in-use':
        return const AuthFailure(
          'This email is already registered',
          code: 'email-already-in-use',
        );
      case 'weak-password':
        return const AuthFailure(
          'Password is too weak (min 6 characters)',
          code: 'weak-password',
        );
      case 'invalid-email':
        return const AuthFailure(
          'Please enter a valid email',
          code: 'invalid-email',
        );
      case 'too-many-requests':
        return const AuthFailure(
          'Too many attempts. Please try again later',
          code: 'too-many-requests',
        );
      case 'operation-not-allowed':
        return const AuthFailure(
          'This sign-in method is not enabled',
          code: 'operation-not-allowed',
        );
      case 'account-exists-with-different-credential':
        return const AuthFailure(
          'An account already exists with a different sign-in method',
          code: 'account-exists-with-different-credential',
        );
      default:
        return AuthFailure(message ?? 'Authentication failed', code: code);
    }
  }
}

/// Firestore read/write failures
class FirestoreFailure extends Failure {
  const FirestoreFailure(super.message, {super.code});
}

/// Network connectivity failures
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

/// Permission / authorization failures
class PermissionFailure extends Failure {
  const PermissionFailure([
    super.message = 'You do not have permission to perform this action',
  ]);
}

/// Generic unexpected failures
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'An unexpected error occurred']);
}
