import '../abstract_syntax_tree/ast.dart';
import '../semantic_analysis/symbol_table.dart';

class Instance {
  final ClassDeclaration ref;
  final SymbolTable classSymbolTable;
  final Map<String, Object?> fields = {};

  Instance(this.ref, this.classSymbolTable);
}
