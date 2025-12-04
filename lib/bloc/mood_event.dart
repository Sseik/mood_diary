import 'package:mood_diary/models/mood_entry_model.dart';
import 'package:image_picker/image_picker.dart';

abstract class MoodEvent {}

class LoadMoodEntriesEvent extends MoodEvent {}

class SimulateMoodErrorEvent extends MoodEvent {}

class MoodsUpdatedEvent extends MoodEvent {
  final List<MoodEntry> entries;
  MoodsUpdatedEvent({required this.entries});
}

class AddMoodEntryEvent extends MoodEvent {
  final MoodEntry entry;
  final List<XFile>? localImages;

  AddMoodEntryEvent({
    required this.entry,
    this.localImages
  });
}

class DeleteMoodEntryEvent extends MoodEvent {
  final String id;
  DeleteMoodEntryEvent({required this.id});
}

class UpdateMoodEntryEvent extends MoodEvent {
  final MoodEntry entry;
  final List<XFile>? newImages;      // Нові фото для завантаження
  final List<String>? deletedImageUrls; // Список URL для видалення

  UpdateMoodEntryEvent({
    required this.entry,
    this.newImages,
    this.deletedImageUrls,
  });
}