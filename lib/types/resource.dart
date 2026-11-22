import 'dart:io';

import 'package:path/path.dart' as p;

class ResourcePath {
  /// The path used when including in the root directory of tex Project
  final String inputPath;

  /// The path relative to the current working directory
  final String workDirPath;

  ResourcePath({required this.inputPath, required this.workDirPath});

  /// Resolve [inputName] (as written in the tex source, extension optional)
  /// against [rootDir] by looking for a matching file on disk.
  ///
  /// Throws a [StateError] if no file matches.
  factory ResourcePath.fromInputName({
    required String inputName,
    required String rootDir,
  }) {
    final pathName = p.normalize(p.join(rootDir, inputName));
    final dirName = p.dirname(pathName);
    for (final entry in Directory(dirName).listSync()) {
      if (entry is! File) continue;
      final entryPath = p.normalize(entry.path);
      final matches =
          entryPath == pathName ||
          p.join(dirName, p.basenameWithoutExtension(entryPath)) == pathName;
      if (matches) {
        return ResourcePath(inputPath: inputName, workDirPath: entryPath);
      }
    }
    throw StateError('Cannot find file for $inputName in $rootDir');
  }

  /// The tex project root directory, relative to the current working directory.
  ///
  /// Drops as many trailing segments from [workDirPath] as [inputPath] has,
  /// so it also works when [inputPath] has no extension (`figs/a` vs `figs/a.png`).
  String get inputRootDir {
    final inputParts = p.split(p.normalize(inputPath));
    final workDirParts = p.split(p.normalize(workDirPath));
    if (workDirParts.length < inputParts.length) {
      throw StateError(
        'workDirPath "$workDirPath" is shorter than inputPath "$inputPath"',
      );
    }
    final rootParts = workDirParts.sublist(
      0,
      workDirParts.length - inputParts.length,
    );
    return rootParts.isEmpty ? '.' : p.joinAll(rootParts);
  }
}

class ResourceMap {
  final String inputDirectory;
  final String inputPath;
  final String outputPath;

  const ResourceMap({
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
