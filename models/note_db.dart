import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:note_app/models/note_model.dart';
import 'package:path_provider/path_provider.dart';

class Notedb extends ChangeNotifier{
  static late Isar isar;

  static Future<void> initialize() async{
    final dir = await getApplicationCacheDirectory();
    isar = await Isar.openSync([NoteModelSchema], directory: dir.path);
  }
  final List<NoteModel> currentNote = [];

  Future<void> fetchAllNote() async{
    List<NoteModel> notes = await isar.noteModels.where().findAll();
    currentNote.clear();
    currentNote.addAll(notes);
    notifyListeners();
  }

  Future<void> addNote(String txtFromUser) async{
    final newNote = NoteModel()..text = txtFromUser;
    // final newNote = Notedb();
    // newNote.text = txtFromUser;
    await isar.writeTxn(() => isar.noteModels.put(newNote));
    fetchAllNote();
  }

  Future<void> updateNote(int id,String newText) async{
    final note = await isar.noteModels.get(id);
    if(note != null){
      note.text = newText;
      await isar.writeTxn(()=> isar.noteModels.put(note));
      await fetchAllNote();
    }
  }

  Future<void> deleteNote(int id) async{
    await isar.writeTxn(() => isar.noteModels.delete(id));
    await fetchAllNote();
  }
}