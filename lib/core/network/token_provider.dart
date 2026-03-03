/// Provides the current auth token for API requests.
/// Implementations typically read from AuthLocalDataSource / secure storage.
abstract class TokenProvider {
  Future<String?> getToken();
}
