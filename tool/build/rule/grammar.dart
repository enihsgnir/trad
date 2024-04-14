import 'package:trad/src/syntactic_analysis/rule_symbol.dart';

import 'production.dart';

final grammar = Grammar();

class Grammar {
  final Map<Nonterminal, Set<Terminal>> firstSets = {};

  Grammar() {
    initFirstSets();
  }

  void initFirstSets() {
    bool changed;

    do {
      changed = false;

      for (final production in productions) {
        final firstSet = firstSets.putIfAbsent(production.lhs, () => {});
        changed |= firstSet.insertAll(collectFirsts(production.rhs));
      }
    } while (changed);
  }

  Set<Terminal> collectFirsts(List<RuleSymbol> symbols) {
    final set = <Terminal>{};
    for (final symbol in symbols) {
      if (symbol is Terminal) {
        return set..add(symbol);
      }

      final firstSet = firstSets[symbol] ?? {};

      set.addAll(firstSet.where((e) => e != epsilon));

      if (!firstSet.contains(epsilon)) {
        return set;
      }
    }

    return set..add(epsilon);
  }
}

extension TerminalSetExtension on Set<Terminal> {
  bool insertAll(Set<Terminal> elements) {
    return elements.fold(
      false,
      (previousValue, element) => previousValue | add(element),
    );
  }
}
