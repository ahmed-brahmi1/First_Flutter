import '../../domain/entities/device.dart';

class DeviceModel extends Device {
  const DeviceModel({
    required super.id,
    required super.macAddress,
    required super.type,
    required super.status,
    super.ownerId,
    super.petId,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'] as String,
      macAddress: json['mac_address'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      ownerId: json['owner_id'] as String?,
      petId: json['pet_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mac_address': macAddress,
      'type': type,
      'status': status,
      if (ownerId != null) 'owner_id': ownerId,
      if (petId != null) 'pet_id': petId,
    };
  }
}
