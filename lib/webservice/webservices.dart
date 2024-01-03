import 'dart:convert';
import 'dart:developer';

import 'package:ecommerce/models/category_model.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:http/http.dart' as http;
class WebSevices {

  static const imageUrl = 'https://bootcamp.cyralearnings.com/products/';
  
  /* mainUrl */
  static const  mainUrl = 'https://bootcamp.cyralearnings.com/';

  //! fetchCategory

  Future<List<CategoryModel>?> fetchCategory() async {
    try {
      final response = await http.get(Uri.parse('${mainUrl}getcategories.php'));

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

        return parsed.map<CategoryModel>((json) => CategoryModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load category');
      }
    } catch(e) {
      log(e.toString());
    }
    return null;
  }

  //! fetchProducts

  Future<List<ProductModel>?> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('${mainUrl}view_offerproducts.php'));
      if (response.statusCode == 200) {
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
        return parsed.map<ProductModel>((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch(e) {
      log(e.toString());
    }
    return null;
  }
}