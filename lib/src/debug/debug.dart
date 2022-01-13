import 'package:flutter/material.dart' show debugPrint;

final _startTime = DateTime.now();

void debug(String text, {String? origin}) {
  debugPrint('[' +
      DateTime.now().difference(_startTime).toString() +
      '] ' +
      (origin ?? '') +
      ': $text');
}
