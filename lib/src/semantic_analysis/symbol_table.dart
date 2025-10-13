import '../abstract_syntax_tree/ast.dart';

class SymbolTableContext {
  final SymbolTable global;
  late SymbolTable current;

  SymbolTableContext() : global = SymbolTable() {
    current = global;
  }

  SymbolTableEntry? lookup(String name) {
    return current.lookup(name);
  }

  SymbolTableEntry mustLookup(String name) {
    return lookup(name) ?? (throw Exception("symbol '$name' is not defined"));
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
}

class SymbolTable {
  SymbolTable? parent;
  final Map<String, SymbolTableEntry> _entries = {};

  SymbolTable([this.parent]);

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

  SymbolTable copy([SymbolTable? parent]) {
    return SymbolTable(parent).._entries.addAll(_entries);
  }

  SymbolTableEntry? operator [](String name) => _entries[name];

  void operator []=(String name, SymbolTableEntry entry) {
    _entries[name] = entry;
  }
}
