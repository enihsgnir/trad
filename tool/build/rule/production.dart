import 'package:collection/collection.dart';
import 'package:trad/src/syntactic_analysis/rule_symbol.dart';

import 'rule_generator.dart';
import 'rule_string.dart';

final productions = Production.generate(ruleString).toSet();

class Production {
  final int index;
  final Nonterminal lhs;
  final List<RuleSymbol> rhs;

  const Production(this.index, this.lhs, this.rhs);

  bool get isEpsilon => rhs.isEmpty;

  static Iterable<Production> generate(String ruleString) sync* {
    final generator = RuleGenerator(ruleString);
    final rules = generator.rules;

    for (final (i, rule) in rules.indexed) {
      final [lhs as Nonterminal, ...rhs] = rule;
      yield Production(i, lhs, rhs);
    }
  }

  @override
  bool operator ==(Object other) {
    return other is Production &&
        lhs == other.lhs &&
        const ListEquality<RuleSymbol>().equals(rhs, other.rhs);
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      lhs,
      const ListEquality<RuleSymbol>().hash(rhs),
    );
  }
}
