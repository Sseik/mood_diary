import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Імпорт flutter_bloc
import 'package:mood_diary/bloc/mood_bloc.dart';
import 'package:mood_diary/bloc/mood_event.dart';
import 'package:mood_diary/bloc/mood_state.dart';
import 'package:mood_diary/widgets/mood_entry_card.dart';
import 'package:mood_diary/screens/mood_details_screen.dart';
import 'package:mood_diary/screens/add_mood_screen.dart';

const Color kPrimaryColor = Color(0xFF7F00FF);

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<MoodBloc>().add(LoadMoodEntriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Entries"),
        actions: [
          IconButton(
            icon: const Icon(Icons.error_outline, color: Colors.red),
            tooltip: "Simulate Error",
            onPressed: () {
              context.read<MoodBloc>().add(SimulateMoodErrorEvent());
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: kPrimaryColor),
            onPressed: () {
              context.read<MoodBloc>().add(LoadMoodEntriesEvent());
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<MoodBloc, MoodState>(
        builder: (context, state) {
          if (state is MoodLoading) {
            return const Center(
              child: CircularProgressIndicator(color: kPrimaryColor),
            );
          }
          if (state is MoodLoadError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    "Error: ${state.errorMessage}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<MoodBloc>().add(LoadMoodEntriesEvent());
                    },
                    child: const Text("Retry"),
                  )
                ],
              ),
            );
          }
          if (state is MoodLoadSuccess) {
            final entries = state.moodEntries;
            if (entries.isEmpty) {
              return const Center(child: Text("No entries yet."));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = state.moodEntries[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MoodDetailsScreen(entry: entry),
                      ),
                    );
                  },
                  child: MoodEntryCard(
                    emoji: entry.emoji,
                    date: '${entry.date.day.toString().padLeft(2, '0')}/${entry.date.month.toString().padLeft(2, '0')}/${entry.date.year.toString().padLeft(2, '0')}',
                    note: entry.note,
                    score: entry.score.toString(),
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddMoodScreen(entryToEdit: entry),
                        ),
                      );
                    },
                    onDelete: () {
                      showDeleteConfirmationDialog(context, entry.id!);
                    },
                  ),
                );
              },
            );
          }

          // Початковий стан (або невідомий)
          return const Center(child: Text("Welcome! Loading data..."));
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => new AddMoodScreen(),
            )
          );
        },
        backgroundColor: kPrimaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: kPrimaryColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Statistics"),
        ],
      ),
    );
  }

  void showDeleteConfirmationDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Are you sure you want to delete this entry?'),
        actions: [
          TextButton(
              onPressed: () {
                context.read<MoodBloc>().add(DeleteMoodEntryEvent(id: id));
                Navigator.pop(ctx);
              },
              child: const Text('Yes')
          ),
          TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('No'),
          )
        ],
      ),
    );
  }
}