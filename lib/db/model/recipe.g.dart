// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecipeDBAdapter extends TypeAdapter<RecipeDB> {
  @override
  final int typeId = 0;

  @override
  RecipeDB read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecipeDB(
      vegetarian: fields[0] as bool?,
      preparationMinutes: fields[1] as int?,
      cookingMinutes: fields[2] as int?,
      aggregateLikes: fields[3] as int?,
      healthScore: fields[4] as int?,
      pricePerServing: fields[5] as double?,
      id: fields[6] as int,
      title: fields[7] as String,
      sourceName: fields[8] as String,
      readyInMinutes: fields[9] as int?,
      servings: fields[10] as int?,
      image: fields[11] as String,
      imageType: fields[12] as String?,
      dishTypes: (fields[13] as List?)?.cast<String>(),
      usedIngredientCount: fields[14] as int?,
      missedIngredientCount: fields[15] as int?,
      likes: fields[16] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, RecipeDB obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.vegetarian)
      ..writeByte(1)
      ..write(obj.preparationMinutes)
      ..writeByte(2)
      ..write(obj.cookingMinutes)
      ..writeByte(3)
      ..write(obj.aggregateLikes)
      ..writeByte(4)
      ..write(obj.healthScore)
      ..writeByte(5)
      ..write(obj.pricePerServing)
      ..writeByte(6)
      ..write(obj.id)
      ..writeByte(7)
      ..write(obj.title)
      ..writeByte(8)
      ..write(obj.sourceName)
      ..writeByte(9)
      ..write(obj.readyInMinutes)
      ..writeByte(10)
      ..write(obj.servings)
      ..writeByte(11)
      ..write(obj.image)
      ..writeByte(12)
      ..write(obj.imageType)
      ..writeByte(13)
      ..write(obj.dishTypes)
      ..writeByte(14)
      ..write(obj.usedIngredientCount)
      ..writeByte(15)
      ..write(obj.missedIngredientCount)
      ..writeByte(16)
      ..write(obj.likes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeDBAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeDB _$RecipeDBFromJson(Map<String, dynamic> json) => RecipeDB(
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

Map<String, dynamic> _$RecipeDBToJson(RecipeDB instance) => <String, dynamic>{
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
