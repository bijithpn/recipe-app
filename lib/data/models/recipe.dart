import 'package:json_annotation/json_annotation.dart';

part 'recipe.g.dart';

@JsonSerializable()
class Recipe {
  final bool? vegetarian;
  final int? preparationMinutes;
  final int? cookingMinutes;
  final int? aggregateLikes;
  final int? healthScore;
  final double? pricePerServing;
  final int id;
  final String title;
  final String sourceName;
  final int? readyInMinutes;
  final int? servings;
  final String image;
  final String? imageType;
  final List<String>? dishTypes;
  final List<String>? diets;
  final int? usedIngredientCount;
  final int? missedIngredientCount;
  final int? likes;

  Recipe({
    this.vegetarian,
    this.preparationMinutes,
    this.cookingMinutes,
    this.aggregateLikes,
    this.healthScore,
    this.pricePerServing,
    required this.id,
    required this.title,
    this.sourceName = 'Unknown',
    this.readyInMinutes,
    this.servings,
    required this.image,
    this.imageType,
    this.dishTypes,
    this.diets,
    this.usedIngredientCount,
    this.missedIngredientCount,
    this.likes = 0,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);
  Map<String, dynamic> toJson() => _$RecipeToJson(this);

  String get imageTypeOrDefault => imageType ?? 'Not provided';
  int get preparationMinutesOrDefault => preparationMinutes ?? 20;
  int get cookingMinutesOrDefault => cookingMinutes ?? 20;
  int get aggregateLikesOrDefault => aggregateLikes ?? 0;
  int get healthScoreOrDefault => healthScore ?? 0;
  double get pricePerServingOrDefault => pricePerServing ?? 0.0;
  int get readyInMinutesOrDefault => readyInMinutes ?? 20;
  int get servingsOrDefault => servings ?? 3;
  List<String> get dishTypesOrDefault => dishTypes ?? [];
  List<String> get dietsOrDefault => diets ?? [];
  int get usedIngredientCountOrDefault => usedIngredientCount ?? 0;
  int get missedIngredientCountOrDefault => missedIngredientCount ?? 0;
  bool get vegetarianOrDefault => vegetarian ?? false;
  int get likesOrDefault => likes ?? 0;
}
