import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mood_diary/bloc/mood_bloc.dart';
import 'package:mood_diary/bloc/mood_event.dart';
import 'package:mood_diary/models/mood_entry_model.dart';
import 'package:mood_diary/screens/home_screen.dart';
import 'package:mood_diary/widgets/custom_text_field.dart';
import 'package:flutter/foundation.dart';

class AddMoodScreen extends StatefulWidget {
  const AddMoodScreen({Key? key}) : super(key: key);

  @override
  State<AddMoodScreen> createState() => _AddMoodScreenState();
}

class _AddMoodScreenState extends State<AddMoodScreen> {
  double currentSliderValue = 5;
  String selectedEmoji = '😄';
  final TextEditingController noteController = TextEditingController();
  final List<String> basicEmojis = ['😠', '😢', '😐', '🙂', '😄'];
  final List<String> allEmojis = [
    '😠', '😢', '😐', '🙂', '😄',
    '😡', '😱', '😭', '🤯', '😴',
    '🤮', '🤧', '🥴', '🥳', '😎',
    '🤩', '🥰', '🤔', '🫣', '🫡'
  ];
  final imagePicker = ImagePicker();
  List<XFile> selectedImages = [];

  Future<void> pickImages() async {
    final List<XFile> images = await imagePicker.pickMultiImage();

    if(images.isNotEmpty) {
      setState(() {
        selectedImages.addAll(images);
      });
    }
  }

  void saveEntry() {
    final newEntry = MoodEntry(
        userId: '',
        date: DateTime.now(),
        emoji: selectedEmoji,
        score: currentSliderValue.round(),
        note: noteController.text,
        photoUrls: [],
    );

    context.read<MoodBloc>().add(
        AddMoodEntryEvent(
            entry: newEntry,
            localImages: selectedImages,
        )
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Entry'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(20),
              child: const Text(
                'Which emoji best describes your mood?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...basicEmojis.map((emoji) {
                  final bool isSelected = emoji == selectedEmoji;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedEmoji = emoji;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected ? kPrimaryColor.withValues(alpha: 0.2) : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Text(emoji, style: const TextStyle(fontSize: 32)),
                    )
                  );
                }),
                GestureDetector(
                  onTap: _showEmojiPicker,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle
                    ),
                    child: const Icon(Icons.add, size: 32, color: Colors.black54),
                  )
                ),
              ]
            ),

            const SizedBox(
              height: 40,
            ),

            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Intensity", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("${currentSliderValue.round()}/10", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kPrimaryColor)),
                ],
              ),
            ),
            Slider(
              value: currentSliderValue,
              onChanged: (newValue) {
                setState(() {
                  currentSliderValue = newValue;
                },);
              },
              min: 1,
              max: 10,
              divisions: 9,

            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 20, 0, 20),
              child: const Text(
                textAlign: TextAlign.start,
                'Note',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: BoxBorder.fromBorderSide(
                  BorderSide(
                    color: Colors.black,
                  )
                ),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: TextField(
                maxLines: null,
                controller: noteController,
              ),
            ),
            if (selectedImages.isNotEmpty)
              Container(
                margin: EdgeInsets.all(20),
                child: SizedBox(
                  height: 100,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: selectedImages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: kIsWeb ?
                                      Image.network(
                                        selectedImages[index].path,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                      File(selectedImages[index].path),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                    right: 0,
                                    top: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedImages.removeAt(index);
                                        });
                                      },
                                      child: Container(
                                        color: Colors.black54,
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    )
                                ),
                              ],
                            )
                        );
                      }
                  ),
                ),
              ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: TextButton.icon(
                onPressed: pickImages,
                icon: const Icon(Icons.photo_library),
                label: const Text("Add Photos"),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: TextButton(
                  onPressed: () {
                    saveEntry();
                  },
                  child: const Text('Save Entry')
              ),
            ),
          ],
      ),
    )
    );
  }

  void _showEmojiPicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(16),
            height: 300,
            child: Column(
              children: [
                const Text('Select Mood', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Expanded(
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemCount: allEmojis.length,
                        itemBuilder: (context, index) {
                          final emoji = allEmojis[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedEmoji = emoji;
                              });
                              if (!basicEmojis.contains(selectedEmoji)) {
                                setState(() {
                                  basicEmojis.last = selectedEmoji;
                                });
                              }
                              Navigator.pop(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                emoji,
                                style: const TextStyle(
                                  fontSize: 32,
                                ),
                              ),
                            )
                          );
                        },
                    ),
                ),
              ],
            )
          );
        }
    );
  }
}