import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

import '../DataHandle/BardAIController.dart';
import 'History.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    BardAIController controller = Get.put(BardAIController());
    @override
    var widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((_) {
      // controller.load();
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff2f1f9),
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'PINK AI',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                controller.refreshPrompt();
              },
              icon: const Icon(Icons.add))
        ],
      ),
      drawer: const NavigationDrawer(),
      body: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BardAIController controller = Get.put(BardAIController());
  TextEditingController textField = TextEditingController();
  late StreamSubscription<bool> keyboardSubscription;
  double isKeyboard = 40;
  @override
  void initState() {
    super.initState();
    KeyboardVisibilityController().onChange.listen((isVisible) {
      setState(() {
        isKeyboard = isVisible ? 10 : 40;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController textField = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xfff2f1f9),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Stack(
          children: [
            const Align(
              alignment: Alignment.center,
              child: Text(
                "PIAI",
                style: TextStyle(
                  color: Color.fromARGB(50, 33, 149, 243),
                  fontWeight: FontWeight.bold,
                  fontSize: 80,
                ),
              ),
            ),
            ListView(
              children: [
                Obx(() => Column(
                      children: controller.historyList
                          .map(
                            (e) => Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    e.system == "user" ? "👨‍💻" : "🤖",
                                  ),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: RichText(
                                      text: TextSpan(
                                        children: e.parseMarkdown(
                                            e.message.toString()),
                                        style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 57, 57, 57),
                                          height: 1.3,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    )),
                const SizedBox(height: 80),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                transform: Matrix4.translationValues(0, -isKeyboard, 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(children: [
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.blue,
                    ),
                    child: TextFormField(
                      controller:textField,
                      style: const TextStyle(
                        color:
                            Colors.white, // Change this to your desired color
                      ),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        hintText: "Nhập câu hỏi của bạn....",
                        hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  )),
                  const SizedBox(width: 10),
                  Container(
                    // color: Colors.blue,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.blue,
                    ),
                    child: Obx(
                      () => controller.isLoading.value
                          ? Container(
                              margin: const EdgeInsets.all(10),
                              height: 28,
                              width: 28,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : IconButton(
                              onPressed: () {
                                if (textField.text != "") {
                                  controller.sendPrompt(textField.text);
                                  textField.clear();
                                }
                              },
                              icon: const Icon(Icons.arrow_upward_rounded,
                                  color: Colors.white, size: 30),
                            ),
                    ),
                  )
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) => const Drawer(child: ChatHistoryPage());
}
