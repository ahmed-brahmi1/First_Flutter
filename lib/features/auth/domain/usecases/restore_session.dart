import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Returns Right(user) if cached user and token exist; Right(null) if not; Left on error.
class RestoreSession implements UseCase<User?, NoParams> {
  final AuthRepository repository;

  RestoreSession(this.repository);

  @override
  Future<Either<Failure, User?>> call(NoParams params) async {
    try {
      final user = await repository.getCachedUser();
      final token = await repository.getCachedToken();
      final expiresAt = await repository.getCachedTokenExpiry();

      final hasValidToken = token != null && token.isNotEmpty;
      final isNotExpired = expiresAt == null ||
          DateTime.now().millisecondsSinceEpoch < expiresAt;

      if (user != null && hasValidToken && isNotExpired) {
        return Right(user);
      }
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
