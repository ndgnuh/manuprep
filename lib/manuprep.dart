import 'dart:io';

import 'package:path/path.dart' as p;

import 'compose.dart';
import 'parser.dart';
import 'types/ast.dart';
export 'parser.dart';

class WorkingContext {
  final String entrypoint;
  final String sourceDirectory;
  final String outputDirectory;
  final List<ResourceMap> resourceMaps;

  const WorkingContext({
    required this.entrypoint,
    required this.sourceDirectory,
    required this.outputDirectory,
    required this.resourceMaps,
  });
}

class ResourceMap {
  final String path;
  final String inputDirectory;
  final String inputPath;
  final String outputPath;

  const ResourceMap({
    required this.path,
    required this.inputDirectory,
    required this.inputPath,
    required this.outputPath,
  });

  ResourceMap addSuffix(int index) {
    final baseName = p.basenameWithoutExtension(outputPath);
    final extension = p.extension(outputPath);
    final newOutputPath = p.join(
      p.dirname(outputPath),
      '${baseName}_$index$extension',
    );
    return ResourceMap(
      path: path,
      inputDirectory: inputDirectory,
      inputPath: inputPath,
      outputPath: newOutputPath,
    );
  }

  @override
  String toString() {
    return 'ResourceMap(inputPath: $inputPath, outputPath: $outputPath)';
  }
}

/// Prepare a LaTeX document for submission by copying all resources
/// to the [outputDirectory] and updating the paths in the document.
/// Returns the modified [DocumentNode].
///
// DocumentNode prepareFromContent({
//   required String entrypoint,
//   required String sourceDirectory,
//   required String outputDirectory,
// }) {
//   final sourcePath = p.join(sourceDirectory, entrypoint);
//   final source = File(sourcePath).readAsStringSync();
//   final doc = parseDocument(source: source);
//
//   final maps = <ResourceMap>[];
//
//   /// Add resource to the mapping and return the created [ResourceMap].
//   /// This does not copy the file, it only creates the mapping.
//   /// It also does not resolve file path conflicts.
//   ResourceMap addMapping(String node, String inputResource) {
//     final inputPath = findFileWithBaseName(
//       sourceDirectory: sourceDirectory,
//       sourceName: inputResource,
//     );
//     assert(inputPath != null, 'File not found for $inputResource');
//
//     final baseName = p.basename(inputPath!);
//     final outputPath = p.join(outputDirectory, baseName);
//     final mapping = ResourceMap(
//       node: node,
//       inputDirectory: sourceDirectory,
//       inputPath: inputPath,
//       outputPath: outputPath,
//     );
//     maps.add(mapping);
//
//     return mapping;
//   }
//
//   /// Resolve name conflicts by appending a
//   /// suffix index to the file name if duplicated.
//   final seenIndices = <String, int>{};
//   for (final (i, map) in maps.indexed) {
//     final outputPath = map.outputPath;
//
//     if (seenIndices.containsKey(outputPath)) {
//       /// If it it seen, increment the index and
//       /// update the outputPath with the new index.
//       final index = seenIndices[outputPath]! + 1;
//       seenIndices[outputPath] = index;
//       maps[i] = map.addSuffix(index);
//     } else {
//       /// If outputPath is not seen before, initialize its index to 0.
//       seenIndices[outputPath] = 0;
//     }
//   }
//
//   /// replace paths in the document nodes and
//   /// create resource mappings
//   /// for each resource found.
//   doc.traverse((node) {
//     switch (node) {
//       case PathNode node:
//         final m = addMapping(node, node.path);
//         node.path = p.basename(m.outputPath);
//       default:
//     }
//   });
//
//   /// Create output directory and copy resources
//   Directory(outputDirectory).createSync(recursive: true);
//   for (final mapping in maps) {
//     final node = mapping.node;
//     final inputFile = File(mapping.inputPath);
//     final outputFile = File(mapping.outputPath);
//     node.replacePath(p.basename(mapping.outputPath));
//     outputFile.createSync(recursive: true);
//     outputFile.writeAsBytesSync(inputFile.readAsBytesSync());
//
//     /// Show info about copied files
//     print("[INFO] ${mapping.inputPath} -> ${mapping.outputPath}");
//   }
//
//   /// Write entrypoint file
//   final outputEntrypoint = p.join(
//     outputDirectory,
//     p.basename(entrypoint),
//   );
//   File(outputEntrypoint).writeAsStringSync(texCompose(astNode: doc));
//   print("[INFO] Written flatten entrypoint $outputEntrypoint");
//
//   return doc;
// }
