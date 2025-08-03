import 'dart:async';

import 'package:test/test.dart';
import 'package:trad/trad.dart';

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

  final outputs = capturePrintLines(() => ast.accept(Evaluator()));
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

  test("negation test", () {
    const code = """
void main() {
  print(!true);
  print(!false);
}
""";

    expect(evaluate(code), ["false", "true"]);
  });

  test("equality test", () {
    const code = """
void main() {
  print(1 == 2);
  print(1 != 2);
  print("hello" == "world");
  print("hello" != "world");
  print(true == false);
  print(true != false);
}
""";

    expect(evaluate(code), [
      "false",
      "true",
      "false",
      "true",
      "false",
      "true",
    ]);
  });

  test("comparison test", () {
    const code = """
void main() {
  print(1 >= 2);
  print(1 > 2);
  print(1 <= 2);
  print(1 < 2);
  print(1 >= 1);
  print(1 <= 1);
  print(true && false);
  print(true || false);
  print(true && true);
  print(true || true);
}
""";

    expect(evaluate(code), [
      "false",
      "false",
      "true",
      "true",
      "true",
      "true",
      "false",
      "true",
      "true",
      "true",
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

  test("no entrypoint test", () {
    const code = """
int ft() { return 42; }
""";

    expect(
      () => evaluate(code),
      throwsA(isA<Exception>()),
    );
  });

  test("short circuit test", () {
    const code = """
bool t() { print("t"); return true; }
bool f() { print("f"); return false; }

void main() {
  print(t() && f());
  print(f() && t());
  print(t() || f());
  print(f() || t());
}
""";

    final lines = evaluate(code);
    expect(lines, [
      "t",
      "f",
      "false",
      "f",
      "false",
      "t",
      "true",
      "f",
      "t",
      "true",
    ]);
  });

  test("for loop test", () {
    const code = """
void main() {
  for (int i = 0; i < 5; i = i + 1) {
    print(i);
  }
}
""";

    final lines = evaluate(code);
    expect(lines, ["0", "1", "2", "3", "4"]);
  });

  test("while loop test", () {
    const code = """
void main() {
  int i = 0;
  while (i < 5) {
    print(i);
    i = i + 1;
  }
}
""";

    final lines = evaluate(code);
    expect(lines, ["0", "1", "2", "3", "4"]);
  });

  test("global variable test", () {
    const code = """
int ft = 42;

void main() {
  print(ft);
}
""";

    final lines = evaluate(code);
    expect(lines, ["42"]);
  });

  test("variable reassignment test", () {
    const code = """
int ft = 42;

void main() {
  ft = 21;
  print(ft);
}
""";

    final lines = evaluate(code);
    expect(lines, ["21"]);
  });

  test("variable shadowing test", () {
    const code = """
int ft = 42;

void main() {
  int ft = 21;

  {
    int a = 7;
    print(a);
  }

  print(ft);
}
""";

    final lines = evaluate(code);
    expect(lines, ["7", "21"]);
  });

  group("class test group", () {
    test("class declaration test", () {
      const code = """
class A {
  int a = 21;

  void printA() {
    print(a);
  }

  int add(int b) {
    return a + b;
  }
}

void main() {
  print(42);
}
""";

      final lines = evaluate(code);
      expect(lines, ["42"]);
    });

    test("class instantiation test", () {
      const code = """
class A {}

void main() {
  A a = new A();

  print(42);
}
""";

      final lines = evaluate(code);
      expect(lines, ["42"]);
    });

    test("class member variable get test", () {
      const code = """
class A {
  int ma = 21;
  int mb = 42;
}

class B {
  int ma = 24;
  int mb = 12;
}

void main() {
  A ia = new A();
  print(ia.ma);
  print(ia.mb);

  B ib = new B();
  print(ib.ma);
  print(ib.mb);
}
""";

      final lines = evaluate(code);
      expect(lines, ["21", "42", "24", "12"]);
    });

    test("class method invocation test", () {
      const code = """
class A {
  int a = 42;

  void printA() {
    print(a);
  }
}

class B {
  int b = 21;

  void printB(int b) {
    print(b);
  }
}

void main() {
  A a = new A();
  a.printA();

  B b = new B();
  b.printB(42);
}
""";

      final lines = evaluate(code);
      expect(lines, ["42", "42"]);
    });
  });
}
