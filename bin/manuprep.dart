import 'dart:io';

import 'package:manuprep/manuprep.dart';
import 'package:path/path.dart' as p;

void showHelp({int? exitCode, String? message}) {
  if (message != null) {
    print("ERROR");
    print("\t$message");
    print("");
  }
  print("INFO");
  print("\tFlatten directory structure of LaTeX project for paper submission.");
  print("");
  print("USAGE");
  print("\tmanuprep <path/to/input.tex> <path/to/output_directory>");
  if (exitCode != null) exit(exitCode);
}

void main(List<String> arguments) {
  if (arguments.contains('-h') || arguments.contains('--help')) {
    showHelp(exitCode: 0);
  }

  if (arguments.length < 2) {
    showHelp(exitCode: 2, message: "Not enough arguments provided.");
  }

  if (arguments.length > 2) {
    print(
      "Extra arguments provided, ignoring: ${arguments.sublist(2).join(', ')}",
    );
  }

  final inputPath = arguments[0];
  final outputDirectory = arguments[1];

  if (!File(inputPath).existsSync()) {
    print("ERROR");
    print("");
    print("\tInput file '$inputPath' does not exist.");
    exit(3);
  }

  final entrypoint = p.basename(inputPath);
  final inputDirectory = p.dirname(inputPath);

  prepareFromContent(
    entrypoint: entrypoint,
    sourceDirectory: inputDirectory,
    outputDirectory: outputDirectory,
  );
}
