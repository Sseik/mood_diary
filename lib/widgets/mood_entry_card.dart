import 'package:flutter/material.dart';

const Color kPrimaryColor = Color(0xFF7F00FF);

class MoodEntryCard extends StatelessWidget {
  final String emoji;
  final String date;
  final String? note;
  final String score;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MoodEntryCard({
    Key? key,
    required this.emoji,
    required this.date,
    this.note,
    required this.score,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Text(date, style: TextStyle(color: Colors.grey[600])),
                const Spacer(),
                Text(
                  score,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit();
                    } else if (value == 'delete') {
                      onDelete();
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(note ?? 'No note for this entry', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}