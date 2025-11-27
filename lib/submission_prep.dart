import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import 'parser.dart';
export 'parser.dart';

String? findFileWithBaseName({
  required String sourceDirectory,
  required String sourceName,
}) {
  final pathName = p.join(sourceDirectory, sourceName);
  final dirName = p.dirname(pathName);
  for (final entry in Directory(dirName).listSync()) {
    print(entry.path);
    if (entry.path.startsWith(pathName)) {
      return entry.path;
    }
  }

  print("Cannot find file for $sourceName in $sourceDirectory");

  return null;
}

class ResourceMap {
  final PathNode node;
  final String inputDirectory;
  final String inputPath;
  final String outputPath;

  const ResourceMap({
    required this.node,
    required this.inputDirectory,
    required this.inputPath,
    required this.outputPath,
  });

  @override
  String toString() {
    return 'ResourceMap(inputPath: $inputPath, outputPath: $outputPath)';
  }
}

DocumentNode prepareFromContent({
  required String entrypoint,
  required String sourceDirectory,
  required String outputDirectory,
}) {
  final sourcePath = p.join(sourceDirectory, entrypoint);
  final source = File(sourcePath).readAsStringSync();
  final doc = parseDocument(source: source);

  final maps = <ResourceMap>[];
  int idx = 0;

  ResourceMap addMapping(PathNode node, String inputResource) {
    final inputPath = findFileWithBaseName(
      sourceDirectory: sourceDirectory,
      sourceName: inputResource,
    );
    assert(inputPath != null, 'File not found for $inputResource');

    idx += 1;
    final prefix = idx.toString().padLeft(3, '0');

    final baseName = p.basename(inputPath!);
    final outputPath = p.join(outputDirectory, '${prefix}_$baseName');
    print('Mapping $inputPath to $outputPath');
    final mapping = ResourceMap(
      node: node,
      inputDirectory: sourceDirectory,
      inputPath: inputPath,
      outputPath: outputPath,
    );
    maps.add(mapping);

    return mapping;
  }

  doc.traverse((node) {
    print(node.runtimeType);
    switch (node) {
      case PathNode node:
        final m = addMapping(node, node.path);
        node.path = p.basename(m.outputPath);
      default:
    }
  });

  Directory(outputDirectory).createSync(recursive: true);
  for (final mapping in maps) {
    final node = mapping.node;
    print("Copying ${mapping.inputPath} to ${mapping.outputPath}");
    final inputFile = File(mapping.inputPath);
    final outputFile = File(mapping.outputPath);
    node.replacePath(p.basename(mapping.outputPath));
    outputFile.createSync(recursive: true);
    outputFile.writeAsBytesSync(inputFile.readAsBytesSync());
  }

  final outputEntrypoint = p.join(
    outputDirectory,
    p.basename(entrypoint),
  );
  File(outputEntrypoint).writeAsStringSync(doc.compose());

  return doc;
}
