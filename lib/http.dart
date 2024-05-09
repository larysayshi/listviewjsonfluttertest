import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models/product.dart';

Future<Item> fetchData() async {
  final response = await http
      .get(Uri.parse('https://api.jsonserve.com/Ibwq3i'));

  if (response.statusCode == 200) {
    return Item.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 500) {
    throw Exception('Failed to load data');
  } else {
    throw Exception('Failed to load data');
  }
}