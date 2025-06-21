import 'package:test/test.dart';
import 'package:trad/src/lexical_analysis/token_types.dart';

void main() {
  test("numeric literal token test", () {
    final matcher = NumericLiteralToken().matcher;

    const tokens = [
      "0x1",
      "0x1A",
      "0x1a",
      "0x1aF",
      "0X1",
      "0X1A",
      "0X1a",
      "0X1aF",
      "1",
      "1.0",
      ".1",
      "1e2",
      "1.0e2",
      ".1e2",
      "1e+2",
      "1.0e+2",
      ".1e+2",
      "1e-2",
      "1.0e-2",
      ".1e-2",
      "1E2",
      "1.0E2",
      ".1E2",
      "1E+2",
      "1.0E+2",
      ".1E+2",
      "1E-2",
      "1.0E-2",
      ".1E-2",
    ];

    for (final token in tokens) {
      final matches = matcher.allMatches(token);
      expect(matches, hasLength(1));
      expect(matches.single[0], equals(token));
    }
  });

  test("numeric literal invalid token test", () {
    final matcher = NumericLiteralToken().matcher;

    final invalidTokens = [
      ("0x", ["0"]),
      ("0xG", ["0"]),
      ("0x1G", ["0x1"]),
      ("0a1", ["0", "1"]),
      ("0ax", ["0"]),
      ("1.2.3", ["1.2", ".3"]),
      ("1e2e3", ["1e2", "3"]),
      ("1e2e3e4", ["1e2", "3e4"]),
      ("1e2.3", ["1e2", ".3"]),
      ("1.2e3", ["1.2e3"]),
    ];

    for (final (token, expected) in invalidTokens) {
      final matches = matcher.allMatches(token);
      expect(matches.map((e) => e.group(0)), equals(expected));
    }
  });
}
