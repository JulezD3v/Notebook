import '../models/note.dart';

abstract class NoteEvent {}

class LoadNotes extends NoteEvent {}

class AddNote extends NoteEvent {
  final Note note;
  AddNote(this.note);
}

class UpdateNote extends NoteEvent {
  final Note note;
  UpdateNote(this.note);
}

class DeleteNote extends NoteEvent {
  final String noteId;
  DeleteNote(this.noteId);
}

class NotesUpdated extends NoteEvent {
  final List<Note> notes;
  NotesUpdated(this.notes);
}