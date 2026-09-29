import 'package:flutter/material.dart';
import 'pages/login_page.dart';

// 🟢 Global State untuk menyalakan/mematikan Dark Mode di seluruh aplikasi
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 🟢 ValueListenableBuilder akan mendengarkan perubahan pada themeNotifier
    // dan me-render ulang seluruh aplikasi saat modenya berubah
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'Culinarizz',
          debugShowCheckedModeBanner: false,
          
          // Tema Terang (Light Mode)
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
            fontFamily: 'Roboto', 
          ),
          
          // Tema Gelap (Dark Mode)
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
            fontFamily: 'Roboto',
          ),
          
          // Mode yang sedang aktif
          themeMode: currentMode,
          
          home: const LoginPage(),
        );
      },
    );
  }
}
