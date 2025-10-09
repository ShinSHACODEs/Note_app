import 'package:isar/isar.dart';

part 'note_model.g.dart';

@collection
class NoteModel {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment
  late String text;
  
}