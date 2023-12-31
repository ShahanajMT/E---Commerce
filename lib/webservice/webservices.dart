import 'dart:convert';
import 'dart:developer';

import 'package:ecommerce/models/category_model.dart';
import 'package:http/http.dart' as http;
class WebSevices {
  Future<List<CategoryModel>?> fetchCategory() async {
    try {
      final response = await http.get(Uri.parse('https://bootcamp.cyralearnings.com/getcategories.php'));

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

        return parsed.map<CategoryModel>((json) => CategoryModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load category');
      }
    } catch(e) {
      log(e.toString());
    }
  }
}