//maint.dart
import 'package:flutter/material.dart';
import 'package:note_app/notepage.dart';
import 'package:provider/provider.dart';
import 'package:note_app/models/note_db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDb.initialize();

  runApp(
    ChangeNotifierProvider(
      create: (context) => NoteDb(),
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Notepage(),
    );
  }
}
