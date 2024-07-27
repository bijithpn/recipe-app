// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recipe _$RecipeFromJson(Map<String, dynamic> json) => Recipe(
      vegetarian: json['vegetarian'] as bool?,
      preparationMinutes: (json['preparationMinutes'] as num?)?.toInt(),
      cookingMinutes: (json['cookingMinutes'] as num?)?.toInt(),
      aggregateLikes: (json['aggregateLikes'] as num?)?.toInt(),
      healthScore: (json['healthScore'] as num?)?.toInt(),
      pricePerServing: (json['pricePerServing'] as num?)?.toDouble(),
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      sourceName: json['sourceName'] as String? ?? 'Unknown',
      readyInMinutes: (json['readyInMinutes'] as num?)?.toInt(),
      servings: (json['servings'] as num?)?.toInt(),
      image: json['image'] as String,
      imageType: json['imageType'] as String?,
      dishTypes: (json['dishTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      usedIngredientCount: (json['usedIngredientCount'] as num?)?.toInt(),
      missedIngredientCount: (json['missedIngredientCount'] as num?)?.toInt(),
      likes: (json['likes'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$RecipeToJson(Recipe instance) => <String, dynamic>{
      'vegetarian': instance.vegetarian,
      'preparationMinutes': instance.preparationMinutes,
      'cookingMinutes': instance.cookingMinutes,
      'aggregateLikes': instance.aggregateLikes,
      'healthScore': instance.healthScore,
      'pricePerServing': instance.pricePerServing,
      'id': instance.id,
      'title': instance.title,
      'sourceName': instance.sourceName,
      'readyInMinutes': instance.readyInMinutes,
      'servings': instance.servings,
      'image': instance.image,
      'imageType': instance.imageType,
      'dishTypes': instance.dishTypes,
      'usedIngredientCount': instance.usedIngredientCount,
      'missedIngredientCount': instance.missedIngredientCount,
      'likes': instance.likes,
    };
