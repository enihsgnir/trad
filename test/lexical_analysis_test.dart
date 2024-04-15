import 'package:test/test.dart';
import 'package:trad/src/lexical_analysis/lexer.dart';

void main() {
  test("lexical analysis", () {
    const code = """
// this is a comment

void main() {
  print("Hello, World!");
}
""";

    final tokens = const Lexer().tokenize(code);

    expect(
      tokens.map((e) => e.lexeme),
      equals([
        "void",
        "main",
        "(",
        ")",
        "{",
        "print",
        "(",
        "Hello, World!",
        ")",
        ";",
        "}",
      ]),
    );
  });
}
