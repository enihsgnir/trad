import '../abstract_syntax_tree/ast.dart';

class Instance {
  final ClassDeclaration ref;
  final Map<String, Object?> fields = {};

  Instance(this.ref);
}
