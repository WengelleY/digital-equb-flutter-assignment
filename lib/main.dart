import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/member_provider.dart';
import 'providers/group_provider.dart';
import 'screens/intro_screen.dart';
import 'theme/ui_config.dart';

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
        theme: AppTheme.theme,
        home: const SplashScreen(),
      ),
    );
  }
}
