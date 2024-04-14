import 'package:collection/collection.dart';
import 'package:trad/src/syntactic_analysis/rule_symbol.dart';

class RuleToken {
  final String type;
  final String lexeme;

  const RuleToken(
    this.type, [
    String? lexeme,
  ]) : lexeme = lexeme ?? type;

  static const colon = RuleToken(":");
  static const or = RuleToken("|");
  static const semi = RuleToken(";");

  @override
  bool operator ==(Object other) {
    return other is RuleToken && type == other.type && lexeme == other.lexeme;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, type, lexeme);
  }
}

class RuleGenerator {
  final String source;

  const RuleGenerator(this.source);

  Iterable<List<RuleSymbol>> get rules => generate();

  Iterable<RuleToken> tokenize() sync* {
    final whitespace = RegExp(r'\s+|//.*');
    final name = RegExp(r"\w+|'([^']*)'");
    final special = RegExp([":", "|", ";"].map(RegExp.escape).join("|"));

    int start = 0;
    while (start < source.length) {
      Match? match;

      match = whitespace.matchAsPrefix(source, start);
      if (match != null) {
        start = match.end;
        continue;
      }

      match = name.matchAsPrefix(source, start);
      if (match != null) {
        start = match.end;
        yield RuleToken("name", match[1] ?? match[0]!);
        continue;
      }

      match = special.matchAsPrefix(source, start);
      if (match != null) {
        start = match.end;
        yield RuleToken(match[0]!);
        continue;
      }

      throw Exception("Unexpected character at ${source[start]}");
    }
  }

  Iterable<List<String>> parse() sync* {
    final tokenList = tokenize().splitAfter((e) => e == RuleToken.semi);
    for (final tokens in tokenList) {
      assert(tokens.last == RuleToken.semi);

      final [[lhs, _], alts] =
          tokens.splitAfter((e) => e == RuleToken.colon).toList();
      final rhsList = alts.splitAfter((e) => e == RuleToken.or);
      for (final [...rhs, _] in rhsList) {
        yield [lhs, ...rhs].map((e) => e.lexeme).toList();
      }
    }
  }

  // TODO: throw exception for unreachable nonterminals
  Iterable<List<RuleSymbol>> generate() sync* {
    final rules = parse();

    final nonterminals = rules.map((e) => e.first).toSet();

    for (final rule in rules) {
      yield rule
          .map((e) => nonterminals.contains(e) ? Nonterminal(e) : Terminal(e))
          .toList();
    }
  }
}
