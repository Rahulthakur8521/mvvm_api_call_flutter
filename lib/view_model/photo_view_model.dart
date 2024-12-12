import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PhotoApiProvider with ChangeNotifier {
  List<Map<String, dynamic>> _photos = [];

  List<Map<String, dynamic>> get photos => _photos;

  Future<void> fetchPhotos() async {
    try {
      final response = await http.get(
          Uri.parse('https://jsonplaceholder.typicode.com/photos'));
      if (response.statusCode == 200) {
        _photos = List<Map<String, dynamic>>.from(json.decode(response.body));
        notifyListeners();
      } else {
        throw Exception('Failed to load photos');
      }
    } catch (error) {
      rethrow;
    }
  }
}