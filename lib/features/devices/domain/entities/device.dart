import 'package:equatable/equatable.dart';

class Device extends Equatable {
  final String id;
  final String macAddress;
  final String type;
  final String status; // 'unclaimed' | 'claimed'
  final String? ownerId;
  final String? petId;

  const Device({
    required this.id,
    required this.macAddress,
    required this.type,
    required this.status,
    this.ownerId,
    this.petId,
  });

  @override
  List<Object?> get props => [id, macAddress, type, status, ownerId, petId];
}
