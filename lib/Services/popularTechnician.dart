import 'dart:convert';
import 'package:http/http.dart' as http;

class PopularTechnicianService {
  static const String baseUrl = 'https://adminzaindev.zaindev.com.sa/popularTechnicians';

  // Fetch all popular technicians
  static Future<List<dynamic>> getAllPopularTechnicians() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load popular technicians');
    }
  }

  // Add new popular technician
  static Future<dynamic> addNewPopularTechnician(String technicianId) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'technicianId': technicianId}),
    );
    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to add popular technician');
    }
  }

  // Delete popular technician by ID
  static Future<void> deletePopularTechnician(String id) async {
    final url = Uri.parse('$baseUrl/$id');
    final response = await http.delete(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to delete popular technician');
    }
  }
}
