import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/device.dart';

abstract class DeviceRepository {
  Future<Either<Failure, List<Device>>> getDevices();
  Future<Either<Failure, Device>> getDevice(String id);
  Future<Either<Failure, Device>> claimDevice(
    String deviceId,
    String activationSecret, {
    String? petId,
  });
  Future<Either<Failure, Device>> createDevice(Map<String, dynamic> body);
  Future<Either<Failure, Device>> updateDevice(String id, Map<String, dynamic> body);
  Future<Either<Failure, void>> deleteDevice(String id);
}
