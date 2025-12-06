import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/note_bloc.dart';
import '../../bloc/note_state.dart';
import '../../bloc/note_event.dart';
import '../../models/note.dart';
import 'edit_note_screen.dart';

class NotesListScreen extends StatelessWidget {
  const NotesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
   
    void navigateToEditNote(BuildContext context, {Note? note}) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<NoteBloc>(),
            child: EditNoteScreen(note: note),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              
            },
          ),
        ],
      ),
      // --- BlocBuilder for UI updates ---
      body: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          if (state is NotesLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is NotesLoadFailure) {
            return Center(child: Text('Failed to load notes: ${state.error}'));
          }
          if (state is NotesLoadSuccess) {
            if (state.notes.isEmpty) {
              // Corresponds to your "Note App with Firebase-2.png"
              return const Center(
                child: Text('No notes yet. Tap the + button to create one!'),
              );
            }

            return ListView.builder(
              itemCount: state.notes.length,
              itemBuilder: (context, index) {
                final note = state.notes[index];
                return Dismissible(
                  key: ValueKey(note.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    // Show confirmation dialog or handle undo here
                    // Corresponds to your "Note App with Firebase-1.png" delete functionality
                    context.read<NoteBloc>().add(DeleteNote(note.id));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Note deleted'),
                        action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () {
               
                          },
                        ),
                      ),
                    );
                    return false; 
                  },
                  child: ListTile(
                    title: Text(note.title),
                    subtitle: Text(note.content, maxLines: 1, overflow: TextOverflow.ellipsis),
                    onTap: () => navigateToEditNote(context, note: note), 
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink(); 
        },
      ),
     
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToEditNote(context), 
        child: const Icon(Icons.add),
      ),
    );
  }
}