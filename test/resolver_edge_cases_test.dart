/// Edge cases from sample-quirky/edge-cases.tex, one tiny snippet each.
///
/// Every test asserts what LaTeX itself would resolve, so the unsupported
/// ones fail until manuprep handles them.
library;

import 'dart:io';

import 'package:manuprep/parser.dart';
import 'package:manuprep/resolver.dart';
import 'package:manuprep/types/config.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  late Directory root;

  setUp(() => root = Directory.systemTemp.createTempSync('manuprep_test_'));
  tearDown(() => root.deleteSync(recursive: true));

  /// Create empty files at [paths] (relative to [root]).
  void touch(List<String> paths) {
    for (final path in paths) {
      File(p.join(root.path, path)).createSync(recursive: true);
    }
  }

  /// Resolve [source] and return resource paths relative to [root].
  List<String> resolve(String source) {
    final config = PrepConfig(rootDirectory: root.path, entrypoint: 'main.tex');
    final resources = resolveResources(
      config: config,
      doc: parseDocument(source: source),
    );
    return [
      for (final resource in resources)
        p.relative(switch (resource) {
          FileResource(:final path) => path,
          DocumentResource(:final path) => path,
        }, from: root.path),
    ];
  }

  test('E1 \\graphicspath directories are searched', () {
    touch(['figures/logos/logo.png']);
    expect(
      resolve(r'\graphicspath{{figures/logos/}}\includegraphics{logo}'),
      ['figures/logos/logo.png'],
    );
  });

  test('E2 path built by a macro argument', () {
    touch(['figures/photo.jpg']);
    expect(
      resolve(r'\newcommand{\fig}[1]{\includegraphics{figures/#1}}\fig{photo}'),
      ['figures/photo.jpg'],
    );
  });

  test('E3 %-commented \\includegraphics is ignored', () {
    expect(resolve('% \\includegraphics{figures/missing}\n'), isEmpty);
  });

  test('E4 \\% does not start a comment', () {
    touch(['figures/photo.jpg']);
    expect(
      resolve(r'50\% done \includegraphics{figures/photo.jpg}'),
      ['figures/photo.jpg'],
    );
  });

  test('E5 \\input inside \\iffalse ... \\fi is ignored', () {
    expect(resolve(r'\iffalse \input{chapters/missing} \fi'), isEmpty);
  });

  test('E6 \\input without braces', () {
    touch(['chapters/legacy.tex']);
    expect(resolve(r'\input chapters/legacy'), ['chapters/legacy.tex']);
  });

  test('E7 \\include', () {
    touch(['appendix/extra.tex']);
    expect(resolve(r'\include{appendix/extra}'), ['appendix/extra.tex']);
  });

  test('E8 whitespace between options and path', () {
    touch(['figures/photo.jpg']);
    expect(
      resolve('\\includegraphics[width=1cm]\n  {figures/photo.jpg}'),
      ['figures/photo.jpg'],
    );
  });

  test('E9 dotted base name without extension', () {
    touch(['figures/sweep.v2.pdf']);
    expect(
      resolve(r'\includegraphics{figures/sweep.v2}'),
      ['figures/sweep.v2.pdf'],
    );
  });

  test('E10 unbalanced [ in math', () {
    touch(['figures/photo.jpg']);
    expect(
      resolve(r'$[0, 1)$ \includegraphics{figures/photo.jpg}'),
      ['figures/photo.jpg'],
    );
  });

  test('unbalanced \\left\\{ in math', () {
    touch(['figures/photo.jpg']);
    expect(
      resolve(r'$\left\{ x \right.$ \includegraphics{figures/photo.jpg}'),
      ['figures/photo.jpg'],
    );
  });

  test('stray [ ] after other macros', () {
    touch(['figures/photo.jpg']);
    expect(
      resolve(
        r'\section[short]{long} \\[2pt] '
        r'\includegraphics[width=1cm]{figures/photo.jpg}',
      ),
      ['figures/photo.jpg'],
    );
  });

  test('no extension prefers .pdf over .png, like pdflatex', () {
    touch(['figures/pipeline.png', 'figures/pipeline.pdf']);
    expect(
      resolve(r'\includegraphics{figures/pipeline}'),
      ['figures/pipeline.pdf'],
    );
  });

  /// Quirks from sample-quirky/main.tex that already work: regression tests.
  group('supported', () {
    /// Create [path] (relative to [root]) with [content].
    void write(String path, String content) {
      File(p.join(root.path, path))
        ..createSync(recursive: true)
        ..writeAsStringSync(content);
    }

    test('\\input without extension', () {
      touch(['chapters/01-intro.tex']);
      expect(resolve(r'\input{chapters/01-intro}'), ['chapters/01-intro.tex']);
    });

    test('\\input with explicit .tex', () {
      touch(['chapters/02_methods.tex']);
      expect(
        resolve(r'\input{chapters/02_methods.tex}'),
        ['chapters/02_methods.tex'],
      );
    });

    test('\\input with spaces inside the braces', () {
      touch(['chapters/results.tex']);
      expect(resolve(r'\input{ chapters/results }'), ['chapters/results.tex']);
    });

    test('\\input of a non-.tex file', () {
      touch(['figures/diagram.tikz']);
      expect(
        resolve(r'\input{figures/diagram.tikz}'),
        ['figures/diagram.tikz'],
      );
    });

    test('nested \\input, paths relative to the root', () {
      write('chapters/methods.tex', r'\input{chapters/methods/setup}');
      touch(['chapters/methods/setup.tex']);
      expect(
        resolve(r'\input{chapters/methods}'),
        unorderedEquals(['chapters/methods.tex', 'chapters/methods/setup.tex']),
      );
    });

    test('\\input inside an environment', () {
      touch(['tables/params.tex']);
      expect(
        resolve(r'\begin{table}\centering\input{tables/params}\end{table}'),
        ['tables/params.tex'],
      );
    });

    test('missing files inside \\begin{comment} are ignored', () {
      expect(
        resolve(
          r'\begin{comment}\input{old}\includegraphics{gone}\end{comment}',
        ),
        isEmpty,
      );
    });

    test('\\bibliography with two files, one in a subdirectory', () {
      touch(['refs.bib', 'bib/extra.bib']);
      expect(
        resolve(r'\bibliography{refs,bib/extra}'),
        unorderedEquals(['refs.bib', 'bib/extra.bib']),
      );
    });

    test('options with a macro, nested braces and a flag', () {
      touch(['figures/results/accuracy.pdf']);
      expect(
        resolve(
          r'\includegraphics[width=\linewidth, trim={0 0 0 0}, clip]'
          r'{figures/results/accuracy}',
        ),
        ['figures/results/accuracy.pdf'],
      );
    });

    test('dots in the base name with explicit extension', () {
      touch(['figures/loss.final.pdf']);
      expect(
        resolve(r'\includegraphics{figures/loss.final.pdf}'),
        ['figures/loss.final.pdf'],
      );
    });

    test('uppercase extension', () {
      touch(['figures/SCAN.PNG']);
      expect(resolve(r'\includegraphics{figures/SCAN.PNG}'), [
        'figures/SCAN.PNG',
      ]);
    });

    test('same file name in two directories', () {
      touch(['figures/overview.pdf', 'appendix/figures/overview.pdf']);
      expect(
        resolve(
          r'\includegraphics{figures/overview}'
          r'\includegraphics{appendix/figures/overview}',
        ),
        unorderedEquals([
          'figures/overview.pdf',
          'appendix/figures/overview.pdf',
        ]),
      );
    });
  });
}
