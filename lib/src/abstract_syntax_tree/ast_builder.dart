import '../syntactic_analysis/parser.dart';
import 'ast.dart';

class AstBuilder {
  const AstBuilder();

  Program build(ParseTreeNode root) => root.toStart();
}

extension on ParseTreeNode {
  Program toStart() {
    return Program(children[0].toDefinitions());
  }

  List<Declaration> toDefinitions() {
    if (children.isEmpty) {
      return [];
    }
    return [
      ...children[0].toDefinitions(),
      children[1].toDefinition(),
    ];
  }

  Declaration toDefinition() {
    final kind = children[0].symbol.name;
    return switch (kind) {
      "variableDeclaration" => children[0].toVariableDeclaration(),
      "functionDeclaration" => children[0].toFunctionDeclaration(),
      _ => throw UnimplementedError("Unsupported top-level definition: $kind")
    };
  }

  VariableDeclaration toVariableDeclaration() {
    final type = children[0].toType();
    final id = children[1].symbol.toString();
    final expression = children.elementAtOrNull(3)?.toExpression();
    return VariableDeclaration(id, type, expression);
  }

  FunctionDeclaration toFunctionDeclaration() {
    final type = children[0].toType();
    final id = children[1].symbol.toString();
    final parameters = children[3].toParameterList();
    final body = children[5].toFunctionBody();

    final functionType = FunctionType(
      parameters.map((e) => e.type).toList(),
      type,
    );
    final variable = VariableDeclaration(id, functionType);
    final function = FunctionNode(type, body, parameters: parameters);
    return FunctionDeclaration(variable, function);
  }

  List<VariableDeclaration> toParameterList() {
    if (children.isEmpty) {
      return [];
    }
    return children[0].toParameters();
  }

  List<VariableDeclaration> toParameters() {
    if (children.length == 1) {
      return [children[0].toParameter()];
    }
    return [
      ...children[0].toParameters(),
      children[2].toParameter(),
    ];
  }

  VariableDeclaration toParameter() {
    final type = children[0].toType();
    final id = children[1].symbol.toString();
    return VariableDeclaration(id, type);
  }

  Block toFunctionBody() {
    if (children.length == 1) {
      return children[0].toBlock();
    }
    return Block([ReturnStatement(children[1].toExpression())]);
  }

  TradType toType() {
    final kind = children[0].symbol.name;
    return switch (kind) {
      "num" => const NumType(),
      "int" => const IntType(),
      "double" => const DoubleType(),
      "String" => const StringType(),
      "bool" => const BoolType(),
      "List" => ListType(children[2].toType()),
      "void" => const VoidType(),
      _ => throw UnimplementedError("Unsupported type: $kind")
    };
  }

  Block toBlock() {
    final statements = children[1].toStatements();
    return Block(statements);
  }

  List<Statement> toStatements() {
    if (children.isEmpty) {
      return [];
    }
    return [
      ...children[0].toStatements(),
      children[1].toStatement(),
    ];
  }

  Statement toStatement() {
    final kind = children[0].symbol.name;
    return switch (kind) {
      "block" => children[0].toBlock(),
      "expressionStatement" => children[0].toExpressionStatement(),
      "returnStatement" => children[0].toReturnStatement(),
      "ifStatement" => children[0].toIfStatement(),
      "forStatement" => children[0].toForStatement(),
      "whileStatement" => children[0].toWhileStatement(),
      "breakStatement" => children[0].toBreakStatement(),
      "variableDeclaration" => children[0].toVariableDeclaration(),
      _ => throw UnimplementedError("Unsupported statement: $kind")
    };
  }

  ExpressionStatement toExpressionStatement() {
    return ExpressionStatement(children[0].toExpression());
  }

  ReturnStatement toReturnStatement() {
    if (children.length == 2) {
      return ReturnStatement();
    }
    return ReturnStatement(children[1].toExpression());
  }

  IfStatement toIfStatement() {
    final condition = children[2].toExpression();
    final then = children[4].toBlock();
    final otherwise = children[5].toElseStatement();
    return IfStatement(condition, then, otherwise);
  }

  Statement? toElseStatement() {
    final kind = children.elementAtOrNull(1)?.symbol.name;
    return switch (kind) {
      "ifStatement" => children[1].toIfStatement(),
      "block" => children[1].toBlock(),
      null => null,
      _ => throw UnimplementedError("Unsupported else statement: $kind")
    };
  }

  ForStatement toForStatement() {
    final variableDeclaration = children[2].toVariableDeclaration();
    final condition = children[3].toExpression();
    final increment = children[5].toExpression();
    final body = children[7].toBlock();
    return ForStatement(variableDeclaration, condition, increment, body);
  }

  WhileStatement toWhileStatement() {
    final condition = children[2].toExpression();
    final body = children[4].toBlock();
    return WhileStatement(condition, body);
  }

  BreakStatement toBreakStatement() {
    final kind = children[0].symbol.name;
    return switch (kind) {
      "break" => BreakStatement.break_(),
      "continue" => BreakStatement.continue_(),
      _ => throw UnimplementedError("Unsupported break statement: $kind")
    };
  }

  Expression toExpression() {
    final kind = children[0].symbol.name;
    return switch (kind) {
      "assignmentExpression" => children[0].toVariableSet(),
      "conditionalExpression" => children[0].toConditionalExpression(),
      _ => throw UnimplementedError("Unsupported expression: $kind")
    };
  }

  VariableSet toVariableSet() {
    final id = children[0].symbol.toString();
    final expression = children[2].toExpression();
    return VariableSet(id, expression);
  }

  Expression toConditionalExpression() {
    if (children.length == 1) {
      return children[0].toLogicalOrExpression();
    }

    final condition = children[0].toLogicalOrExpression();
    final then = children[2].toExpression();
    final otherwise = children[4].toExpression();
    return ConditionalExpression(condition, then, otherwise);
  }

  Expression toLogicalOrExpression() {
    if (children.length == 1) {
      return children[0].toLogicalAndExpression();
    }

    final left = children[0].toLogicalOrExpression();
    final right = children[2].toLogicalAndExpression();
    return LogicalOrExpression(left, "||", right);
  }

  Expression toLogicalAndExpression() {
    if (children.length == 1) {
      return children[0].toEqualityExpression();
    }

    final left = children[0].toLogicalAndExpression();
    final right = children[2].toEqualityExpression();
    return LogicalAndExpression(left, "&&", right);
  }

  Expression toEqualityExpression() {
    if (children.length == 1) {
      return children[0].toRelationalExpression();
    }

    final left = children[0].toRelationalExpression();
    final operator = children[1].symbol.name;
    final right = children[2].toRelationalExpression();
    return EqualityExpression(left, operator, right);
  }

  Expression toRelationalExpression() {
    if (children.length == 1) {
      return children[0].toAdditiveExpression();
    }

    final left = children[0].toAdditiveExpression();
    final operator = children[1].symbol.name;
    final right = children[2].toAdditiveExpression();
    return RelationalExpression(left, operator, right);
  }

  Expression toAdditiveExpression() {
    if (children.length == 1) {
      return children[0].toMultiplicativeExpression();
    }

    final left = children[0].toAdditiveExpression();
    final operator = children[1].symbol.name;
    final right = children[2].toMultiplicativeExpression();
    return AdditiveExpression(left, operator, right);
  }

  Expression toMultiplicativeExpression() {
    if (children.length == 1) {
      return children[0].toUnaryExpression();
    }

    final left = children[0].toMultiplicativeExpression();
    final operator = children[1].symbol.name;
    final right = children[2].toUnaryExpression();
    return MultiplicativeExpression(left, operator, right);
  }

  Expression toUnaryExpression() {
    if (children.length == 1) {
      return children[0].toPrimary();
    }

    final operator = children[0].symbol.name;
    final operand = children[1].toUnaryExpression();
    return UnaryExpression(operator, operand);
  }

  Expression toPrimary() {
    final kind = children[0].symbol.name;
    return switch (kind) {
      "literal" => children[0].toLiteral(),
      "id" => VariableGet(children[0].symbol.toString()),
      "(" => children[1].toExpression(),
      "functionInvocation" => children[0].toFunctionInvocation(),
      _ => throw UnimplementedError("Unsupported primary expression: $kind")
    };
  }

  Expression toLiteral() {
    final kind = children[0].symbol.name;
    return switch (kind) {
      "intLiteral" => IntLiteral(int.parse(children[0].symbol.toString())),
      "str" => StringLiteral(children[0].symbol.toString()),
      "true" => BoolLiteral(true),
      "false" => BoolLiteral(false),
      "listLiteral" => children[0].toListLiteral(),
      _ => throw UnimplementedError("Unsupported literal: $kind")
    };
  }

  ListLiteral toListLiteral() {
    if (children.length == 2) {
      return ListLiteral([]);
    }
    return ListLiteral(children[1].toExpressionList());
  }

  List<Expression> toExpressionList() {
    if (children.length == 1) {
      return [children[0].toExpression()];
    }
    return [
      ...children[0].toExpressionList(),
      children[2].toExpression(),
    ];
  }

  FunctionInvocation toFunctionInvocation() {
    final id = children[0].symbol.toString();
    final arguments = children[1].toArguments();
    return FunctionInvocation(id, arguments);
  }

  Arguments toArguments() {
    if (children.length == 2) {
      return Arguments.empty();
    }
    return Arguments(children[1].toExpressionList());
  }
}
