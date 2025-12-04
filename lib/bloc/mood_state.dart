import 'package:flutter/material.dart';
import 'package:mood_diary/models/mood_entry_model.dart';

// Базовий, абстрактний клас для всіх станів
@immutable
abstract class MoodState {}

// Початковий стан, коли нічого ще не сталося
class MoodInitial extends MoodState {}

// Стан завантаження (показуємо індикатор)
class MoodLoading extends MoodState {}

// Стан успішного завантаження (показуємо список)
class MoodLoadSuccess extends MoodState {
  final List<MoodEntry> moodEntries;

  MoodLoadSuccess(this.moodEntries);
}

// Стан помилки (показуємо повідомлення)
class MoodLoadError extends MoodState {
  final String errorMessage;

  MoodLoadError(this.errorMessage);
}