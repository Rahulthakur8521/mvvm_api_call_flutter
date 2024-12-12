import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../model/product_model.dart';

class PhotoService {
  static Future<List<PhotoModel>> getAllPhoto() async {
    try {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => PhotoModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load photos');
      }
    } catch (e) {
      rethrow;
    }
  }
}
