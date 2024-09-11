import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/note.dart';

class NoteViewmodel extends ChangeNotifier {
  List<Note> notes = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchNotes(String token) async {
    isLoading = true;
    notifyListeners();

    final response = await http.get(
      Uri.parse('${dotenv.get('BASE_URL')}notes'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    isLoading = false;
    notifyListeners();

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      notes =
          (data['data'] as List).map((post) => Note.fromJson(post)).toList();
    } else {
      final errorData = jsonDecode(response.body);
      errorMessage = errorData['message'] ?? 'Gagal mengambil data catatan';
    }
  }

  Future<void> addNote(String token, String title, String body) async {
    isLoading = true;
    notifyListeners();

    final response = await http.post(
      Uri.parse('${dotenv.get('BASE_URL')}notes'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': title,
        'body': body,
      }),
    );

    isLoading = false;
    notifyListeners();

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      notes.add(Note.fromJson(data['data']));
      notifyListeners();
    } else {
      final errorData = jsonDecode(response.body);
      errorMessage = errorData['message'] ?? 'Gagal menambahkan catatan';
    }
  }

  Future<void> updateNote(
      String token, int id, String title, String body) async {
    isLoading = true;
    notifyListeners();

    final response = await http.put(
      Uri.parse('${dotenv.get('BASE_URL')}notes/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': title,
        'body': body,
      }),
    );

    isLoading = false;
    notifyListeners();

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final updatedNote = Note.fromJson(data['data']);
      final index = notes.indexWhere((note) => note.id == id);
      if (index != -1) {
        notes[index] = updatedNote;
        notifyListeners();
      }
    } else {
      final errorData = jsonDecode(response.body);
      errorMessage = errorData['message'] ?? 'Gagal memperbarui catatan';
    }
  }

  Future<void> deleteNote(String token, int id) async {
    isLoading = true;
    notifyListeners();

    final response = await http.delete(
      Uri.parse('${dotenv.get('BASE_URL')}notes/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    isLoading = false;
    notifyListeners();

    if (response.statusCode == 204) {
      notes.removeWhere((note) => note.id == id);
      notifyListeners();
    } else {
      final errorData = jsonDecode(response.body);
      errorMessage = errorData['message'] ?? 'Gagal menghapus catatan';
    }
  }

  String? getErrorMessage() {
    return errorMessage;
  }
}
