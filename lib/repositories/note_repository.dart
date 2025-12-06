import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

class NoteRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'notes'; 

  
  Future<void> saveNote(Note note) async {
    final noteData = note.toJson();
    if (note.id.isEmpty) {
      // Create new note
      await _firestore.collection(_collectionName).add(noteData);
    } else {
      // Update existing note
      await _firestore.collection(_collectionName).doc(note.id).update(noteData);
    }
  }

 
  Stream<List<Note>> getNotes() {
    return _firestore
        .collection(_collectionName)
        .orderBy('lastEdited', descending: true) 
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList();
    });
  }

  // --- DELETE ---
  Future<void> deleteNote(String noteId) async {
    await _firestore.collection(_collectionName).doc(noteId).delete();
  }
}