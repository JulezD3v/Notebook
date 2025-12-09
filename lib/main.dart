import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/note_bloc.dart';
import 'repositories/note_repository.dart';
import 'screens/notes_list_screen.dart';
// For the dummy data
import 'DummyData/dummy.dart';
import 'dart:async';

//ENDED UP USING CLOUD_FIRESTORE

Future<void> seedDatabase() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference notesCollection = firestore.collection('notes');


  print('Seeding ${DUMMY_NOTES.length} notes...');

  for (var data in DUMMY_NOTES) {
    // 1. Convert ISO String to Dart DateTime
    final DateTime lastEdited = DateTime.parse(data['lastEdited']);
    
    // 2. Prepare data for Firestore, converting DateTime to Timestamp
    final Map<String, dynamic> firestoreData = {
      'title': data['title'],
      'content': data['content'],
      'lastEdited': Timestamp.fromDate(lastEdited), // CRITICAL: Firestore requires Timestamp
    };

    // 3. Save the document with an auto-generated ID
    await notesCollection.add(firestoreData);
  }
  
  print('Seeding complete! Data ready in Firestore.');
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const NoteApp());
}


class NoteApp extends StatelessWidget {
  const NoteApp({super.key});
   


  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => NoteRepository(),
      child: BlocProvider(
        create: (context) => NoteBloc(
          context.read<NoteRepository>(),
        ),
        child: MaterialApp(
          title: 'My Notes App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: false,
          ),
          home: const NotesListScreen(),
        ),
      ),
    );
  }
}