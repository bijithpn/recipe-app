import 'dart:convert';
import 'package:hive/hive.dart';

part 'recipe.g.dart';

@HiveType(typeId: 0)
class RecipeDB extends HiveObject {
  @HiveField(0)
  bool vegetarian;

  @HiveField(1)
  int? preparationMinutes;

  @HiveField(2)
  int? cookingMinutes;

  @HiveField(3)
  int aggregateLikes;

  @HiveField(4)
  int healthScore;

  @HiveField(5)
  String sourceName;

  @HiveField(6)
  List<ExtendedIngredient> extendedIngredients;

  @HiveField(7)
  int id;

  @HiveField(8)
  String title;

  @HiveField(9)
  int readyInMinutes;

  @HiveField(10)
  int servings;

  @HiveField(11)
  String sourceUrl;

  @HiveField(12)
  String image;

  @HiveField(13)
  String imageType;

  @HiveField(14)
  String summary;

  @HiveField(15)
  List<String> dishTypes;

  @HiveField(16)
  String instructions;

  @HiveField(17)
  List<AnalyzedInstruction> analyzedInstructions;

  @HiveField(18)
  List<String> diets;

  @HiveField(19)
  int likes;

  RecipeDB({
    required this.vegetarian,
    this.preparationMinutes,
    this.cookingMinutes,
    required this.aggregateLikes,
    required this.healthScore,
    required this.sourceName,
    required this.extendedIngredients,
    required this.id,
    required this.title,
    required this.readyInMinutes,
    required this.servings,
    required this.sourceUrl,
    required this.image,
    required this.imageType,
    required this.summary,
    required this.dishTypes,
    required this.instructions,
    required this.analyzedInstructions,
    required this.diets,
    required this.likes,
  });

  /// Factory constructor to create a RecipeDB object from a JSON map
  factory RecipeDB.fromJson(Map<String, dynamic> json) {
    return RecipeDB(
      vegetarian: json['vegetarian'],
      preparationMinutes: json['preparationMinutes'],
      cookingMinutes: json['cookingMinutes'],
      aggregateLikes: json['aggregateLikes'],
      healthScore: json['healthScore'],
      sourceName: json['sourceName'],
      extendedIngredients: (json['extendedIngredients'] as List)
          .map((e) => ExtendedIngredient.fromJson(e))
          .toList(),
      id: json['id'],
      title: json['title'],
      readyInMinutes: json['readyInMinutes'],
      servings: json['servings'],
      sourceUrl: json['sourceUrl'],
      image: json['image'],
      imageType: json['imageType'],
      summary: json['summary'],
      dishTypes: List<String>.from(json['dishTypes']),
      instructions: json['instructions'],
      analyzedInstructions: (json['analyzedInstructions'] as List)
          .map((e) => AnalyzedInstruction.fromJson(e))
          .toList(),
      diets: List<String>.from(json['diets']),
      likes: json['likes'],
    );
  }

  /// Converts RecipeDB object to a Map<String, dynamic>
  Map<String, dynamic> toJson() {
    return {
      'vegetarian': vegetarian,
      'preparationMinutes': preparationMinutes,
      'cookingMinutes': cookingMinutes,
      'aggregateLikes': aggregateLikes,
      'healthScore': healthScore,
      'sourceName': sourceName,
      'extendedIngredients':
          extendedIngredients.map((e) => e.toJson()).toList(),
      'id': id,
      'title': title,
      'readyInMinutes': readyInMinutes,
      'servings': servings,
      'sourceUrl': sourceUrl,
      'image': image,
      'imageType': imageType,
      'summary': summary,
      'dishTypes': dishTypes,
      'instructions': instructions,
      'analyzedInstructions':
          analyzedInstructions.map((e) => e.toJson()).toList(),
      'diets': diets,
      'likes': likes,
    };
  }

  /// Converts the RecipeDB object to a pretty-printed JSON string
  String toPrettyJson() {
    return const JsonEncoder.withIndent('  ').convert(toJson());
  }
}

@HiveType(typeId: 1)
class ExtendedIngredient extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String aisle;

  @HiveField(2)
  String image;

  @HiveField(3)
  String name;

  @HiveField(4)
  String nameClean;

  @HiveField(5)
  String original;

  @HiveField(6)
  String originalName;

  @HiveField(7)
  double amount;

  @HiveField(8)
  String unit;

  ExtendedIngredient({
    required this.id,
    required this.aisle,
    required this.image,
    required this.name,
    required this.nameClean,
    required this.original,
    required this.originalName,
    required this.amount,
    required this.unit,
  });

  /// Factory constructor to create an ExtendedIngredient object from a JSON map
  factory ExtendedIngredient.fromJson(Map<String, dynamic> json) {
    return ExtendedIngredient(
      id: json['id'],
      aisle: json['aisle'],
      image: json['image'],
      name: json['name'],
      nameClean: json['nameClean'],
      original: json['original'],
      originalName: json['originalName'],
      amount: json['amount'].toDouble(),
      unit: json['unit'],
    );
  }

  /// Converts ExtendedIngredient object to a Map<String, dynamic>
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'aisle': aisle,
      'image': image,
      'name': name,
      'nameClean': nameClean,
      'original': original,
      'originalName': originalName,
      'amount': amount,
      'unit': unit,
    };
  }
}

@HiveType(typeId: 2)
class AnalyzedInstruction extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<InstructionStep> steps;

  AnalyzedInstruction({
    required this.name,
    required this.steps,
  });

  /// Factory constructor to create an AnalyzedInstruction object from a JSON map
  factory AnalyzedInstruction.fromJson(Map<String, dynamic> json) {
    return AnalyzedInstruction(
      name: json['name'],
      steps: (json['steps'] as List)
          .map((e) => InstructionStep.fromJson(e))
          .toList(),
    );
  }

  /// Converts AnalyzedInstruction object to a Map<String, dynamic>
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'steps': steps.map((e) => e.toJson()).toList(),
    };
  }
}

@HiveType(typeId: 3)
class InstructionStep extends HiveObject {
  @HiveField(0)
  int number;

  @HiveField(1)
  String step;

  @HiveField(2)
  List<Ingredient> ingredients;

  @HiveField(3)
  List<Equipment> equipment;

  InstructionStep({
    required this.number,
    required this.step,
    required this.ingredients,
    required this.equipment,
  });

  factory InstructionStep.fromJson(Map<String, dynamic> json) {
    return InstructionStep(
      number: json['number'],
      step: json['step'],
      ingredients: (json['ingredients'] as List)
          .map((e) => Ingredient.fromJson(e))
          .toList(),
      equipment: (json['equipment'] as List)
          .map((e) => Equipment.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'step': step,
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
      'equipment': equipment.map((e) => e.toJson()).toList(),
    };
  }
}

@HiveType(typeId: 4)
class Ingredient extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String image;

  Ingredient({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }
}

@HiveType(typeId: 5)
class Equipment extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String image;

  Equipment({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }
}
