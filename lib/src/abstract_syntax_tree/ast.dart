import 'visitor.dart';

sealed class Node {
  const Node();

  R accept<R>(Visitor<R> v);
  void visitChildren(Visitor v);
}

sealed class TreeNode extends Node {
  TreeNode? parent;

  @override
  R accept<R>(TreeVisitor<R> v);
}

class Program extends TreeNode {
  final List<Declaration> declarations;

  Program(this.declarations) {
    setParents(declarations, this);
  }

  @override
  R accept<R>(TreeVisitor<R> v) => v.visitProgram(this);

  @override
  void visitChildren(Visitor v) {
    visitList(declarations, v);
  }
}

// Functions

class FunctionNode extends TreeNode {
  final TradType returnType;
  final List<VariableDeclaration> parameters;
  final Block body;

  FunctionNode(
    this.returnType,
    this.body, {
    List<VariableDeclaration>? parameters,
  }) : parameters = parameters ?? [] {
    setParents(this.parameters, this);
    body.parent = this;
  }

  @override
  R accept<R>(TreeVisitor<R> v) => v.visitFunctionNode(this);

  @override
  void visitChildren(Visitor v) {
    visitList(parameters, v);
    returnType.accept(v);
    body.accept(v);
  }
}

// Expressions

sealed class Expression extends TreeNode {
  TradType get staticType;

  @override
  R accept<R>(ExpressionVisitor<R> v);
}

class VariableGet extends Expression {
  @override
  TradType staticType = const DynamicType();

  final String name;

  VariableGet(this.name);

  @override
  R accept<R>(ExpressionVisitor<R> v) => v.visitVariableGet(this);

  @override
  void visitChildren(Visitor v) {}
}

class VariableSet extends Expression {
  @override
  TradType staticType = const DynamicType();

  final String name;
  final Expression value;

  VariableSet(this.name, this.value) {
    value.parent = this;
  }

  @override
  R accept<R>(ExpressionVisitor<R> v) => v.visitVariableSet(this);

  @override
  void visitChildren(Visitor v) {
    value.accept(v);
  }
}

class Arguments extends TreeNode {
  final List<Expression> positional;

  Arguments(this.positional) {
    setParents(positional, this);
  }

  Arguments.empty() : positional = [];

  int get length => positional.length;

  @override
  R accept<R>(TreeVisitor<R> v) => v.visitArguments(this);

  @override
  void visitChildren(Visitor v) {
    visitList(positional, v);
  }
}

class FunctionInvocation extends Expression {
  final String name;
  final Arguments arguments;
  FunctionType functionType;

  FunctionInvocation(
    this.name,
    this.arguments, {
    this.functionType = const FunctionType([]),
  }) {
    arguments.parent = this;
  }

  @override
  TradType get staticType => functionType.returnType;

  @override
  R accept<R>(ExpressionVisitor<R> v) => v.visitFunctionInvocation(this);

  @override
  void visitChildren(Visitor v) {
    arguments.accept(v);
    functionType.accept(v);
  }
}

class DefaultConstructorInvocation extends Expression {
  final String className;

  DefaultConstructorInvocation(this.className);

  @override
  TradType get staticType => ClassType(className);

  @override
  R accept<R>(ExpressionVisitor<R> v) =>
      v.visitDefaultConstructorInvocation(this);

  @override
  void visitChildren(Visitor v) {}
}

class MemberVariableGet extends Expression {
  final Expression receiver;
  final String name;

  MemberVariableGet(this.receiver, this.name) {
    receiver.parent = this;
  }

  @override
  TradType staticType = const DynamicType();

  @override
  R accept<R>(ExpressionVisitor<R> v) => v.visitMemberVariableGet(this);

  @override
  void visitChildren(Visitor v) {
    receiver.accept(v);
  }
}

class MemberVariableSet extends Expression {
  final Expression receiver;
  final String name;
  final Expression value;

  MemberVariableSet(this.receiver, this.name, this.value) {
    receiver.parent = this;
    value.parent = this;
  }

  @override
  TradType staticType = const DynamicType();

  @override
  R accept<R>(ExpressionVisitor<R> v) => v.visitMemberVariableSet(this);

  @override
  void visitChildren(Visitor v) {
    receiver.accept(v);
    value.accept(v);
  }
}

class MemberFunctionInvocation extends Expression {
  final Expression receiver;
  final String name;
  final Arguments arguments;
  FunctionType functionType;

  MemberFunctionInvocation(
    this.receiver,
    this.name,
    this.arguments, {
    this.functionType = const FunctionType([]),
  }) {
    receiver.parent = this;
    arguments.parent = this;
  }

  @override
  TradType get staticType => functionType.returnType;

  @override
  R accept<R>(ExpressionVisitor<R> v) => v.visitMemberFunctionInvocation(this);

  @override
  void visitChildren(Visitor v) {
    receiver.accept(v);
    arguments.accept(v);
    functionType.accept(v);
  }
}

class ConditionalExpression extends Expression {
  final Expression condition;
  final Expression then;
  final Expression otherwise;

  ConditionalExpression(
    this.condition,
    this.then,
    this.otherwise,
  ) {
    condition.parent = this;
    then.parent = this;
    otherwise.parent = this;
  }

  @override
  TradType get staticType => then.staticType;

  @override
  R accept<R>(ExpressionVisitor<R> v) => v.visitConditionalExpression(this);

  @override
  void visitChildren(Visitor v) {
    condition.accept(v);
    then.accept(v);
    otherwise.accept(v);
  }
}

sealed class BinaryExpression extends Expression {
  final Expression left;
  final String operatorSymbol;
  final Expression right;

  @override
  TradType staticType = const DynamicType();

  BinaryExpression(this.left, this.operatorSymbol, this.right) {
    left.parent = this;
    right.parent = this;
  }

  @override
  R accept<R>(ExpressionVisitor<R> v) => v.visitBinaryExpression(this);

  @override
  void visitChildren(Visitor v) {
    left.accept(v);
    right.accept(v);
  }
}

class LogicalOrExpression extends BinaryExpression {
  LogicalOrExpression(super.left, super.operatorSymbol, super.right);

  @override
  TradType get staticType => const BoolType();

  @override
  R accept<R>(ExpressionVisitor<R> v) => v.visitLogicalOrExpression(this);
}

class LogicalAndExpression extends BinaryExpression {
  LogicalAndExpression(super.left, super.operatorSymbol, super.right);

  @override
  TradType get staticType => const BoolType();

  @override
  R accept<R>(ExpressionVisitor<R> v) => v.visitLogicalAndExpression(this);
}

class EqualityExpression extends BinaryExpression {
  EqualityExpression(super.left, super.operatorSymbol, super.right);

  @override
  TradType get staticType => const BoolType();
}

class RelationalExpression extends BinaryExpression {
  RelationalExpression(super.left, super.operatorSymbol, super.right);

  @override
  TradType get staticType => const BoolType();
}

class AdditiveExpression extends BinaryExpression {
  AdditiveExpression(super.left, super.operatorSymbol, super.right);
}

class MultiplicativeExpression extends BinaryExpression {
  MultiplicativeExpression(super.left, super.operatorSymbol, super.right);
}

class UnaryExpression extends Expression {
  final String operatorSymbol;
  final Expression operand;

  @override
  TradType staticType = const DynamicType();

  UnaryExpression(this.operatorSymbol, this.operand) {
    operand.parent = this;
  }

  @override
  R accept<R>(ExpressionVisitor<R> v) => v.visitUnaryExpression(this);

  @override
  void visitChildren(Visitor v) {
    operand.accept(v);
  }
}

sealed class BasicLiteral extends Expression {
  Object? get value;

  @override
  void visitChildren(Visitor v) {}
}

class IntLiteral extends BasicLiteral {
  @override
  final int value;

  IntLiteral(this.value);

  @override
  TradType get staticType => const IntType();

  @override
  R accept<R>(ExpressionVisitor<R> v) => v.visitIntLiteral(this);
}

class StringLiteral extends BasicLiteral {
  @override
  final String value;

  StringLiteral(this.value);

  @override
  TradType get staticType => const StringType();

  @override
  R accept<R>(ExpressionVisitor<R> v) => v.visitStringLiteral(this);
}

class BoolLiteral extends BasicLiteral {
  @override
  final bool value;

  BoolLiteral(this.value);

  @override
  TradType get staticType => const BoolType();

  @override
  R accept<R>(ExpressionVisitor<R> v) => v.visitBoolLiteral(this);
}

class ListLiteral extends Expression {
  final TradType typeArgument;
  final List<Expression> expressions;

  ListLiteral(
    this.expressions, {
    this.typeArgument = const DynamicType(),
  }) {
    setParents(expressions, this);
  }

  @override
  TradType get staticType => ListType(typeArgument);

  @override
  R accept<R>(ExpressionVisitor<R> v) => v.visitListLiteral(this);

  @override
  void visitChildren(Visitor v) {
    typeArgument.accept(v);
    visitList(expressions, v);
  }
}

// Statements

sealed class Statement extends TreeNode {
  @override
  R accept<R>(StatementVisitor<R> v);
}

class ExpressionStatement extends Statement {
  final Expression expression;

  ExpressionStatement(this.expression) {
    expression.parent = this;
  }

  @override
  R accept<R>(StatementVisitor<R> v) => v.visitExpressionStatement(this);

  @override
  void visitChildren(Visitor v) {
    expression.accept(v);
  }
}

class Block extends Statement {
  final List<Statement> statements;

  Block(this.statements) {
    setParents(statements, this);
  }

  void addStatement(Statement node) {
    node.parent = this;
    statements.add(node);
  }

  @override
  R accept<R>(StatementVisitor<R> v) => v.visitBlock(this);

  @override
  void visitChildren(Visitor v) {
    visitList(statements, v);
  }
}

class BreakStatement extends Statement {
  final bool isBreak;

  BreakStatement(this.isBreak);
  BreakStatement.break_() : isBreak = true;
  BreakStatement.continue_() : isBreak = false;

  @override
  R accept<R>(StatementVisitor<R> v) => v.visitBreakStatement(this);

  @override
  void visitChildren(Visitor v) {}
}

class ForStatement extends Statement {
  final VariableDeclaration initialization;
  final Expression condition;
  final Expression increment;
  final Block body;

  ForStatement(this.initialization, this.condition, this.increment, this.body) {
    initialization.parent = this;
    condition.parent = this;
    increment.parent = this;
    body.parent = this;
  }

  @override
  R accept<R>(StatementVisitor<R> v) => v.visitForStatement(this);

  @override
  void visitChildren(Visitor v) {
    initialization.accept(v);
    condition.accept(v);
    increment.accept(v);
    body.accept(v);
  }
}

class WhileStatement extends Statement {
  final Expression condition;
  final Statement body;

  WhileStatement(this.condition, this.body) {
    condition.parent = this;
    body.parent = this;
  }

  @override
  R accept<R>(StatementVisitor<R> v) => v.visitWhileStatement(this);

  @override
  void visitChildren(Visitor v) {
    condition.accept(v);
    body.accept(v);
  }
}

class IfStatement extends Statement {
  final Expression condition;
  final Block then;
  final Statement? otherwise;

  IfStatement(this.condition, this.then, this.otherwise) {
    condition.parent = this;
    then.parent = this;
    otherwise?.parent = this;
  }

  @override
  R accept<R>(StatementVisitor<R> v) => v.visitIfStatement(this);

  @override
  void visitChildren(Visitor v) {
    condition.accept(v);
    then.accept(v);
    otherwise?.accept(v);
  }
}

class ReturnStatement extends Statement {
  final Expression? expression;

  ReturnStatement([this.expression]) {
    expression?.parent = this;
  }

  FunctionNode get enclosingFunctionNode {
    TreeNode? node = parent;
    while (node != null) {
      if (node is FunctionNode) {
        return node;
      }
      node = node.parent;
    }
    throw Exception("Return statement not inside a function node");
  }

  @override
  R accept<R>(StatementVisitor<R> v) => v.visitReturnStatement(this);

  @override
  void visitChildren(Visitor v) {
    expression?.accept(v);
  }
}

sealed class Declaration extends Statement {
  @override
  R accept<R>(StatementVisitor<R> v);
}

class ClassDeclaration extends Declaration {
  final String name;
  final List<ClassMemberDeclaration> members;

  ClassDeclaration(this.name, this.members) {
    setParents(members, this);
  }

  List<VariableDeclaration> get fields =>
      members.whereType<VariableDeclaration>().toList();
  List<FunctionDeclaration> get methods =>
      members.whereType<FunctionDeclaration>().toList();

  @override
  R accept<R>(StatementVisitor<R> v) => v.visitClassDeclaration(this);

  @override
  void visitChildren(Visitor v) {
    visitList(members, v);
  }
}

mixin ClassMemberDeclaration on Declaration {}

class VariableDeclaration extends Declaration with ClassMemberDeclaration {
  final String name;
  final TradType type;
  final Expression? initializer;

  VariableDeclaration(
    this.name, [
    this.type = const DynamicType(),
    this.initializer,
  ]) {
    initializer?.parent = this;
  }

  @override
  R accept<R>(StatementVisitor<R> v) => v.visitVariableDeclaration(this);

  @override
  void visitChildren(Visitor v) {
    type.accept(v);
    initializer?.accept(v);
  }
}

class FunctionDeclaration extends Declaration with ClassMemberDeclaration {
  final VariableDeclaration variable; // Is final and has no initializer.
  final FunctionNode function;

  FunctionDeclaration(this.variable, this.function) {
    variable.parent = this;
    function.parent = this;
  }

  @override
  R accept<R>(StatementVisitor<R> v) => v.visitFunctionDeclaration(this);

  @override
  void visitChildren(Visitor v) {
    variable.accept(v);
    function.accept(v);
  }
}

// Types

sealed class TradType extends Node {
  const TradType();

  @override
  R accept<R>(TradTypeVisitor<R> v);
}

class DynamicType extends TradType {
  const DynamicType();

  @override
  R accept<R>(TradTypeVisitor<R> v) => v.visitDynamicType(this);

  @override
  void visitChildren(Visitor v) {}

  @override
  String toString() => "dynamic";
}

class NumType extends TradType {
  const NumType();

  @override
  R accept<R>(TradTypeVisitor<R> v) => v.visitNumType(this);

  @override
  void visitChildren(Visitor v) {}

  @override
  String toString() => "num";
}

class IntType extends TradType {
  const IntType();

  @override
  R accept<R>(TradTypeVisitor<R> v) => v.visitIntType(this);

  @override
  void visitChildren(Visitor v) {}

  @override
  String toString() => "int";
}

class DoubleType extends TradType {
  const DoubleType();

  @override
  R accept<R>(TradTypeVisitor<R> v) => v.visitDoubleType(this);

  @override
  void visitChildren(Visitor v) {}

  @override
  String toString() => "double";
}

class StringType extends TradType {
  const StringType();

  @override
  R accept<R>(TradTypeVisitor<R> v) => v.visitStringType(this);

  @override
  void visitChildren(Visitor v) {}

  @override
  String toString() => "String";
}

class BoolType extends TradType {
  const BoolType();

  @override
  R accept<R>(TradTypeVisitor<R> v) => v.visitBoolType(this);

  @override
  void visitChildren(Visitor v) {}

  @override
  String toString() => "bool";
}

class ListType extends TradType {
  final TradType typeArgument;

  const ListType(this.typeArgument);

  @override
  R accept<R>(TradTypeVisitor<R> v) => v.visitListType(this);

  @override
  void visitChildren(Visitor v) {
    typeArgument.accept(v);
  }

  @override
  String toString() => "List<$typeArgument>";
}

class VoidType extends TradType {
  const VoidType();

  @override
  R accept<R>(TradTypeVisitor<R> v) => v.visitVoidType(this);

  @override
  void visitChildren(Visitor v) {}

  @override
  String toString() => "void";
}

class FunctionType extends TradType {
  final List<TradType> parameters;
  final TradType returnType;

  const FunctionType(this.parameters, [this.returnType = const DynamicType()]);

  int get parameterCount => parameters.length;

  @override
  R accept<R>(TradTypeVisitor<R> v) => v.visitFunctionType(this);

  @override
  void visitChildren(Visitor v) {
    visitList(parameters, v);
    returnType.accept(v);
  }

  @override
  String toString() {
    final params = parameters.join(", ");
    return "$returnType Function($params)";
  }
}

class ClassType extends TradType {
  final String name;

  const ClassType(this.name);

  @override
  R accept<R>(TradTypeVisitor<R> v) => v.visitClassType(this);

  @override
  void visitChildren(Visitor v) {}

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) {
    return other is ClassType && other.name == name;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, name);
  }
}

// Internal Functions

void setParents(List<TreeNode> nodes, TreeNode parent) {
  for (final node in nodes) {
    node.parent = parent;
  }
}

void visitList(List<Node> nodes, Visitor visitor) {
  for (final node in nodes) {
    node.accept(visitor);
  }
}
