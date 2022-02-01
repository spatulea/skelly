import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import '../debug/debug.dart';

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

abstract class GenerateName {
  static const String _className = 'GenerateName';

  static Future<String> get name async {
    const String origin = _className + 'name';

    final List<List<dynamic>> animalsList2D = const CsvToListConverter()
        .convert(await rootBundle.loadString("assets/animals.csv"));

    // Flatten 2D list to 1D lists of animals
    List<dynamic> animals = animalsList2D.expand((i) => i).toList();

    // Choose a random animal
    String animal = animals[Random().nextInt(animals.length)] as String;

    // Get adjectives describing the animal
    final response = await http.get(
        Uri.parse('https://api.datamuse.com/words?max=200&rel_jjb=$animal'));

    // use just animal name if datamust stops working
    if (response.statusCode != 200) {
      debug('api.datamuse.com response: ${response.statusCode}',
          origin: origin);
      return (animal.capitalize());
    }

    // Convert to a json list
    // Response example:  [{"word":"red","score":1001},{"word":"tailed","score":1000}]
    List<dynamic> responseJson = jsonDecode(response.body);

    debug('Got ${responseJson.length} adjectives for animal $animal',
        origin: origin);

    // and pick out a random word from it
    String adjective =
        responseJson[Random().nextInt(responseJson.length)]['word'];

    return (adjective.capitalize() + ' ' + animal.capitalize());
  }
}
