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

  void readNotes(){
    context.read<NoteDb>().fetchAllNotes();
  }

  @override
  void initState(){
    super.initState();
    readNotes();
  }

void updateNote(NoteModel note) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: SingleChildScrollView(
        child: Form(
          key: _formkey,  // ใช้ _formkey ที่ประกาศไว้ใน State
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Update your note",
                ),
                initialValue: note.noteTxt,
                onSaved: (newValue) {
                  _newNote = newValue!; // เมื่อกด "UPDATE" ข้อมูลจะถูกเก็บไว้ใน _newNote
                },
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  _formkey.currentState!.save(); // ใช้ _formkey แทน formKey
                  context.read<NoteDb>().updateNotes(note.id, _newNote); // ใช้ชื่อ method ที่ถูกต้อง updateNote
                  _formkey.currentState!.reset();
                  Navigator.pop(context); // ปิด Dialog
                },
                child: const Text("UPDATE"),
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
