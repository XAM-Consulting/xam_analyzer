import 'dart:isolate';

import 'package:xam_analyzer/analyzer_plugin.dart';

void main(List<String> args, SendPort sendPort) {
  start(args, sendPort);
}
