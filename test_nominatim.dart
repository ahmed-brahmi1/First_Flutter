import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final uri = Uri.https(
    'nominatim.openstreetmap.org',
    '/search',
    <String, String>{
      'q': 'berlin',
      'format': 'jsonv2',
      'limit': '1',
    },
  );

  try {
    final response = await http.get(
      uri,
      headers: <String, String>{
        'User-Agent': 'SmartPet/1.0.0 (https://github.com/example/smartpet)',
        'Accept-Language': 'en-US,en;q=0.5',
      },
    );
    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');
  } catch (e) {
    print('Error: $e');
  }
}
