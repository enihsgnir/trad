import 'package:trad/src/syntactic_analysis/action.dart';
import 'package:trad/src/syntactic_analysis/rule_symbol.dart';

import 'closure_table.dart';

class State {
  final Map<RuleSymbol, Action> _actions = {};

  Iterable<MapEntry<RuleSymbol, Action>> get entries => _actions.entries;

  Action? operator [](RuleSymbol token) => _actions[token];

  void operator []=(RuleSymbol token, Action action) {
    _actions.update(
      token,
      (value) =>
          throw Exception("conflict in parsing table: $value and $action"),
      ifAbsent: () => action,
    );
  }
}

class ParsingTable {
  final List<State> states = [];

  ParsingTable(ClosureTable closureTable) {
    for (final kernel in closureTable.kernels) {
      final state = State();

      for (final MapEntry(:key, :value) in kernel.gotos.entries) {
        state[key] = switch (key) {
          Terminal() => Action.shift(value),
          Nonterminal() => Action.goto(value),
        };
      }

      for (final item in kernel.closure) {
        if (item.isComplete || item.rule.isEpsilon) {
          for (final lookAhead in item.lookAheads) {
            state[lookAhead] = Action.reduce(item.rule.index);
          }
        }
      }

      states.add(state);
    }
  }
}
