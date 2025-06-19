import 'package:flutter/material.dart';
import 'package:frontend/di/service_locator.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/screens/start.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupLocator();

  final authProvider = AuthProvider();
  await authProvider.tryAutoLogin();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: constants.Strings.applicationTitle,
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(constants.Colors.orange),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(
              const Color(constants.Colors.orange),
            ),
            foregroundColor: WidgetStateProperty.all<Color>(
              const Color(constants.Colors.grey),
            ),
            padding: WidgetStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(
                horizontal: constants.Properties.buttonPadding,
              ),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all<Color>(
              const Color(constants.Colors.blue),
            ),
            padding: WidgetStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(
                horizontal: constants.Properties.buttonPadding,
              ),
            ),
          ),
        ),
      ),
      home: const StartScreen(),
    );
  }
}
