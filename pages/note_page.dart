import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/components/my_drawer.dart';
import 'package:note_app/components/note_tile.dart';
import 'package:note_app/models/note_db.dart';
import 'package:note_app/models/note_model.dart';
import 'package:provider/provider.dart';
import 'package:note_app/theme/theme_provider.dart';


class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final _formKey = GlobalKey<FormState>();
  String _newNote = "";

  // Function create Note
  void createNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                SizedBox(height: 20),
                ElevatedButton(
                  // User กดแล้วได้อะไร
                  onPressed: () {
                    _formKey.currentState!.save(); // save note
                    context.read<Notedb>().addNote(_newNote); // add new note
                    _formKey.currentState!.reset(); // reset form to default
                    Navigator.pop(context);
                  },
                  child: Text("ADD"), // Button ADD
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function read Note
  void readNotes() {
    context.read<Notedb>().fetchAllNote();
  }

  @override
  void initState() {
    super.initState();
    readNotes();
  }

  // Function Update Note
  void updateNote(NoteModel note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Update your note"),
                  ),
                  initialValue: note.text,
                  onSaved: (newValue) {
                    _newNote = newValue!;
                  },
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    _formKey.currentState!.save();
                    context.read<Notedb>().updateNote(note.id, _newNote);
                    _formKey.currentState!.reset();
                    Navigator.pop(context);
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

  // Function Delete Note
  void deleteNote(int id) {
    context.read<Notedb>().deleteNote(id);
  }

  @override
  Widget build(BuildContext context) {
    final noteDatabase = context.watch<Notedb>();
    List<NoteModel> currentNotes = noteDatabase.currentNote;
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
      drawer: MyDrawer(),
      body: 
      // Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     Row(
      //       children: [
      //         Text(
      //           "Dark Mode",
      //           style: Theme.of(context).textTheme.displayMedium!.copyWith(),
      //         ),
      //         CupertinoSwitch(
      //           value: Provider.of<ThemeProvider>(
      //             context,
      //             listen: false,
      //           ).isDarkMode,
      //           onChanged: (value) => Provider.of<ThemeProvider>(
      //             context,
      //             listen: false,
      //           ).toggleTheme(),
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
      Expanded(
        child: ListView.builder(
          itemCount: currentNotes.length,
          itemBuilder: (context, index) {
            final note = currentNotes[index];
            return NoteTile(
              text: note.text, 
              onEditPreses: ()=>updateNote(note), 
              onDeletePreses: ()=>deleteNote(note.id));
          },
        ),
      ),
    );
  }
}
