import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../DataHandle/BardAIController.dart';
import '../DataHandle/BardModel.dart';

class ChatHistoryPage extends StatefulWidget {
  const ChatHistoryPage({super.key});

  @override
  _ChatHistoryPageState createState() => _ChatHistoryPageState();
}

class _ChatHistoryPageState extends State<ChatHistoryPage> {
  BardAIController controller = Get.put(BardAIController());
  dynamic oldChat = [];
  final file = File('chat_history.json');

  void loadHistory() async {
    if (await file.exists()) {
      final contents = await file.readAsString();
      final json = jsonDecode(contents);
      setState(() {
        oldChat = (json);
      });
    }
  }

  void deleteHistory(index) async {
    oldChat.removeAt(index);
    await file.writeAsString(jsonEncode(oldChat));
    setState(() {});
  }

  void loadContents(int index) async {
    controller.refreshPrompt();
    int contentLeght = oldChat[index]['Text'].length;
    final Text = oldChat[index]["Text"];
    for (int content = 0; content < contentLeght; content++) {
      if (Text[content]['role'] == 'user') {
        final newHistory =
            BardModel(system: "user", message: Text[content]['message']);
        controller.historyList.add(newHistory);
        controller.joinPrompt("user", Text[content]['message']);
      } else {
        final newHistory =
            BardModel(system: "bard", message: Text[content]['message']);
        controller.historyList.add(newHistory);
        controller.joinPrompt("Model", Text[content]['message']);
      }
    }
    deleteHistory(index);
  }

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: const Color(0xfff2f1f9),
        elevation: 0,
        title: const Text(
          'Chat History',
          style: TextStyle(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: ListView.builder(
        itemCount: oldChat.length,
        itemBuilder: (context, index) {
          return HistoryCard(
              title: oldChat[index]["title"],
              buttonLoad: () {
                loadContents(index);
              },
              buttonDelete: () {
                deleteHistory(index);
              });
        },
      ),
    );
  }
}

class HistoryCard extends StatelessWidget {
  final String title;
  final dynamic buttonLoad;
  final dynamic buttonDelete;
  const HistoryCard({
    super.key,
    required this.title,
    required this.buttonLoad,
    required this.buttonDelete,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Card(
        elevation: 5,
        child: ListTile(
          title: Text(title,
          maxLines:1,
          overflow: TextOverflow.ellipsis ,),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: buttonLoad,
                icon: const Icon(Icons.refresh),
              ),
              IconButton(
                onPressed: buttonDelete,
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
