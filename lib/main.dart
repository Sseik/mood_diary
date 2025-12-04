import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Додаємо імпорт
import 'package:mood_diary/services/mood_repository.dart';
import 'firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mood_diary/bloc/mood_bloc.dart';
import 'package:mood_diary/screens/home_screen.dart';
import 'package:mood_diary/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => MoodRepository(),
      child: BlocProvider(
        create: (context) => MoodBloc(
          repository: context.read<MoodRepository>(),
        ),
        child: MaterialApp (
          debugShowCheckedModeBanner: false,
          title: 'Mood Diary',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7F00FF)),
          ),
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const HomeScreen();
              }
              return const LoginScreen();
            },
          ),
        ),
      )
    );
  }
}