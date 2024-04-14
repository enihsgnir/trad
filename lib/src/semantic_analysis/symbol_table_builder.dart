import '../abstract_syntax_tree/ast.dart';
import '../abstract_syntax_tree/visitor.dart';
import 'symbol_table.dart';

class SymbolTableBuilder extends RecursiveVisitor {
  const SymbolTableBuilder();

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    if (currentSymbolTable[node.name] != null) {
      throw Exception("symbol ${node.name} is already defined");
    }

    if (node.type == const VoidType()) {
      throw Exception("symbol type cannot be void");
    }

    final initializer = node.initializer;
    if (initializer != null && node.type != initializer.staticType) {
      throw Exception("type mismatch");
    }

    final entry = SymbolTableEntry(node.type, initializer);
    currentSymbolTable[node.name] = entry;
    super.visitVariableDeclaration(node);
  }

  @override
  void visitFunctionNode(FunctionNode node) {
    final function = node.parent! as FunctionDeclaration;
    final entry = globalSymbolTable.lookup(function.variable.name)!;
    entry.reference = node;

    currentSymbolTable = SymbolTable(currentSymbolTable);
    super.visitFunctionNode(node);
    currentSymbolTable = currentSymbolTable.parent!;
  }

  @override
  void visitVariableGet(VariableGet node) {
    final entry = currentSymbolTable.lookup(node.name);
    if (entry == null) {
      throw Exception("symbol ${node.name} is not defined");
    }

    node.staticType = entry.type;

    super.visitVariableGet(node);
  }

  @override
  void visitVariableSet(VariableSet node) {
    final entry = currentSymbolTable.lookup(node.name);
    if (entry == null) {
      throw Exception("symbol ${node.name} is not defined");
    }

    if (entry.isFunction) {
      throw Exception("symbol ${node.name} is a function");
    }

    node.staticType = entry.type;

    super.visitVariableSet(node);
  }

  @override
  void visitBinaryExpression(BinaryExpression node) {
    super.visitBinaryExpression(node);

    final name = "${node.left.staticType}::${node.operator}";
    final entry = globalSymbolTable.lookup(name);
    if (entry == null) {
      throw Exception("operator $name is not defined");
    }

    final functionType = entry.type as FunctionType;
    node.staticType = functionType.returnType;
  }

  @override
  void visitUnaryExpression(UnaryExpression node) {
    super.visitUnaryExpression(node);

    final name = "${node.operand.staticType}::unary::${node.operator}";
    final entry = globalSymbolTable.lookup(name);
    if (entry == null) {
      throw Exception("operator $name is not defined");
    }

    final functionType = entry.type as FunctionType;
    node.staticType = functionType.returnType;
  }

  @override
  void visitFunctionInvocation(FunctionInvocation node) {
    final entry = globalSymbolTable.lookup(node.name);
    if (entry == null) {
      throw Exception("symbol ${node.name} is not defined");
    }

    if (!entry.isFunction) {
      throw Exception("symbol ${node.name} is not a function");
    }

    node.functionType = entry.type as FunctionType;

    super.visitFunctionInvocation(node);
  }
}
