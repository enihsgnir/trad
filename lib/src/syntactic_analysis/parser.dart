import 'dart:collection';

import '../lexical_analysis/lexer.dart';
import 'action.dart';
import 'rule_symbol.dart';

part 'parser.g.dart';

const List<(Nonterminal, int)> productions = _$productions;
const List<Map<String, Action>> parsingTable = _$parsingTable;

/// LALR(1) parser
class Parser {
  const Parser();

  ParseTreeNode parse(Iterable<Token> tokens) {
    final tokenTerminals = tokens.map(TokenTerminal.new);

    final tokenQueue = Queue<Terminal>.of(tokenTerminals)..add(eof);

    final stateStack = <int>[0];
    final nodeStack = <ParseTreeNode>[];

    while (true) {
      final state = parsingTable[stateStack.last];
      final token = nodeStack.length == stateStack.length
          ? nodeStack.last.symbol
          : tokenQueue.first;
      final action = state[token.name];

      if (action == null) {
        throw Exception("unexpected token: $token");
      }

      switch (action.type) {
        case ActionType.shift:
          stateStack.add(action.value);
          nodeStack.add(ParseTreeNode(token, []));
          tokenQueue.removeFirst();
        case ActionType.reduce:
          final (lhs, rhsLength) = productions[action.value];

          final alternative = nodeStack.sublist(nodeStack.length - rhsLength);
          for (int i = 0; i < rhsLength; i++) {
            stateStack.removeLast();
            nodeStack.removeLast();
          }

          nodeStack.add(ParseTreeNode(lhs, alternative));
        case ActionType.goto:
          stateStack.add(action.value);
      }

      if (action == Action.accept) {
        return nodeStack.last;
      }
    }
  }
}

class TokenTerminal extends Terminal {
  final Token token;

  TokenTerminal(this.token) : super(token.type);

  @override
  String toString() => token.lexeme;
}

class ParseTreeNode {
  final RuleSymbol symbol;
  final List<ParseTreeNode> children;

  const ParseTreeNode(this.symbol, this.children);
}
