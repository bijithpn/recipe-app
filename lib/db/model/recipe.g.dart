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
      vegetarian: fields[0] as bool,
      preparationMinutes: fields[1] as int?,
      cookingMinutes: fields[2] as int?,
      aggregateLikes: fields[3] as int,
      healthScore: fields[4] as int,
      sourceName: fields[5] as String,
      extendedIngredients: (fields[6] as List).cast<ExtendedIngredient>(),
      id: fields[7] as int,
      title: fields[8] as String,
      readyInMinutes: fields[9] as int,
      servings: fields[10] as int,
      sourceUrl: fields[11] as String,
      image: fields[12] as String,
      imageType: fields[13] as String,
      summary: fields[14] as String,
      dishTypes: (fields[15] as List).cast<String>(),
      instructions: fields[16] as String,
      analyzedInstructions: (fields[17] as List).cast<AnalyzedInstruction>(),
      diets: (fields[18] as List).cast<String>(),
      likes: fields[19] as int,
    );
  }

  @override
  void write(BinaryWriter writer, RecipeDB obj) {
    writer
      ..writeByte(20)
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
      ..write(obj.sourceName)
      ..writeByte(6)
      ..write(obj.extendedIngredients)
      ..writeByte(7)
      ..write(obj.id)
      ..writeByte(8)
      ..write(obj.title)
      ..writeByte(9)
      ..write(obj.readyInMinutes)
      ..writeByte(10)
      ..write(obj.servings)
      ..writeByte(11)
      ..write(obj.sourceUrl)
      ..writeByte(12)
      ..write(obj.image)
      ..writeByte(13)
      ..write(obj.imageType)
      ..writeByte(14)
      ..write(obj.summary)
      ..writeByte(15)
      ..write(obj.dishTypes)
      ..writeByte(16)
      ..write(obj.instructions)
      ..writeByte(17)
      ..write(obj.analyzedInstructions)
      ..writeByte(18)
      ..write(obj.diets)
      ..writeByte(19)
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

class ExtendedIngredientAdapter extends TypeAdapter<ExtendedIngredient> {
  @override
  final int typeId = 1;

  @override
  ExtendedIngredient read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExtendedIngredient(
      id: fields[0] as int,
      aisle: fields[1] as String,
      image: fields[2] as String,
      name: fields[3] as String,
      nameClean: fields[4] as String,
      original: fields[5] as String,
      originalName: fields[6] as String,
      amount: fields[7] as double,
      unit: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ExtendedIngredient obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.aisle)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.nameClean)
      ..writeByte(5)
      ..write(obj.original)
      ..writeByte(6)
      ..write(obj.originalName)
      ..writeByte(7)
      ..write(obj.amount)
      ..writeByte(8)
      ..write(obj.unit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExtendedIngredientAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AnalyzedInstructionAdapter extends TypeAdapter<AnalyzedInstruction> {
  @override
  final int typeId = 2;

  @override
  AnalyzedInstruction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnalyzedInstruction(
      name: fields[0] as String,
      steps: (fields[1] as List).cast<InstructionStep>(),
    );
  }

  @override
  void write(BinaryWriter writer, AnalyzedInstruction obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.steps);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnalyzedInstructionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InstructionStepAdapter extends TypeAdapter<InstructionStep> {
  @override
  final int typeId = 3;

  @override
  InstructionStep read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InstructionStep(
      number: fields[0] as int,
      step: fields[1] as String,
      ingredients: (fields[2] as List).cast<Ingredient>(),
      equipment: (fields[3] as List).cast<Equipment>(),
    );
  }

  @override
  void write(BinaryWriter writer, InstructionStep obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.number)
      ..writeByte(1)
      ..write(obj.step)
      ..writeByte(2)
      ..write(obj.ingredients)
      ..writeByte(3)
      ..write(obj.equipment);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InstructionStepAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IngredientAdapter extends TypeAdapter<Ingredient> {
  @override
  final int typeId = 4;

  @override
  Ingredient read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ingredient(
      id: fields[0] as int,
      name: fields[1] as String,
      image: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Ingredient obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IngredientAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EquipmentAdapter extends TypeAdapter<Equipment> {
  @override
  final int typeId = 5;

  @override
  Equipment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Equipment(
      id: fields[0] as int,
      name: fields[1] as String,
      image: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Equipment obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EquipmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
