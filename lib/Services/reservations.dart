import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ReservationService {
  static const String baseUrl = 'https://adminzaindev.zaindev.com.sa'; // Replace with your API base URL

  // Create a new reservation
  static Future<({ String? message })> createReservation(String technicianId, String date, int time) async {

    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String token = sharedPreferences.getString('token')!;

    final response = await http.post(
      Uri.parse('$baseUrl/reservations'),
      headers: {
        'Content-Type': 'application/json',
        'token': token
      },
      body: jsonEncode({
        'technicianId': technicianId,
        'date': date,
        'time':time.toString()
      }),
    );

    print(response.statusCode);

    if (response.statusCode == 201) {
      return (message: null);
    } else{
      return (message: response.body);
    }
  }

  // Get all reservations
  static Future<List<dynamic>> getAllReservations() async {
    final response = await http.get(Uri.parse('$baseUrl/reservations'));
    if (response.statusCode == 200) {
      final reservations = jsonDecode(response.body);
      return reservations;
    } else {
      throw Exception('Failed to fetch reservations');
    }
  }

  // Delete a reservation
  static Future<void> deleteReservation(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/reservations/$id'));
    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 404 && response.body.contains('Reservation not found')) {
      throw Exception('Reservation not found');
    } else {
      throw Exception('Failed to delete reservation');
    }
  }

  static Future<({ List<dynamic> reservations, String? errorMessage })> getUserReservations() async {
    try {
      // Make API request to get user reservations
      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      final String token = sharedPreferences.getString('token')!;
      final response = await http.get(Uri.parse('https://adminzaindev.zaindev.com.sa/reservations/user'),headers: {
        'token': token
      });


      if (response.statusCode == 200) {
        // Parse response JSON
        final List<dynamic> reservations = json.decode(response.body);

        return ( reservations: reservations, errorMessage: null );
      } else {
        return ( reservations: [], errorMessage: "Server Error" ) ;
      }
    } catch (error) {
      return ( reservations: [], errorMessage: "Network Error" ) ;
    }
  }

}