import 'package:dartz/dartz.dart';
import '../../../../config/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/audio_repository.dart';
import '../datasources/audio_remote_datasource.dart';

class AudioRepositoryImpl implements AudioRepository {
  final AudioRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AudioRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> startTwoWayAudio() async {
    // Use mock data in demo mode
    if (AppConstants.useDemoMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      return const Right(null);
    }
    
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.startTwoWayAudio();
        return const Right(null);
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
  Future<Either<Failure, void>> sendVoiceCommand(String command) async {
    // Use mock data in demo mode
    if (AppConstants.useDemoMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      return const Right(null);
    }
    
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.sendVoiceCommand(command);
        return const Right(null);
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
  Future<Either<Failure, void>> stopAudio() async {
    // Use mock data in demo mode
    if (AppConstants.useDemoMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      return const Right(null);
    }
    
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.stopAudio();
        return const Right(null);
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
}

