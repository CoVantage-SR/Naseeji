/// A security exception thrown when validation rules or ownership assertions fail.
class SecurityException implements Exception {
  final String message;
  const SecurityException(this.message);

  @override
  String toString() => 'SecurityException: $message';
}

/// A centralized guardian enforcing access control and ownership.
/// 
/// Helps mitigate Insecure Direct Object Reference (IDOR) vulnerabilities on
/// the client/UI boundary before initiating transaction or detail operations.
class OwnershipGuard {
  /// Validate that the resource owner matches the logged-in supplier identity.
  static void validate({
    required String resourceOwnerId,
    required String currentUserId,
    String? resourceName,
  }) {
    if (resourceOwnerId != currentUserId) {
      throw SecurityException(
        'Access Denied: Ownership verification failed for ${resourceName ?? "this resource"}. IDOR Prevention triggered.',
      );
    }
  }
}



