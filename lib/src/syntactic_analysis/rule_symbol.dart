sealed class RuleSymbol {
  final String name;

  const RuleSymbol(this.name);

  @override
  bool operator ==(Object other) {
    return other is RuleSymbol && name == other.name;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, name);
  }

  @override
  String toString() => name;
}

class Nonterminal extends RuleSymbol {
  const Nonterminal(super.name);
}

class Terminal extends RuleSymbol {
  const Terminal(super.name);
}

const eof = Terminal("\$");
const epsilon = Terminal("");
