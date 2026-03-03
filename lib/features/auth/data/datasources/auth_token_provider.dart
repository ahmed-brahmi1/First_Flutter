import '../../../../core/network/token_provider.dart';
import 'auth_local_datasource.dart';

/// Supplies the cached access token from [AuthLocalDataSource] for API client.
class AuthTokenProvider implements TokenProvider {
  final AuthLocalDataSource localDataSource;

  AuthTokenProvider(this.localDataSource);

  @override
  Future<String?> getToken() => localDataSource.getCachedToken();
}
