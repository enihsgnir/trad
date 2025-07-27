import 'ast.dart';

abstract class ExpressionVisitor<R> {
  const ExpressionVisitor();

  R visitVariableGet(VariableGet node);
  R visitVariableSet(VariableSet node);
  R visitConditionalExpression(ConditionalExpression node);
  R visitBinaryExpression(BinaryExpression node);
  R visitLogicalOrExpression(LogicalOrExpression node);
  R visitLogicalAndExpression(LogicalAndExpression node);
  R visitUnaryExpression(UnaryExpression node);
  R visitIntLiteral(IntLiteral node);
  R visitStringLiteral(StringLiteral node);
  R visitBoolLiteral(BoolLiteral node);
  R visitListLiteral(ListLiteral node);
  R visitFunctionInvocation(FunctionInvocation node);
}

mixin ExpressionVisitorDefaultMixin<R> implements ExpressionVisitor<R> {
  R defaultExpression(Expression node);
  R defaultBasicLiteral(BasicLiteral node) => defaultExpression(node);

  @override
  R visitVariableGet(VariableGet node) => defaultExpression(node);
  @override
  R visitVariableSet(VariableSet node) => defaultExpression(node);
  @override
  R visitConditionalExpression(ConditionalExpression node) =>
      defaultExpression(node);
  @override
  R visitBinaryExpression(BinaryExpression node) => defaultExpression(node);
  @override
  R visitLogicalOrExpression(LogicalOrExpression node) =>
      defaultExpression(node);
  @override
  R visitLogicalAndExpression(LogicalAndExpression node) =>
      defaultExpression(node);
  @override
  R visitUnaryExpression(UnaryExpression node) => defaultExpression(node);
  @override
  R visitIntLiteral(IntLiteral node) => defaultBasicLiteral(node);
  @override
  R visitStringLiteral(StringLiteral node) => defaultBasicLiteral(node);
  @override
  R visitBoolLiteral(BoolLiteral node) => defaultBasicLiteral(node);
  @override
  R visitListLiteral(ListLiteral node) => defaultExpression(node);
  @override
  R visitFunctionInvocation(FunctionInvocation node) => defaultExpression(node);
}

abstract class StatementVisitor<R> {
  const StatementVisitor();

  R visitBlock(Block node);
  R visitExpressionStatement(ExpressionStatement node);
  R visitReturnStatement(ReturnStatement node);
  R visitIfStatement(IfStatement node);
  R visitForStatement(ForStatement node);
  R visitWhileStatement(WhileStatement node);
  R visitBreakStatement(BreakStatement node);
  R visitClassDeclaration(ClassDeclaration node);
  R visitVariableDeclaration(VariableDeclaration node);
  R visitFunctionDeclaration(FunctionDeclaration node);
}

mixin StatementVisitorDefaultMixin<R> implements StatementVisitor<R> {
  R defaultStatement(Statement node);

  @override
  R visitBlock(Block node) => defaultStatement(node);
  @override
  R visitExpressionStatement(ExpressionStatement node) =>
      defaultStatement(node);
  @override
  R visitReturnStatement(ReturnStatement node) => defaultStatement(node);
  @override
  R visitIfStatement(IfStatement node) => defaultStatement(node);
  @override
  R visitForStatement(ForStatement node) => defaultStatement(node);
  @override
  R visitWhileStatement(WhileStatement node) => defaultStatement(node);
  @override
  R visitBreakStatement(BreakStatement node) => defaultStatement(node);
  @override
  R visitClassDeclaration(ClassDeclaration node) => defaultStatement(node);
  @override
  R visitVariableDeclaration(VariableDeclaration node) =>
      defaultStatement(node);
  @override
  R visitFunctionDeclaration(FunctionDeclaration node) =>
      defaultStatement(node);
}

abstract class TreeVisitor<R>
    implements ExpressionVisitor<R>, StatementVisitor<R> {
  const TreeVisitor();

  R visitProgram(Program node);
  R visitFunctionNode(FunctionNode node);
  R visitArguments(Arguments node);
}

mixin TreeVisitorDefaultMixin<R> implements TreeVisitor<R> {
  R defaultTreeNode(TreeNode node);

  @override
  R visitProgram(Program node) => defaultTreeNode(node);
  @override
  R visitArguments(Arguments node) => defaultTreeNode(node);
  @override
  R visitFunctionNode(FunctionNode node) => defaultTreeNode(node);
}

abstract class TreeVisitorDefault<R>
    with
        ExpressionVisitorDefaultMixin<R>,
        StatementVisitorDefaultMixin<R>,
        TreeVisitorDefaultMixin<R>
    implements TreeVisitor<R> {
  const TreeVisitorDefault();

  @override
  R defaultExpression(Expression node) => defaultTreeNode(node);
  @override
  R defaultStatement(Statement node) => defaultTreeNode(node);
}

abstract class TradTypeVisitor<R> {
  const TradTypeVisitor();

  R visitDynamicType(DynamicType node);
  R visitNumType(NumType node);
  R visitIntType(IntType node);
  R visitDoubleType(DoubleType node);
  R visitStringType(StringType node);
  R visitBoolType(BoolType node);
  R visitListType(ListType node);
  R visitVoidType(VoidType node);
  R visitFunctionType(FunctionType node);
}

mixin TradTypeVisitorDefaultMixin<R> implements TradTypeVisitor<R> {
  R defaultTradType(TradType node);

  @override
  R visitDynamicType(DynamicType node) => defaultTradType(node);
  @override
  R visitNumType(NumType node) => defaultTradType(node);
  @override
  R visitIntType(IntType node) => defaultTradType(node);
  @override
  R visitDoubleType(DoubleType node) => defaultTradType(node);
  @override
  R visitStringType(StringType node) => defaultTradType(node);
  @override
  R visitBoolType(BoolType node) => defaultTradType(node);
  @override
  R visitListType(ListType node) => defaultTradType(node);
  @override
  R visitVoidType(VoidType node) => defaultTradType(node);
  @override
  R visitFunctionType(FunctionType node) => defaultTradType(node);
}

abstract class Visitor<R> implements TreeVisitor<R>, TradTypeVisitor<R> {}

mixin VisitorDefaultMixin<R> implements Visitor<R> {
  /// The catch-all case, except for references.
  R defaultNode(Node node);
}

abstract class VisitorDefault<R> extends TreeVisitorDefault<R>
    with VisitorDefaultMixin<R>, TradTypeVisitorDefaultMixin<R> {
  const VisitorDefault();

  @override
  R defaultTreeNode(TreeNode node) => defaultNode(node);

  @override
  R defaultTradType(TradType node) => defaultNode(node);
}

mixin VisitorVoidMixin implements VisitorDefault<void> {
  @override
  void defaultNode(Node node) {}
}

mixin VisitorNullMixin<R> implements VisitorDefault<R?> {
  @override
  R? defaultNode(Node node) => null;
}

class RecursiveVisitor extends VisitorDefault<void> with VisitorVoidMixin {
  const RecursiveVisitor();

  @override
  void defaultNode(Node node) => node.visitChildren(this);
}

class RecursiveResultVisitor<R> extends VisitorDefault<R?>
    with VisitorNullMixin<R> {
  const RecursiveResultVisitor();

  @override
  R? defaultNode(Node node) {
    node.visitChildren(this);
    return null;
  }
}
