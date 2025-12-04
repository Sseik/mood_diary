import 'package:flutter/material.dart';

class FullScreenImageScreen extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageScreen({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Чорний фон для фокусу на фото
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white), // Біла стрілка назад
        elevation: 0,
      ),
      body: Center(
        // InteractiveViewer дозволяє зумити і рухати картинку
        child: InteractiveViewer(
          panEnabled: true, // Дозволити перетягування
          minScale: 0.5,
          maxScale: 4.0, // Максимальний зум (4x)
          child: Hero(
            tag: imageUrl, // Цей тег має співпадати з тегом на попередньому екрані
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain, // Вписати картинку повністю
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator(color: Colors.white));
              },
            ),
          ),
        ),
      ),
    );
  }
}