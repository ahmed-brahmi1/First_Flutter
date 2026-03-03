import '../../domain/entities/pet.dart';

class PetModel extends Pet {
  const PetModel({
    required super.id,
    required super.ownerId,
    required super.name,
    required super.species,
    super.breed,
    super.weight,
    super.calorieGoal,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['id'] as String,
      ownerId: json['owner_id'] as String,
      name: json['name'] as String,
      species: json['species'] as String,
      breed: json['breed'] as String?,
      weight: (json['weight'] as num?)?.toDouble(),
      calorieGoal: (json['calorie_goal'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': ownerId,
      'name': name,
      'species': species,
      if (breed != null) 'breed': breed,
      if (weight != null) 'weight': weight,
      if (calorieGoal != null) 'calorie_goal': calorieGoal,
    };
  }
}
