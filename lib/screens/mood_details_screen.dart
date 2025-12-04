import 'package:flutter/material.dart';
import 'package:mood_diary/models/mood_entry_model.dart';
import 'package:mood_diary/screens/full_screen_image_screen.dart';

const Color kPrimaryColor = Color(0xFF7F00FF);

class MoodDetailsScreen extends StatelessWidget {
  // Ми приймаємо дані запису як аргумент
  final MoodEntry entry;

  const MoodDetailsScreen({Key? key, required this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mood Details"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Велика іконка настрою
            Text(
              entry.emoji,
              style: const TextStyle(fontSize: 100),
            ),
            const SizedBox(height: 24),

            // Оцінка
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Intensity: ${entry.score}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Дата
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  entry.date.toString(),
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Роздільник
            const Divider(),
            const SizedBox(height: 16),

            // Заголовок нотаток
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Notes",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),

            // Текст нотатки
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                entry.note ?? 'No notes for this entry.',
                style: const TextStyle(fontSize: 18, height: 1.5),
              ),
            ),
            if (entry.photoUrls != null && entry.photoUrls!.isNotEmpty) ...[
              const SizedBox(
                  height: 24,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Photos',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12,),
              SizedBox(
                height: 150,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: entry.photoUrls!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        // 1. Обробка натискання
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScreenImageScreen(
                                imageUrl: entry.photoUrls![index],
                              ),
                            ),
                          );
                        },
                        // 2. Анімація Hero
                        child: Hero(
                          tag: entry.photoUrls![index], // Тег має бути унікальним (URL підходить)
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              entry.photoUrls![index],
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                              // ... ваші loadingBuilder та errorBuilder ...
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  width: 150, height: 150,
                                  color: Colors.grey[200],
                                  child: const Center(child: CircularProgressIndicator()),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 150, height: 150,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.broken_image, color: Colors.grey),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}