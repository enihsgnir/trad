import 'dart:io';

import 'token_types.dart';

class Lexer {
  const Lexer();

  Iterable<Token> tokenize(String source) sync* {
    int lineno = 1;
    int offset = 0;
    int i = 0;

    while (i < source.length) {
      Match? match;
      for (final tokenType in tokenTypes) {
        match = tokenType.regExp.matchAsPrefix(source, i);
        if (match != null) {
          i = match.end;

          switch (tokenType) {
            case Whitespace() || Comment():
              break;
            case LineBreak():
              lineno++;
              offset = i;
            case StaticToken():
              yield Token(
                type: tokenType,
                lexeme: tokenType.lexemeFrom(match),
                ln: lineno,
                col: (match.start - offset) + 1,
              );
          }

          break;
        }
      }

      if (match == null) {
        match = RegExp(r'\S+').matchAsPrefix(source, i);
        throw Exception(
          "$lineno:${i + 1}: unrecognized token '${match?[0]}'",
        );
      }
    }
  }

  Iterable<Token> tokenizeFile(String filename) sync* {
    yield* tokenize(File(filename).readAsStringSync());
  }
}

class Token {
  final String type;
  final String lexeme;
  final int ln;
  final int col;

  Token({
    required StaticToken type,
    required this.lexeme,
    required this.ln,
    required this.col,
  }) : type = type is DynamicToken ? type.name : lexeme;

  @override
  String toString() => "$ln:$col: $type: $lexeme";
}
