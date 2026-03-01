import 'package:dartz/dartz.dart';
import '../../../../config/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_mock_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final AuthMockDataSource mockDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  }) : mockDataSource = AuthMockDataSource();

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    // Use mock data source in demo mode
    if (AppConstants.useDemoMode) {
      try {
        final user = await mockDataSource.login(email, password);
        await localDataSource.cacheUser(user);
        // Cache a demo token
        await localDataSource.cacheToken('demo_token_${DateTime.now().millisecondsSinceEpoch}');
        return Right(user);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    }
    
    // Real API mode
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.login(email, password);
        await localDataSource.cacheUser(user);
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> register(
    String email,
    String password,
    String name,
  ) async {
    // Use mock data source in demo mode
    if (AppConstants.useDemoMode) {
      try {
        final user = await mockDataSource.register(email, password, name);
        await localDataSource.cacheUser(user);
        // Cache a demo token
        await localDataSource.cacheToken('demo_token_${DateTime.now().millisecondsSinceEpoch}');
        return Right(user);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    }
    
    // Real API mode
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.register(email, password, name);
        await localDataSource.cacheUser(user);
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final token = await localDataSource.getCachedToken();
      if (token != null && await networkInfo.isConnected) {
        await remoteDataSource.logout(token);
      }
      await localDataSource.clearCache();
      return const Right(null);
    } on ServerException catch (e) {
      await localDataSource.clearCache();
      return Left(ServerFailure(e.message));
    } catch (e) {
      await localDataSource.clearCache();
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
}

