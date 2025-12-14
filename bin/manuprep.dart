import 'dart:io';

import 'package:manuprep/manuprep.dart';
import 'package:path/path.dart' as p;
import 'package:args/args.dart';

void main(List<String> arguments) {
  final parser = ArgParser();
  parser.addSeparator(
    'Flatten directory structure of LaTeX project for paper submission',
  );

  parser.addSeparator(
    'Usage:',
  );
  parser.addOption(
    'input',
    abbr: 'i',
    help: 'Input LaTeX file path',
    callback: (String? input) {
      if (input == null) {
        print("[WARNING] Input file is required.\n");
        print(parser.usage);
        exit(2);
      }
    },
  );

  parser.addOption(
    'output',
    abbr: 'o',
    help: 'Output directory path',
    callback: (String? output) {
      if (output == null) {
        print("[WARNING] Output directory is required.\n");
        print(parser.usage);
        exit(2);
      }
    },
  );

  final parsedArgs = parser.parse(arguments);
  final inputPath = parsedArgs['input'] as String;
  final outputDirectory = parsedArgs['output'] as String;

  final entrypoint = p.basename(inputPath);
  final inputDirectory = p.dirname(inputPath);

  prepareFromContent(
    entrypoint: entrypoint,
    sourceDirectory: inputDirectory,
    outputDirectory: outputDirectory,
  );
}
