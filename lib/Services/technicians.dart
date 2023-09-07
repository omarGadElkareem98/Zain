import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class TechnicianService {
  static const String baseUrl = 'https://adminzaindev.zaindev.com.sa'; // Replace with your API base URL

  // Get all technicians
  static Future<List<dynamic>> getAllTechnicians({String? categoryId}) async {
    Uri ?url;
    if(categoryId == null){
      url = Uri.parse('https://adminzaindev.zaindev.com.sa/technicians');
    }else{
      url = Uri.parse('https://adminzaindev.zaindev.com.sa/technicians/?categoryId=$categoryId');
    }

    print(url);
    final response = await http.get(url);
    print('response');
    if (response.statusCode == 200) {
      final technicians = jsonDecode(response.body);
      return technicians;
    } else {
      throw Exception('Failed to fetch technicians');
    }
  }

  // Get technician by ID
  static Future<dynamic> getTechnicianById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/technicians/$id'));
    if (response.statusCode == 200) {
      final technician = jsonDecode(response.body);
      return technician;
    } else if (response.statusCode == 404) {
      throw Exception('Technician not found');
    } else {
      throw Exception('Failed to fetch technician');
    }
  }

  // Create a new technician
  static Future<dynamic> createTechnician(
      String imageFilePath, String name, String email, String phone, String location, String category) async {
    final imageFile = File(imageFilePath);
    final imageBytes = await imageFile.readAsBytes();
    final imageBase64 = base64Encode(imageBytes);

    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/technicians'));
    request.files.add(http.MultipartFile.fromBytes('image', imageBytes, filename: imageFile.path.split('/').last));
    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['phone'] = phone;
    request.fields['location'] = location;
    request.fields['category'] = category;

    final response = await request.send();
    final responseString = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      final technician = jsonDecode(responseString);
      return technician;
    } else if (response.statusCode == 400 && responseString.contains('Email already exists')) {
      throw Exception('Email already exists');
    } else {
      throw Exception('Failed to create technician');
    }
  }

  // Update a technician
  static Future<dynamic> updateTechnician(
      String id, String imageFilePath, String name, String email, String phone, String location, String category) async {
    final imageFile = File(imageFilePath);
    final imageBytes = await imageFile.readAsBytes();
    final imageBase64 = base64Encode(imageBytes);

    final request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/technicians/$id'));
    request.files.add(http.MultipartFile.fromBytes('image', imageBytes, filename: imageFile.path.split('/').last));
    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['phone'] = phone;
    request.fields['location'] = location;
    request.fields['category'] = category;

    final response = await request.send();
    final responseString = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final technician = jsonDecode(responseString);
      return technician;
    } else if (response.statusCode == 400 && responseString.contains('Email already exists')) {
      throw Exception('Email already exists');
    } else if (response.statusCode == 404 && responseString.contains('Technician not found')) {
      throw Exception('Technician not found');
    } else {
      throw Exception('Failed to update technician');
    }
  }

  // Delete a technician
  static Future<void> deleteTechnician(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/technicians/$id'));
    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 404 && response.body.contains('Technician not found')) {
      throw Exception('Technician not found');
    } else {
      throw Exception('Failed to delete technician');
    }
  }
}