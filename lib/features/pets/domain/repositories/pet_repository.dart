import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/pet.dart';
import 'package:smartpet/features/devices/domain/entities/device.dart';

abstract class PetRepository {
  Future<Either<Failure, List<Pet>>> getPets();
  Future<Either<Failure, Pet>> getPet(String id);
  Future<Either<Failure, Pet>> createPet(Map<String, dynamic> body);
  Future<Either<Failure, Pet>> updatePet(String id, Map<String, dynamic> body);
  Future<Either<Failure, void>> deletePet(String id);
  Future<Either<Failure, List<Device>>> getPetDevices(String petId);
  Future<Either<Failure, Device>> linkDevice(String petId, String deviceId);
  Future<Either<Failure, void>> unlinkDevice(String petId, String deviceId);
}
