
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'BardModel.dart';
import '../data/data.dart';

class BardAIController extends GetxController {
  RxList<BardModel> historyList = RxList<BardModel>([]);
  List<Map<String, dynamic>> chatHistory = [];
  final Map<String, dynamic> body = {
    "contents": [],
    "generationConfig": {
      "temperature": 1,
      "topK": 10,
      "topP": 1,
      "maxOutputTokens": 2048,
      "stopSequences": []
    },
    "safetySettings": [
      {
        "category": "HARM_CATEGORY_HARASSMENT",
        "threshold": "BLOCK_MEDIUM_AND_ABOVE"
      },
      {
        "category": "HARM_CATEGORY_HATE_SPEECH",
        "threshold": "BLOCK_MEDIUM_AND_ABOVE"
      },
      {
        "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
        "threshold": "BLOCK_MEDIUM_AND_ABOVE"
      },
      {
        "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
        "threshold": "BLOCK_MEDIUM_AND_ABOVE"
      }
    ]
  };
  RxBool isLoading = false.obs;

  void sendPrompt(String prompt) async {
    isLoading.value = true;
    var newHistory = BardModel(system: "user", message: prompt);
    historyList.add(newHistory);
    joinPrompt("user", prompt);

    final request = await http.post(
      Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$APIKEY'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    final response = jsonDecode(request.body);
    final bardReplay = getTextFromResponse(response);
    joinPrompt("Model", bardReplay);
    var newHistory2 = BardModel(system: "bard", message: bardReplay);
    historyList.add(newHistory2);
    isLoading.value = false;
  }
    
    String getTextFromResponse(response) {
    return response['candidates']?[0]['content']['parts'][0]['text'];
    }
  // void load() {
  //   joinPrompt("user", About);
  //   joinPrompt("Model", AI);
  // }

  void joinPrompt(String role, String request) {
    addMessageToHistory(role, request);
    body["contents"].add({
      "role": role,
      "parts": [
        {"text": request}
      ]
    });
  }

   

  void refreshPrompt() {
    if (chatHistory.isEmpty) return;
    body["contents"] = [];
    historyList.clear();
    saveChatHistory();
    debugPrint("Refreshed");
    isLoading.value = false;
    // load();
  }

  void addMessageToHistory(String role, String message) {
    chatHistory.add({"role": role, "message": message});
  }

 void createNewFile() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/chat_history.json');

  // Check if the file already exists
  bool exists = await file.exists();

  // If the file does not exist, create it
  if (!exists) {
    await file.create();
    debugPrint('File created');
  } else {
    debugPrint('File already exists');
  }
}

  String getTitleChar(final str) {
    final text = str[0]["message"];
    // if (text.length < 10) return text.toString();
    // final title = text.substring(0,100) + "...";
    return text;
  }

void saveChatHistory() async {
  createNewFile();
  final file = File('chat_history.json');

  // Read the current contents of the file.
  String contents = await file.readAsString();

  // Parse the contents as JSON.
  List<dynamic> jsonContents =[];
  jsonContents.add({'title': getTitleChar(chatHistory), 'Text': chatHistory}) ;
  int leghtContens = jsonDecode(contents).length;
  // Add the new chat history to the list.
  for (var i = 0; i < leghtContens; i++) {
    jsonContents.add(jsonDecode(contents)[i]);
  }

  // Write the updated list back to the file.
  await file.writeAsString(jsonEncode(jsonContents));

  // Clear the chat history after saving it to the file.
  chatHistory.clear();

}

  

}
