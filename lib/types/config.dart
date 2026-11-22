/// Configuration object, holds the context of the preparation task.
class const PrepConfig({
  /// Latex root directory
  required final String rootDirectory,

  /// Latex entrypoint directory name, does not contain directory name
  required final String entrypoint,

  /// Planned, doesn't do anything for now
  final bool stripComments = true,
});
