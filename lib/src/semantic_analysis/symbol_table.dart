import '../abstract_syntax_tree/ast.dart';

class SymbolTableContext {
  final SymbolTable global;
  late SymbolTable current;

  SymbolTableContext() : global = SymbolTable._() {
    current = global;
  }

  SymbolTableEntry? lookup(String name) {
    return current.lookup(name);
  }

  SymbolTableEntry mustLookup(String name) {
    return lookup(name) ?? (throw Exception("symbol '$name' is not defined"));
  }

  SymbolTableEntry? lookupGlobal(String name) {
    return global.lookup(name);
  }

  SymbolTableEntry mustLookupGlobal(String name) {
    return lookupGlobal(name) ??
        (throw Exception("symbol '$name' is not defined in global scope"));
  }

  SymbolTableEntry? lookupLocal(String name) {
    return current[name];
  }

  SymbolTableEntry mustLookupLocal(String name) {
    return lookupLocal(name) ??
        (throw Exception("symbol '$name' is not defined in local scope"));
  }

  void define(String name, SymbolTableEntry entry) {
    if (current[name] != null) {
      throw Exception("symbol '$name' is already defined");
    }

    current[name] = entry;
  }

  void assign(String name, Object? reference) {
    final entry = mustLookup(name);
    entry.reference = reference;
  }

  void assignLocal(String name, Object? reference) {
    final entry = mustLookupLocal(name);
    entry.reference = reference;
  }
}

class SymbolTableEntry {
  final TradType type;
  Object? reference;
  SymbolTable? classSymbolTable;
  SymbolTable? functionSymbolTable;
  SymbolTable? blockSymbolTable;

  SymbolTableEntry(this.type, [this.reference]);

  bool get isFunction => type is FunctionType;
  bool get isUndetermined => reference == null;

  FunctionNode get functionNode => reference! as FunctionNode;
  Function get builtInFunction => reference! as Function;

  SymbolTableEntry copy() {
    return SymbolTableEntry(type, reference)
      ..classSymbolTable = classSymbolTable
      ..functionSymbolTable = functionSymbolTable
      ..blockSymbolTable = blockSymbolTable;
  }
}

class SymbolTable {
  SymbolTable? parent;
  final Map<String, SymbolTableEntry> _entries = {};

  SymbolTable._([this.parent]);

  // TODO: migrate remaining direct lookups on specific `SymbolTable` instances
  //  to use `SymbolTableContext` for full consistency.
  SymbolTableEntry? lookup(String name) {
    SymbolTable? table = this;
    while (table != null) {
      final entry = table[name];
      if (entry != null) {
        return entry;
      }

      table = table.parent;
    }
    return null;
  }

  SymbolTable createChild() {
    return SymbolTable._(this);
  }

  SymbolTable copy(SymbolTable original) {
    return SymbolTable._(this)
      .._entries.addAll({
        for (final MapEntry(:key, :value) in original._entries.entries)
          key: value.copy(),
      });
  }

  SymbolTableEntry? operator [](String name) => _entries[name];

  void operator []=(String name, SymbolTableEntry entry) {
    _entries[name] = entry;
  }
}

extension SymbolTableScopeExtension on SymbolTableContext {
  void withChildScope(void Function() action) {
    final previous = current;
    current = current.createChild();
    try {
      action();
    } finally {
      current = previous;
    }
  }

  void withTargetScope(SymbolTable target, void Function() action) {
    final previous = current;
    current = target;
    try {
      action();
    } finally {
      current = previous;
    }
  }

  void withCopiedScope(SymbolTable original, void Function() action) {
    final previous = current;
    current = current.copy(original);
    try {
      action();
    } finally {
      current = previous;
    }
  }
}
