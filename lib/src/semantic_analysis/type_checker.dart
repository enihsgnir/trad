import '../abstract_syntax_tree/ast.dart';
import '../abstract_syntax_tree/visitor.dart';

class TypeChecker extends RecursiveVisitor {
  const TypeChecker();

  @override
  void defaultTreeNode(TreeNode node) => node.visitChildren(this);

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    final initializer = node.initializer;
    if (initializer != null && node.type != initializer.staticType) {
      throw Exception("variable declaration type mismatch");
    }

    super.visitVariableDeclaration(node);
  }

  @override
  void visitReturnStatement(ReturnStatement node) {
    final function = node.enclosingFunctionNode;
    final expression = node.expression;
    if ((expression?.staticType ?? const VoidType()) != function.returnType) {
      throw Exception("return statement type mismatch");
    }

    super.visitReturnStatement(node);
  }

  @override
  void visitIfStatement(IfStatement node) {
    final condition = node.condition;
    if (condition.staticType != const BoolType()) {
      throw Exception("if statement condition type mismatch");
    }

    super.visitIfStatement(node);
  }

  @override
  void visitForStatement(ForStatement node) {
    final condition = node.condition;
    if (condition.staticType != const BoolType()) {
      throw Exception("for statement condition type mismatch");
    }

    super.visitForStatement(node);
  }

  @override
  void visitWhileStatement(WhileStatement node) {
    final condition = node.condition;
    if (condition.staticType != const BoolType()) {
      throw Exception("while statement condition type mismatch");
    }

    super.visitWhileStatement(node);
  }

  @override
  void visitVariableSet(VariableSet node) {
    if (node.staticType != node.value.staticType) {
      throw Exception("variable set type mismatch");
    }

    super.visitVariableSet(node);
  }

  // TODO: handle conditional expression
  // TODO: handle binary expressions

  @override
  void visitUnaryExpression(UnaryExpression node) {
    if (node.operator == "!" && node.operand.staticType != const BoolType()) {
      throw Exception("not operator type mismatch");
    }

    super.visitUnaryExpression(node);
  }

  @override
  void visitFunctionInvocation(FunctionInvocation node) {
    final parameters = node.functionType.parameters;
    final arguments = node.arguments;

    if (parameters.length != arguments.length) {
      throw Exception("argument count mismatch");
    }

    for (int i = 0; i < parameters.length; i++) {
      // TODO: handle dynamic type
      if (parameters[i] is DynamicType) {
        continue;
      }

      if (parameters[i] != arguments.positional[i].staticType) {
        throw Exception("argument type mismatch");
      }
    }

    super.visitFunctionInvocation(node);
  }
}
