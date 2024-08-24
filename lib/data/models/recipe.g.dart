// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recipe _$RecipeFromJson(Map<String, dynamic> json) => Recipe(
      vegetarian: json['vegetarian'] as bool,
      preparationMinutes: (json['preparationMinutes'] as num?)?.toInt(),
      cookingMinutes: (json['cookingMinutes'] as num?)?.toInt(),
      aggregateLikes: (json['aggregateLikes'] as num).toInt(),
      healthScore: (json['healthScore'] as num).toInt(),
      sourceName: json['sourceName'] as String,
      extendedIngredients: (json['extendedIngredients'] as List<dynamic>)
          .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      readyInMinutes: (json['readyInMinutes'] as num).toInt(),
      servings: (json['servings'] as num).toInt(),
      sourceUrl: json['sourceUrl'] as String,
      image: json['image'] as String,
      imageType: json['imageType'] as String,
      summary: json['summary'] as String,
      cuisines:
          (json['cuisines'] as List<dynamic>).map((e) => e as String).toList(),
      dishTypes:
          (json['dishTypes'] as List<dynamic>).map((e) => e as String).toList(),
      occasions:
          (json['occasions'] as List<dynamic>).map((e) => e as String).toList(),
      instructions: json['instructions'] as String,
      analyzedInstructions: (json['analyzedInstructions'] as List<dynamic>)
          .map((e) => AnalyzedInstruction.fromJson(e as Map<String, dynamic>))
          .toList(),
      diets:
          (json['diets'] as List<dynamic>?)?.map((e) => e as String).toList(),
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
      'sourceName': instance.sourceName,
      'extendedIngredients': instance.extendedIngredients,
      'id': instance.id,
      'title': instance.title,
      'readyInMinutes': instance.readyInMinutes,
      'servings': instance.servings,
      'sourceUrl': instance.sourceUrl,
      'image': instance.image,
      'imageType': instance.imageType,
      'summary': instance.summary,
      'cuisines': instance.cuisines,
      'dishTypes': instance.dishTypes,
      'occasions': instance.occasions,
      'instructions': instance.instructions,
      'analyzedInstructions': instance.analyzedInstructions,
      'diets': instance.diets,
      'usedIngredientCount': instance.usedIngredientCount,
      'missedIngredientCount': instance.missedIngredientCount,
      'likes': instance.likes,
    };

Ingredient _$IngredientFromJson(Map<String, dynamic> json) => Ingredient(
      id: (json['id'] as num).toInt(),
      aisle: json['aisle'] as String,
      image: json['image'] as String,
      name: json['name'] as String,
      nameClean: json['nameClean'] as String,
      original: json['original'] as String,
      originalName: json['originalName'] as String,
      amount: (json['amount'] as num).toDouble(),
      unit: json['unit'] as String,
    );

Map<String, dynamic> _$IngredientToJson(Ingredient instance) =>
    <String, dynamic>{
      'id': instance.id,
      'aisle': instance.aisle,
      'image': instance.image,
      'name': instance.name,
      'nameClean': instance.nameClean,
      'original': instance.original,
      'originalName': instance.originalName,
      'amount': instance.amount,
      'unit': instance.unit,
    };

AnalyzedInstruction _$AnalyzedInstructionFromJson(Map<String, dynamic> json) =>
    AnalyzedInstruction(
      name: json['name'] as String,
      steps: (json['steps'] as List<dynamic>)
          .map((e) => Step.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AnalyzedInstructionToJson(
        AnalyzedInstruction instance) =>
    <String, dynamic>{
      'name': instance.name,
      'steps': instance.steps,
    };

Step _$StepFromJson(Map<String, dynamic> json) => Step(
      number: (json['number'] as num).toInt(),
      step: json['step'] as String,
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
          .toList(),
      equipment: (json['equipment'] as List<dynamic>)
          .map((e) => Equipment.fromJson(e as Map<String, dynamic>))
          .toList(),
      length: json['length'] == null
          ? null
          : Length.fromJson(json['length'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StepToJson(Step instance) => <String, dynamic>{
      'number': instance.number,
      'step': instance.step,
      'ingredients': instance.ingredients,
      'equipment': instance.equipment,
      'length': instance.length,
    };

Equipment _$EquipmentFromJson(Map<String, dynamic> json) => Equipment(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      localizedName: json['localizedName'] as String,
      image: json['image'] as String,
    );

Map<String, dynamic> _$EquipmentToJson(Equipment instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'localizedName': instance.localizedName,
      'image': instance.image,
    };

Length _$LengthFromJson(Map<String, dynamic> json) => Length(
      number: (json['number'] as num).toInt(),
      unit: json['unit'] as String,
    );

Map<String, dynamic> _$LengthToJson(Length instance) => <String, dynamic>{
      'number': instance.number,
      'unit': instance.unit,
    };

Tips _$TipsFromJson(Map<String, dynamic> json) => Tips(
      health:
          (json['health'] as List<dynamic>).map((e) => e as String).toList(),
      price: (json['price'] as List<dynamic>).map((e) => e as String).toList(),
      cooking:
          (json['cooking'] as List<dynamic>).map((e) => e as String).toList(),
      green: (json['green'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$TipsToJson(Tips instance) => <String, dynamic>{
      'health': instance.health,
      'price': instance.price,
      'cooking': instance.cooking,
      'green': instance.green,
    };
