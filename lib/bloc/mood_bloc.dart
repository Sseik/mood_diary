import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mood_diary/bloc/mood_event.dart';
import 'package:mood_diary/bloc/mood_state.dart';
import 'package:mood_diary/services/mood_repository.dart';
import 'package:mood_diary/models/mood_entry_model.dart';

class MoodBloc extends Bloc<MoodEvent, MoodState> {
  MoodRepository repository;
  StreamSubscription? subscription;
  // Hardcoded-дані
  /*final List<Map<String, dynamic>> _mockMoodData = [
    {
      "date": "Today, 2:30 PM", "emoji": "😄",
      "note": "Had a wonderful afternoon walk in the park. Feeling refreshed!", "score": "8/10"
    },
    {
      "date": "Today, 10:15 AM", "emoji": "☕️",
      "note": "Starting the day with a cup of coffee and some journaling.", "score": "7/10"
    },
    {
      "date": "Yesterday, 8:45 PM", "emoji": "😌",
      "note": "Finished a good book tonight. Feeling content and peaceful.", "score": "6/10"
    },
  ];*/

  MoodBloc({required this.repository}) : super(MoodInitial()) {
    on<LoadMoodEntriesEvent>((event, emit) async {
      emit(MoodLoading());
      subscription?.cancel();
      subscription = repository.getMoodEntries().listen((moodEntries) {
          add(MoodsUpdatedEvent(entries: moodEntries));
      });
    });

    on<MoodsUpdatedEvent>((event, emit) async {
      emit(MoodLoadSuccess(event.entries));
    });

    on<AddMoodEntryEvent>((event, emit) {
      repository.addMoodEntry(event.entry, event.localImages);
    });

    on<DeleteMoodEntryEvent>((event, emit) {
      repository.deleteMoodEntry(event.id);
    });

    on<SimulateMoodErrorEvent>((event, emit) {
      emit(MoodLoading());
      try {
        throw 'Test error for Crashlytics and BLoC';
      } catch (e) {
        emit(MoodLoadError(e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }
}