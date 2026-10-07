// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_progress_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProgressModelAdapter extends TypeAdapter<UserProgressModel> {
  @override
  final int typeId = 3;

  @override
  UserProgressModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProgressModel(
      userId: fields[0] as String,
      totalMessagesSent: fields[1] as int,
      totalWordsLearned: fields[2] as int,
      currentStreak: fields[3] as int,
      longestStreak: fields[4] as int,
      speakingScore: fields[5] as double,
      listeningScore: fields[6] as double,
      readingScore: fields[7] as double,
      writingScore: fields[8] as double,
      practiceDates: (fields[9] as List?)?.cast<DateTime>(),
      lastPracticeDate: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserProgressModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.totalMessagesSent)
      ..writeByte(2)
      ..write(obj.totalWordsLearned)
      ..writeByte(3)
      ..write(obj.currentStreak)
      ..writeByte(4)
      ..write(obj.longestStreak)
      ..writeByte(5)
      ..write(obj.speakingScore)
      ..writeByte(6)
      ..write(obj.listeningScore)
      ..writeByte(7)
      ..write(obj.readingScore)
      ..writeByte(8)
      ..write(obj.writingScore)
      ..writeByte(9)
      ..write(obj.practiceDates)
      ..writeByte(10)
      ..write(obj.lastPracticeDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProgressModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
