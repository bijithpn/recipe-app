import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recipe.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class RecipeDB {
  @HiveField(0)
  final bool? vegetarian;

  @HiveField(1)
  final int? preparationMinutes;

  @HiveField(2)
  final int? cookingMinutes;

  @HiveField(3)
  final int? aggregateLikes;

  @HiveField(4)
  final int? healthScore;

  @HiveField(5)
  final double? pricePerServing;

  @HiveField(6)
  final int id;

  @HiveField(7)
  final String title;

  @HiveField(8)
  final String sourceName;

  @HiveField(9)
  final int? readyInMinutes;

  @HiveField(10)
  final int? servings;

  @HiveField(11)
  final String image;

  @HiveField(12)
  final String? imageType;

  @HiveField(13)
  final List<String>? dishTypes;

  @HiveField(14)
  final int? usedIngredientCount;

  @HiveField(15)
  final int? missedIngredientCount;

  @HiveField(16)
  final int? likes;

  RecipeDB({
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
    this.usedIngredientCount,
    this.missedIngredientCount,
    this.likes = 0,
  });

  factory RecipeDB.fromJson(Map<String, dynamic> json) =>
      _$RecipeDBFromJson(json);
  Map<String, dynamic> toJson() => _$RecipeDBToJson(this);
}
