import 'dart:convert';
import 'dart:developer';

import 'package:ecommerce/models/category_model.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';

class WebSevices {
  static const imageUrl = 'https://bootcamp.cyralearnings.com/products/';

  /* mainUrl */
  static const mainUrl = 'https://bootcamp.cyralearnings.com/';

  //! fetchCategory

  Future<List<CategoryModel>?> fetchCategory() async {
    try {
      final response = await http.get(Uri.parse('${mainUrl}getcategories.php'));

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

        return parsed
            .map<CategoryModel>((json) => CategoryModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load category');
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  //! fetchProducts

  Future<List<ProductModel>?> fetchProducts() async {
    try {
      final response =
          await http.get(Uri.parse('${mainUrl}view_offerproducts.php'));
      if (response.statusCode == 200) {
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
        return parsed
            .map<ProductModel>((json) => ProductModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  //! fetchCatproducts
  // Future<List<ProductModel>?> fetchCatProducts(int catid) async {
  //   try {
  //     final response = http.post(
  //       Uri.parse('${mainUrl}get_category_products.php'),
  //       body: {'catid' : catid.toString()}
  //     );
  //     log('Statuscode :' + response)
  //   } catch (e) {
  //     log(e.toString());
  //   }
  //   return null;
  // }


  Future<List<ProductModel>?> fetchCatProducts(int catid) async {
    try {
      final response =
          await http.post(Uri.parse('${mainUrl}get_category_products.php'), body: {'catid' : catid.toString()});
          log('Statuscode :${response.statusCode}');
      if (response.statusCode == 200) {
        log("catid in string");
        log("response :${response.body}");
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
        return parsed
            .map<ProductModel>((json) => ProductModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
    
  }


  //! fetchUser
  Future<UserModel?> fetchUser(String username) async {
    try {
      final response = await http.post(Uri.parse('${mainUrl}get_user.php'), body: {'username' : username});
      log('Statuscode :${response.statusCode}');
      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load fetch user!');
      }

    } catch(e) {
      log(e.toString());
    }
    return null;
  }
}
