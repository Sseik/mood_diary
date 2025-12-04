import 'package:flutter/material.dart';
import 'package:mood_diary/screens/home_screen.dart';
import 'package:mood_diary/screens/registration_screen.dart';
import 'package:mood_diary/services/auth_repository.dart'; // Імпорт репозиторію
import 'package:mood_diary/widgets/custom_text_field.dart';
import 'package:mood_diary/widgets/primary_button.dart';

const Color kPrimaryColor = Color(0xFF7F00FF);

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // 1. Створюємо ключ для форми та екземпляр репозиторію
  final _formKey = GlobalKey<FormState>();
  final _authRepository = AuthRepository();
  bool _isLoading = false; // Для показу індикатора завантаження

  // 2. Оновлена функція входу
  Future<void> _login() async {
    // Спершу перевіряємо валідність форми
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true); // Показуємо завантаження
      try {
        // Викликаємо реальний метод входу з репозиторію
        await _authRepository.signIn(
          email: _emailController.text,
          password: _passwordController.text,
        );
        // Якщо успішно - переходимо на головний екран
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } catch (e) {
        // Якщо помилка - показуємо її користувачу
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false); // Ховаємо завантаження
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Container(
              padding: const EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              // 3. Огортаємо контент у Form
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ... (Іконка та заголовки залишаються без змін) ...
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.sentiment_satisfied_alt, color: Colors.white, size: 40),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Welcome Back",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Sign in to continue tracking your daily moods and emotions",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 32),

                    // 4. Поля з валідацією
                    CustomTextField(
                      labelText: "Email",
                      hintText: "you@example.com",
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        // Проста перевірка формату email
                        if (!value.contains('@') || !value.contains('.')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      labelText: "Password",
                      hintText: "••••••••",
                      isPassword: true,
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // 5. Кнопка входу (з індикатором завантаження)
                    _isLoading
                        ? const CircularProgressIndicator(color: kPrimaryColor)
                        : PrimaryButton(
                      text: "Sign In",
                      onPressed: _login,
                    ),
                    const SizedBox(height: 24),

                    // ... (Посилання на реєстрацію залишається без змін) ...
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const RegistrationScreen()),
                            );
                          },
                          child: const Text(
                            "Sign up",
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}