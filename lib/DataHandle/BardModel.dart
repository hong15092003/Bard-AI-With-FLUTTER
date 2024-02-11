import 'package:flutter/material.dart';

class BardModel {
  String? system;
  String? message;

  BardModel({this.system, this.message});

  BardModel.fromJson(Map<String, dynamic> json) {
    if (json["system"] is String) {
      system = json["system"];
    }
    if (json["message"] is String) {
      message = json["message"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["system"] = system;
    data["message"] = message;
    return data;
  }
  List<TextSpan> parseMarkdown(String text) {
  final spans = <TextSpan>[];
  final parts = text.split('**');
  for (var i = 0; i < parts.length; i++) {
    final style = i % 2 == 0 ? const TextStyle() : const TextStyle(fontWeight: FontWeight.bold);
    spans.add(TextSpan(text: parts[i], style: style));
  }
  return spans;
}
}
