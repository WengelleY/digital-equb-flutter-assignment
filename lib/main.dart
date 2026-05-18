import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/member_provider.dart';
import 'providers/group_provider.dart';
import 'screens/intro_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DigitalEqubApp());
}

class DigitalEqubApp extends StatelessWidget {
  const DigitalEqubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GroupProvider()),
        ChangeNotifierProvider(create: (_) => MemberProvider()),
      ],
      child: MaterialApp(
        title: 'Digital Equb',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Roboto',
          scaffoldBackgroundColor: const Color(0xFFF5DFA0),
          colorScheme: ColorScheme.light(
            primary: const Color(0xFFD4A843),
            secondary: const Color(0xFF4A7C59),
            surface: const Color(0xFFF5DFA0),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFF5DFA0),
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              fontFamily: 'Roboto',
              color: Color(0xFF2C1F0E),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
            iconTheme: IconThemeData(color: Color(0xFF2C1F0E)),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF4A7C59),
            foregroundColor: Color(0xFFFFFFFF),
            elevation: 4,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A7C59),
              foregroundColor: const Color(0xFFFFFFFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              textStyle: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFFFFFFFF).withValues(alpha: 0.7),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: const Color(0xFFD4A843).withValues(alpha: 0.4),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: const Color(0xFFD4A843).withValues(alpha: 0.4),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF4A7C59),
                width: 1.8,
              ),
            ),
            labelStyle: const TextStyle(
              fontFamily: 'Roboto',
              color: Color(0xFF5C4A2A),
            ),
            hintStyle: const TextStyle(
              fontFamily: 'Roboto',
              color: Color(0xFF8C7A5A),
            ),
          ),
          cardTheme: CardThemeData(
            color: const Color(0xFFEDD98A),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            shadowColor: const Color(0x33000000),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
