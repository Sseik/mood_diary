import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class MoodEntry {
  String? id;
  String userId;
  DateTime date;
  String emoji;
  int score;
  String? note;
  List<String>? photoUrls;

  MoodEntry({
    this.id,
    required this.userId,
    required this.date,
    required this.emoji,
    this.note,
    required this.score,
    this.photoUrls
  });

  factory MoodEntry.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MoodEntry(
        id: doc.id,
        userId: data["userId"],
        date: data["timestamp"].toDate(),
        emoji: data["emoji"],
        score: data["score"],
        photoUrls: List<String>.from(data["photoUrls"] ?? []),
        note: data["note"]
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "userId": this.userId,
      "emoji": this.emoji,
      "score": this.score,
      "note": this.note,
      "timestamp": Timestamp.fromDate(this.date),
      "photoUrls": this.photoUrls
    };
  }
}
