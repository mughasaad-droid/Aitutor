// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flashcard_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FlashcardModelAdapter extends TypeAdapter<FlashcardModel> {
  @override
  final int typeId = 1;

  @override
  FlashcardModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FlashcardModel(
      id: fields[0] as String,
      word: fields[1] as String,
      meaning: fields[2] as String,
      exampleSentence: fields[3] as String,
      difficulty: fields[4] as String,
      category: fields[5] as String,
      isLearned: fields[6] as bool,
      reviewCount: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, FlashcardModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.word)
      ..writeByte(2)
      ..write(obj.meaning)
      ..writeByte(3)
      ..write(obj.exampleSentence)
      ..writeByte(4)
      ..write(obj.difficulty)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.isLearned)
      ..writeByte(7)
      ..write(obj.reviewCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlashcardModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
