import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'note.g.dart';

@JsonSerializable()
class Note {
  final String id;
  final String title;
  final String content;
  @JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp)
  final DateTime lastEdited;

  Note({
    this.id = '',
    required this.title,
    required this.content,
    required this.lastEdited,
  });

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
  Map<String, dynamic> toJson() => _$NoteToJson(this);


//FINALLY FIXED THE BUG

  // Helper for Firestore to Note conversion   
  factory Note.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Note.fromJson(data).copyWith(id: doc.id);
  }

  // Used by json_serializable for DateTime <=> Timestamp conversion
  static DateTime _timestampToDateTime(Timestamp timestamp) => timestamp.toDate();
  static Timestamp _dateTimeToTimestamp(DateTime dateTime) => Timestamp.fromDate(dateTime);

  Note copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? lastEdited,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      lastEdited: lastEdited ?? this.lastEdited,
    );
  }
}
