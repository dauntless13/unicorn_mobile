// To parse this JSON data, do
//
//     final applyForTravelTripResponse = applyForTravelTripResponseFromJson(jsonString);

import 'dart:convert';

NotesListResponse applyForTravelTripResponseFromJson(String str) => NotesListResponse.fromJson(json.decode(str));

String applyForTravelTripResponseToJson(NotesListResponse data) => json.encode(data.toJson());

class NotesListResponse {
  bool? success;
  String? message;
  NoteData? data;

  NotesListResponse({
    this.success,
    this.message,
    this.data,
  });

  NotesListResponse copyWith({
    bool? success,
    String? message,
    NoteData? data,
  }) =>
      NotesListResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory NotesListResponse.fromJson(Map<String, dynamic> json) => NotesListResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : NoteData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class NoteData {
  String? studentName;
  int? noteCount;
  List<NoteList>? notes;

  NoteData({
    this.studentName,
    this.noteCount,
    this.notes,
  });

  NoteData copyWith({
    String? studentName,
    int? noteCount,
    List<NoteList>? notes,
  }) =>
      NoteData(
        studentName: studentName ?? this.studentName,
        noteCount: noteCount ?? this.noteCount,
        notes: notes ?? this.notes,
      );

  factory NoteData.fromJson(Map<String, dynamic> json) => NoteData(
    studentName: json["studentName"],
    noteCount: json["noteCount"],
    notes: json["notes"] == null ? [] : List<NoteList>.from(json["notes"]!.map((x) => NoteList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "studentName": studentName,
    "noteCount": noteCount,
    "notes": notes == null ? [] : List<dynamic>.from(notes!.map((x) => x.toJson())),
  };
}

class NoteList {
  String? noteId;
  DateTime? date;
  String? content;

  NoteList({
    this.noteId,
    this.date,
    this.content,
  });

  NoteList copyWith({
    String? noteId,
    DateTime? date,
    String? content,
  }) =>
      NoteList(
        noteId: noteId ?? this.noteId,
        date: date ?? this.date,
        content: content ?? this.content,
      );

  factory NoteList.fromJson(Map<String, dynamic> json) => NoteList(
    noteId: json["noteId"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    content: json["content"],
  );

  Map<String, dynamic> toJson() => {
    "noteId": noteId,
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "content": content,
  };
}
