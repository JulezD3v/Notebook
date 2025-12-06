import 'dart:async';
import 'package:bloc/bloc.dart';
import '../repositories/note_repository.dart';
import 'note_event.dart';
import 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteRepository _noteRepository;
  StreamSubscription? _notesSubscription;

  NoteBloc(this._noteRepository) : super(NotesLoading()) {
    
    on<LoadNotes>(_onLoadNotes);
    on<NotesUpdated>(_onNotesUpdated);
    on<AddNote>(_onAddNote);
    on<UpdateNote>(_onUpdateNote);
    on<DeleteNote>(_onDeleteNote);

  
    add(LoadNotes());
  }


  void _onLoadNotes(LoadNotes event, Emitter<NoteState> emit) {
    emit(NotesLoading());
   
    _notesSubscription?.cancel();
   
    _notesSubscription = _noteRepository.getNotes().listen(
      (notes) => add(NotesUpdated(notes)),
      onError: (error) => emit(NotesLoadFailure(error.toString())),
    );
  }


  void _onNotesUpdated(NotesUpdated event, Emitter<NoteState> emit) {
    emit(NotesLoadSuccess(event.notes));
  }

 
  Future<void> _onAddNote(AddNote event, Emitter<NoteState> emit) async {
    try {
      await _noteRepository.saveNote(event.note);
    
    } catch (e) {
    
      print('Error saving note: $e');
    }
  }

 
  Future<void> _onUpdateNote(UpdateNote event, Emitter<NoteState> emit) async {
    try {
      await _noteRepository.saveNote(event.note);
    } catch (e) {
      print('Error updating note: $e');
    }
  }


  Future<void> _onDeleteNote(DeleteNote event, Emitter<NoteState> emit) async {
    try {
      await _noteRepository.deleteNote(event.noteId);
    } catch (e) {
      print('Error deleting note: $e');
    }
  }


  @override
  Future<void> close() {
    _notesSubscription?.cancel();
    return super.close();
  }
}