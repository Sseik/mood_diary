import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  // Отримуємо екземпляр FirebaseAuth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Getter для отримання поточного користувача (якщо він є)
  User? get currentUser => _firebaseAuth.currentUser;

  // Потік (Stream) для відстеження змін стану автентифікації
  // (наприклад, коли користувач увійшов або вийшов)
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Метод для ВХОДУ (Sign In)
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Якщо сталася помилка Firebase, "перекидаємо" її далі,
      // щоб обробити на UI (показати SnackBar)
      throw e.message ?? 'An unknown error occurred';
    } catch (e) {
      throw 'An unknown error occurred';
    }
  }

  // Метод для РЕЄСТРАЦІЇ (Sign Up)
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'An unknown error occurred';
    } catch (e) {
      throw 'An unknown error occurred';
    }
  }

  // Метод для ВИХОДУ (Sign Out)
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}