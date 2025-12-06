import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/note_bloc.dart';
import '../../bloc/note_event.dart';
import '../../models/note.dart';

class EditNoteScreen extends StatefulWidget {
  final Note? note; // Optional note for editing

  const EditNoteScreen({super.key, this.note});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  
  void _saveNote(BuildContext context) {
    final String title = _titleController.text.trim();
    final String content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
     
      Navigator.of(context).pop();
      return;
    }

    final now = DateTime.now();

    final Note newOrUpdatedNote = Note(
     
      id: widget.note?.id ?? '',
      title: title.isNotEmpty ? title : 'Untitled Note',
      content: content,
      lastEdited: now,
    );

    
    if (widget.note == null) {
      // Create new note
      context.read<NoteBloc>().add(AddNote(newOrUpdatedNote));
    } else {
      // Update existing note
      context.read<NoteBloc>().add(UpdateNote(newOrUpdatedNote));
    }

  
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Note saved'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.note != null;
    final int wordCount = _contentController.text.split(RegExp(r'\s+')).length - (_contentController.text.trim().isEmpty ? 1 : 0);
    final String lastEditedText = isEditing 
        ? 'Last edited: ${widget.note!.lastEdited.toString().substring(0, 16)}' 
        : '';
        
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Note' : 'Create Note'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _saveNote(context), // Save and go back
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => _saveNote(context), // Save and go back
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Title Field
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Title',
                border: UnderlineInputBorder(),
                enabledBorder: UnderlineInputBorder(),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
              ),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            // Content Field
            Expanded(
              child: TextField(
                controller: _contentController,
                onChanged: (_) => setState(() {}), 
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: 'Start writing...',
                  border: InputBorder.none, 
                ),
              ),
            ),
           
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(lastEditedText, style: Theme.of(context).textTheme.bodySmall),
                  Text('Words: $wordCount', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}