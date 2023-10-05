// Bard Api With Flutter getx ❤️ 
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

String APIKEY = "AIzaSyAqtgYQGVHDAfQWILDH7TP6O5au79kCCwU";
String BaseURL =
    "https://generativelanguage.googleapis.com/v1beta2/models/text-bison-001:generateText?key=YOUR_API_KEY";





class BardController extends GetxController {
  final String apiKey = 'AIzaSyAqtgYQGVHDAfQWILDH7TP6O5au79kCCwU';

  String response = '';

  Future<void> sendPrompt(String prompt) async {
    final body = {
      'prompt': {
        'text': prompt,
      },
    };

    final request = await http.post(
      Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta2/models/text-bison-001:generateText?key=$apiKey'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (request.statusCode == 200) {
      final responseJson = jsonDecode(request.body);

      final output = responseJson["candidates"][0]["output"];
      print(output);
    } else {
      print('Error sending prompt to Bard: ${request.statusCode}');
    }
  }
}
