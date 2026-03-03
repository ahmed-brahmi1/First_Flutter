import 'package:equatable/equatable.dart';

class Pet extends Equatable {
  final String id;
  final String ownerId;
  final String name;
  final String species;
  final String? breed;
  final double? weight;
  final double? calorieGoal;

  const Pet({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.species,
    this.breed,
    this.weight,
    this.calorieGoal,
  });

  @override
  List<Object?> get props => [id, ownerId, name, species, breed, weight, calorieGoal];
}
