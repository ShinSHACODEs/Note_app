import 'package:flutter/material.dart';
import 'package:note_app/models/note_db.dart';
import 'package:note_app/models/note_model.dart';
import 'package:provider/provider.dart';

class Notepage extends StatefulWidget {
  const Notepage({super.key});

  @override
  State<Notepage> createState() => _NotepageState();
}

class _NotepageState extends State<Notepage> {
  final _formkey = GlobalKey<FormState>();
  String _newNote = "";

  void createNote() {
    showDialog(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: AlertDialog(
          content: Form(
              key: _formkey,
                child: Column(
                mainAxisSize: MainAxisSize.min,  // Corrected to MainAxisSize
                children: [
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Enter new note"),
                  ),
                  onSaved: (newValue) {
                    _newNote = newValue!;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _formkey.currentState!.save();
                    context.read<NoteDb>().addNote(_newNote);
                    _formkey.currentState!.reset();
                    Navigator.pop(context);
                  },
                  child: const Text("ADD"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final noteDatabase = context.watch<NoteDb>(); // Use watch to rebuild when notes change
    List<NoteModel> currentNotes = noteDatabase.currentNote; // Use currentNotes instead of currentNote

    return Scaffold(
      appBar: AppBar(
        title: const Text("NOTES"),
        backgroundColor: Colors.blue[200],
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNote,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: currentNotes.length,
        itemBuilder: (context, index) {
          final note = currentNotes[index];
          return ListTile(
            title: Text(note.text), // Use noteTxt instead of text (if that's the property)
          );
        },
      ),
    );
  }
}
