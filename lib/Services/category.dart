import 'dart:convert';
import 'package:http/http.dart' as http;

class CategoryService {
  static const String baseURL = 'https://adminzaindev.zaindev.com.sa';

  static Future<List<dynamic>> getAllCategories() async {
    final url = Uri.parse('$baseURL/categories');
    final response = await http.get(url);

          if (response.statusCode == 200) {
        final categories = jsonDecode(response.body);
        return categories;
      } else {
    throw Exception('Failed to fetch categories');
    }
  }



  static Future<dynamic> getCategory(String categoryId) async {
    final url = Uri.parse('$baseURL/categories/$categoryId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final category = jsonDecode(response.body);
      return category;
    } else {
      throw Exception('Failed to fetch category');
    }
  }

  static Future<dynamic> updateCategory(String categoryId, String name, String image) async {
    final url = Uri.parse('$baseURL/categories/$categoryId');
    final body = jsonEncode({'name': name, 'image': image});
    final headers = {'Content-Type': 'application/json'};
    final response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final updatedCategory = jsonDecode(response.body);
      return updatedCategory;
    } else {
      throw Exception('Failed to update category');
    }
  }

  static Future<void> deleteCategory(String categoryId) async {
    final url = Uri.parse('$baseURL/categories/$categoryId');
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete category');
    }
  }
}
