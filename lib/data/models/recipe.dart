import 'package:json_annotation/json_annotation.dart';

part 'recipe.g.dart';

@JsonSerializable()
class Recipe {
  final bool vegetarian;
  final int? preparationMinutes;
  final int? cookingMinutes;
  final int aggregateLikes;
  final int healthScore;
  final String sourceName;
  final List<Ingredient> extendedIngredients;
  final int id;
  final String title;
  final int readyInMinutes;
  final int servings;
  final String sourceUrl;
  final String image;
  final String imageType;
  final String summary;
  final List<String> cuisines;
  final List<String> dishTypes;
  final List<String> occasions;
  final String instructions;
  final List<AnalyzedInstruction> analyzedInstructions;
  final List<String>? diets;
  final int? usedIngredientCount;
  final int? missedIngredientCount;
  final int? likes;

  Recipe({
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
    required this.cuisines,
    required this.dishTypes,
    required this.occasions,
    required this.instructions,
    required this.analyzedInstructions,
    this.diets,
    this.usedIngredientCount,
    this.missedIngredientCount,
    this.likes = 0,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        vegetarian: json['vegetarian'] as bool? ?? false,
        preparationMinutes: json['preparationMinutes'] as int?,
        cookingMinutes: json['cookingMinutes'] as int?,
        aggregateLikes: json['aggregateLikes'] as int? ?? 0,
        healthScore: json['healthScore'] as int? ?? 0,
        sourceName: json['sourceName'] as String? ?? '',
        extendedIngredients: (json['extendedIngredients'] as List<dynamic>?)
                ?.map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        id: json['id'] as int? ?? 0,
        title: json['title'] as String? ?? '',
        readyInMinutes: json['readyInMinutes'] as int? ?? 0,
        servings: json['servings'] as int? ?? 0,
        sourceUrl: json['sourceUrl'] as String? ?? '',
        image: json['image'] as String? ?? '',
        imageType: json['imageType'] as String? ?? '',
        summary: json['summary'] as String? ?? '',
        cuisines: (json['cuisines'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        dishTypes: (json['dishTypes'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        diets: (json['diets'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        occasions: (json['occasions'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        instructions: json['instructions'] as String? ?? '',
        usedIngredientCount: (json['usedIngredientCount'] as num?)?.toInt(),
        missedIngredientCount: (json['missedIngredientCount'] as num?)?.toInt(),
        likes: (json['likes'] as num?)?.toInt() ?? 0,
        analyzedInstructions: (json['analyzedInstructions'] as List<dynamic>?)
                ?.map((e) =>
                    AnalyzedInstruction.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => _$RecipeToJson(this);
}

@JsonSerializable()
class Ingredient {
  final int id;
  final String aisle;
  final String image;
  final String name;
  final String nameClean;
  final String original;
  final String originalName;
  final double amount;
  final String unit;

  Ingredient({
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

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
        id: json['id'] as int? ?? 0,
        aisle: json['aisle'] as String? ?? '',
        image: json['image'] as String? ?? '',
        name: json['name'] as String? ?? '',
        nameClean: json['nameClean'] as String? ?? '',
        original: json['original'] as String? ?? '',
        originalName: json['originalName'] as String? ?? '',
        amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
        unit: json['unit'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => _$IngredientToJson(this);
}

@JsonSerializable()
class AnalyzedInstruction {
  final String name;
  final List<Step> steps;

  AnalyzedInstruction({
    required this.name,
    required this.steps,
  });

  factory AnalyzedInstruction.fromJson(Map<String, dynamic> json) =>
      AnalyzedInstruction(
        name: json['name'] as String? ?? '',
        steps: (json['steps'] as List<dynamic>?)
                ?.map((e) => Step.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => _$AnalyzedInstructionToJson(this);
}

@JsonSerializable()
class Step {
  final int number;
  final String step;
  final List<Ingredient> ingredients;
  final List<Equipment> equipment;
  final Length? length;

  Step({
    required this.number,
    required this.step,
    required this.ingredients,
    required this.equipment,
    this.length,
  });

  factory Step.fromJson(Map<String, dynamic> json) => Step(
        number: json['number'] as int? ?? 0,
        step: json['step'] as String? ?? '',
        ingredients: (json['ingredients'] as List<dynamic>?)
                ?.map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        equipment: (json['equipment'] as List<dynamic>?)
                ?.map((e) => Equipment.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        length: json['length'] == null
            ? null
            : Length.fromJson(json['length'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => _$StepToJson(this);
}

@JsonSerializable()
class Equipment {
  final int id;
  final String name;
  final String localizedName;
  final String image;

  Equipment({
    required this.id,
    required this.name,
    required this.localizedName,
    required this.image,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) => Equipment(
        id: json['id'] as int? ?? 0,
        name: json['name'] as String? ?? '',
        localizedName: json['localizedName'] as String? ?? '',
        image: json['image'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => _$EquipmentToJson(this);
}

@JsonSerializable()
class Length {
  final int number;
  final String unit;

  Length({
    required this.number,
    required this.unit,
  });

  factory Length.fromJson(Map<String, dynamic> json) => Length(
        number: json['number'] as int? ?? 0,
        unit: json['unit'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => _$LengthToJson(this);
}

@JsonSerializable()
class Tips {
  final List<String> health;
  final List<String> price;
  final List<String> cooking;
  final List<String> green;

  Tips({
    required this.health,
    required this.price,
    required this.cooking,
    required this.green,
  });

  factory Tips.fromJson(Map<String, dynamic> json) => Tips(
        health: (json['health'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        price: (json['price'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        cooking: (json['cooking'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        green: (json['green'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => _$TipsToJson(this);
}
