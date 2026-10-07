// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LessonModelAdapter extends TypeAdapter<LessonModel> {
  @override
  final int typeId = 2;

  @override
  LessonModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LessonModel(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      flashcards: (fields[3] as List).cast<FlashcardModel>(),
      isCompleted: fields[4] as bool,
      progress: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, LessonModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.flashcards)
      ..writeByte(4)
      ..write(obj.isCompleted)
      ..writeByte(5)
      ..write(obj.progress);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LessonModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
