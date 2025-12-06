import '../models/note.dart';

abstract class NoteState {}

class NotesLoading extends NoteState {}

class NotesLoadSuccess extends NoteState {
  final List<Note> notes;
  NotesLoadSuccess(this.notes);
}

class NotesLoadFailure extends NoteState {
  final String error;
  NotesLoadFailure(this.error);
}