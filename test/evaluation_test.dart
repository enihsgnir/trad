import 'dart:async';

import 'package:test/test.dart';
import 'package:trad/src/abstract_syntax_tree/ast_builder.dart';
import 'package:trad/src/evaluation/evaluator.dart';
import 'package:trad/src/lexical_analysis/lexer.dart';
import 'package:trad/src/semantic_analysis/pre_tasker.dart';
import 'package:trad/src/semantic_analysis/symbol_table_builder.dart';
import 'package:trad/src/semantic_analysis/type_checker.dart';
import 'package:trad/src/syntactic_analysis/parser.dart';

List<String> capturePrintLines(void Function() body) {
  final outputs = <String>[];

  runZoned(
    body,
    zoneSpecification: ZoneSpecification(
      print: (self, parent, zone, line) => outputs.add(line),
    ),
  );

  return outputs;
}

List<String> evaluate(String code) {
  final tokens = const Lexer().tokenize(code);
  final root = const Parser().parse(tokens);
  final ast = const AstBuilder().build(root);

  ast.accept(const SymbolTableBuilder());
  ast.accept(const TypeChecker());

  final outputs = capturePrintLines(() => ast.accept(const Evaluator()));
  return outputs;
}

void main() {
  setUp(() {
    PreTasker.preTask();
  });

  test("print test", () {
    const code = """
void main() {
  print("hello, world!");
}
""";

    expect(evaluate(code), ["hello, world!"]);
  });

  test("arithmetic test", () {
    const code = """
void main() {
  print(1 + 2);
  print(1 - 2);
  print(1 * 2);
  print(1 ~/ 2);
  print(1 % 2);
  print(1 + 2 * 3 - 4 ~/ 5 % 6);
}
""";

    expect(evaluate(code), ["3", "-1", "2", "0", "1", "7"]);
  });

  test("string test", () {
    const code = """
void main() {
  print("hello, world!");
  print("hello" + ", " + "world!");
  print("hello" * 3);
  print("hello, world!" * 3);
}
""";

    expect(evaluate(code), [
      "hello, world!",
      "hello, world!",
      "hellohellohello",
      "hello, world!hello, world!hello, world!",
    ]);
  });

  test("fibonacci test", () {
    const code = """
int fibonacci(int n) {
  if (n == 0) {
    return 0;
  }
  if (n == 1) {
    return 1;
  }
  return fibonacci(n - 1) + fibonacci(n - 2);
}

void main() {
  print(fibonacci(0));
  print(fibonacci(1));
  print(fibonacci(2));
  print(fibonacci(3));
  print(fibonacci(4));
  print(fibonacci(5));
  print(fibonacci(20));
}
""";
    final lines = evaluate(code);
    expect(lines, ["0", "1", "1", "2", "3", "5", "6765"]);
  });

  test("factorial test", () {
    const code = """
int factorial(int n) {
  if (n == 0) {
    return 1;
  }
  return n * factorial(n - 1);
}

void main() {
  print(factorial(0));
  print(factorial(1));
  print(factorial(2));
  print(factorial(3));
  print(factorial(4));
  print(factorial(5));
  print(factorial(20));
}
""";
    final lines = evaluate(code);
    expect(lines, ["1", "1", "2", "6", "24", "120", "2432902008176640000"]);
  });
}
