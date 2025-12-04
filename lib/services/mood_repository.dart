import 'package:mood_diary/models/mood_entry_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class MoodRepository {
  final _auth = FirebaseAuth.instance;
  final _store = FirebaseFirestore.instance;
  final String collectionPath = 'mood_entries';

  Future<void> addMoodEntry(MoodEntry entry, [List<XFile>? images]) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    List<String> photoUrls = [];

    if (images != null && images.isNotEmpty) {
      for (var image in images) {
        String fileName = '${DateTime.now().millisecondsSinceEpoch}_${image.name}';
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('mood_photos')
            .child(currentUser.uid)
            .child(fileName);
        if (kIsWeb) {
          Uint8List imageBytes = await image.readAsBytes();
          await ref.putData(imageBytes, SettableMetadata(contentType: 'image/jpeg'));
        }
        else {
          await ref.putFile(File(image.path));
        }

        String downdloadUrl = await ref.getDownloadURL();
        photoUrls.add(downdloadUrl);
      }
    }

    final entryMap = entry.toMap();
    entryMap['userId'] = currentUser.uid;
    entryMap['photoUrls'] = photoUrls;
    await _store.collection(collectionPath).add(entryMap);
  }

  Stream<List<MoodEntry>> getMoodEntries() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return Stream.value([]);

    return _store.collection(collectionPath)
        .where('userId', isEqualTo: currentUser.uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snaphot) {
          return snaphot.docs.map((doc) {
            return MoodEntry.fromSnapshot(doc);
          }).toList();
        });
  }
  Future<void> deleteMoodEntry(String id) async {
    await _store.collection(collectionPath).doc(id).delete();
  }
}