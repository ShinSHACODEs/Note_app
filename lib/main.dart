import 'package:flutter/material.dart';
import 'package:note_app/models/note_db.dart';
import 'package:note_app/pages/note_page.dart';
import 'package:note_app/pages/setting_page.dart';
import 'package:note_app/weatherapps/weather_pages.dart';
import 'package:provider/provider.dart';
import 'package:note_app/Theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDb.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NoteDb()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
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
      debugShowCheckedModeBanner: false,
      // ใช้ Provider สำหรับธีม
      theme: Provider.of<ThemeProvider>(context).themeData,
      // ใช้ named routes แทน home:
      initialRoute: '/',
      routes: {
        '/': (context) => const NotePage(), // หน้า Notes (หน้าแรก)
        '/settings': (context) => const SettingPage(), // หน้า Settings
        '/weather': (context) => const WeatherPages(), // หน้า Weather
      },
    );
  }
}
