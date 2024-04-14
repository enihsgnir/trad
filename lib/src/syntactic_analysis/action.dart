enum ActionType { shift, reduce, goto }

class Action {
  final ActionType type;
  final int value;

  const Action.shift(this.value) : type = ActionType.shift;
  const Action.reduce(this.value) : type = ActionType.reduce;
  const Action.goto(this.value) : type = ActionType.goto;

  static const accept = Action.reduce(0);

  @override
  bool operator ==(Object other) {
    return other is Action && type == other.type && value == other.value;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, type, value);
  }

  @override
  String toString() => "${type.name[0]}$value";
}
