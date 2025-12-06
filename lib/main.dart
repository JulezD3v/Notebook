import 'package:flutter/material.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/note_bloc.dart';
import 'repositories/note_repository.dart';
import 'screens/notes_list_screen.dart';

//import 'firebase_options.dart'; 

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const NoteApp());
// }

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