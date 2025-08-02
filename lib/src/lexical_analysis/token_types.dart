final List<TokenType> tokenTypes = [
  Whitespace(),
  LineBreak(),
  Comment(),
  OperatorToken(),
  KeywordToken(),
  IdentifierToken(),
  IntegerLiteralToken(),
  StringLiteralToken(),
];

sealed class TokenType {
  final RegExp matcher;

  const TokenType(this.matcher);
}

sealed class IgnorableToken extends TokenType {
  const IgnorableToken(super.matcher);
}

class Whitespace extends IgnorableToken {
  Whitespace() : super(RegExp(r'[^\S\r\n]+'));
}

class LineBreak extends IgnorableToken {
  LineBreak() : super(RegExp(r'\n|\r\n|\r'));
}

class Comment extends IgnorableToken {
  Comment() : super(RegExp('//.*'));
}

sealed class StaticToken extends TokenType {
  const StaticToken(super.matcher);

  String lexemeFrom(Match match) => match[0]!;
}

class OperatorToken extends StaticToken {
  OperatorToken() : super(RegExp(_operators.map(RegExp.escape).join("|")));

  static const _operators = [
    "+",
    "-",
    "*",
    "~/",
    "%",
    "?",
    ":",
    ";",
    ",",
    "(",
    ")",
    "[",
    "]",
    "{",
    "}",
    "<=",
    "<",
    ">=",
    ">",
    "==",
    "=",
    "!=",
    "!",
    "&&",
    "||",
    ".",
  ];
}

class KeywordToken extends StaticToken {
  KeywordToken() : super(RegExp(_keywords.map((e) => e + r'\b').join("|")));

  static const _keywords = [
    "assert",
    "break",
    "case",
    "catch",
    "class",
    "const",
    "continue",
    "default",
    "do",
    "else",
    "enum",
    "extends",
    "false",
    "final",
    "finally",
    "for",
    "if",
    "in",
    "is",
    "new",
    "null",
    "rethrow",
    "return",
    "super",
    "switch",
    "this",
    "throw",
    "true",
    "try",
    "var",
    "void",
    "while",
    "with",

    // built-in types
    "int",
    "String",
    "bool",
    "List",
    "Null",
  ];
}

sealed class DynamicToken extends StaticToken {
  final String name;

  const DynamicToken(this.name, super.regExp);
}

class IdentifierToken extends DynamicToken {
  IdentifierToken() : super("id", RegExp(r'[a-zA-Z_]\w*'));
}

class IntegerLiteralToken extends DynamicToken {
  IntegerLiteralToken() : super("intLiteral", RegExp(r'\d+'));
}

class NumericLiteralToken extends DynamicToken {
  NumericLiteralToken() : super("numericLiteral", RegExp(numericLiteral));

  static const numericLiteral = '$hexNumber|$number';

  static const number = '($digit+$dot$digit+|$digit+|$dot$digit+)($exponent)?';

  static const exponent = '[eE][+-]?$digit+';

  static const hexNumber = '0[xX][0-9a-fA-F]+';

  static const digit = r'\d';

  static const dot = r'\.';
}

class StringLiteralToken extends DynamicToken {
  /// `(["'])((?:\\\1|(?:(?!\1)).)*)\1`
  StringLiteralToken()
      : super("str", RegExp('(["\'])((?:\\\\\\1|(?:(?!\\1)).)*)\\1'));

  @override
  String lexemeFrom(Match match) => match[2]!;
}
