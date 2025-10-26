import '../abstract_syntax_tree/ast.dart';
import '../abstract_syntax_tree/visitor.dart';
import 'symbol_table.dart';

class SymbolTableBuilder extends RecursiveVisitor {
  final SymbolTableContext context;

  const SymbolTableBuilder(this.context);

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final name = node.name;
    final entry = SymbolTableEntry(ClassType(name), node);
    context.define(name, entry);

    context.withChildScope(() {
      entry.classSymbolTable = context.current;
      super.visitClassDeclaration(node);
    });
  }

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    if (node.type == const VoidType()) {
      throw Exception("symbol type cannot be void");
    }

    final initializer = node.initializer;
    if (initializer != null && node.type != initializer.staticType) {
      throw Exception("type mismatch");
    }

    final entry = SymbolTableEntry(node.type, initializer);
    context.define(node.name, entry);
    super.visitVariableDeclaration(node);
  }

  @override
  void visitFunctionNode(FunctionNode node) {
    final function = node.parent! as FunctionDeclaration;
    final entry = context.mustLookup(function.variable.name);
    entry.reference = node;

    context.withChildScope(() {
      entry.functionSymbolTable = context.current;
      super.visitFunctionNode(node);
    });
  }

  @override
  void visitVariableGet(VariableGet node) {
    final entry = context.mustLookup(node.name);

    node.staticType = entry.type;

    super.visitVariableGet(node);
  }

  @override
  void visitVariableSet(VariableSet node) {
    final entry = context.mustLookup(node.name);

    if (entry.isFunction) {
      throw Exception("symbol ${node.name} is a function");
    }

    node.staticType = entry.type;

    super.visitVariableSet(node);
  }

  @override
  void visitBinaryExpression(BinaryExpression node) {
    super.visitBinaryExpression(node);

    final staticType = node.left.staticType;
    final operatorSymbol = node.operatorSymbol;

    if (operatorSymbol == "!=") {
      node.staticType = const BoolType();
      return;
    }

    final name = "$staticType.$operatorSymbol";
    final entry = context.mustLookupGlobal(name);

    final functionType = entry.type as FunctionType;
    node.staticType = functionType.returnType;
  }

  @override
  void visitUnaryExpression(UnaryExpression node) {
    super.visitUnaryExpression(node);

    final staticType = node.operand.staticType;
    final operatorSymbol = node.operatorSymbol;

    if (staticType is BoolType && operatorSymbol == "!") {
      node.staticType = const BoolType();
      return;
    }

    final name = "$staticType.unary$operatorSymbol";
    final entry = context.mustLookupGlobal(name);

    final functionType = entry.type as FunctionType;
    node.staticType = functionType.returnType;
  }

  @override
  void visitFunctionInvocation(FunctionInvocation node) {
    final entry = context.mustLookupGlobal(node.name);

    if (!entry.isFunction) {
      throw Exception("symbol ${node.name} is not a function");
    }

    node.functionType = entry.type as FunctionType;

    super.visitFunctionInvocation(node);
  }

  @override
  void visitBlock(Block node) {
    if (node.parent is! Block) {
      // Avoid duplicating symbol tables: outer constructs (e.g. functions,
      // for-loops) already create them. Only initialize a new table for inner
      // (nested) blocks.
      return super.visitBlock(node);
    }

    final name = "block@${identityHashCode(node)}";
    final entry = SymbolTableEntry(const VoidType());
    context.define(name, entry);

    context.withChildScope(() {
      entry.blockSymbolTable = context.current;
      super.visitBlock(node);
    });
  }
}
