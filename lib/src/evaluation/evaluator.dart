import 'package:collection/collection.dart';

import '../abstract_syntax_tree/ast.dart';
import '../abstract_syntax_tree/visitor.dart';
import '../semantic_analysis/symbol_table.dart';
import 'heap.dart';
import 'instance.dart';

const String _entryPoint = "main";

class Evaluator extends RecursiveResultVisitor {
  final _heap = Heap();

  Evaluator();

  @override
  void visitProgram(Program node) {
    super.visitProgram(node);

    final main = node.declarations
        .whereType<FunctionDeclaration>()
        .firstWhereOrNull((element) => element.variable.name == _entryPoint);

    if (main == null) {
      throw Exception("function '$_entryPoint' not found");
    }

    FunctionInvocation(
      main.variable.name,
      Arguments.empty(),
      functionType: const FunctionType([], VoidType()),
    ).accept(this);
  }

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final name = node.name;
    final entry = currentSymbolTable.lookup(name)!;

    final classSymbolTable = entry.classSymbolTable!;
    currentSymbolTable = classSymbolTable;
    super.visitClassDeclaration(node);
    currentSymbolTable = currentSymbolTable.parent!;
  }

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    final VariableDeclaration(:name, :initializer) = node;

    final entry = currentSymbolTable.lookup(name)!;
    if (initializer != null) {
      entry.reference = initializer.accept(this);
    }
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {}

  @override
  void visitBlock(Block node) {
    if (node.parent is! Block) {
      // Avoid duplicating symbol tables: outer constructs (e.g. functions,
      // for-loops) already create them. Only initialize a new table for inner
      // (nested) blocks.
      super.visitBlock(node);
      return;
    }

    final name = "block@${node.hashCode}";
    final entry = currentSymbolTable.lookup(name)!;

    final blockSymbolTable = entry.blockSymbolTable!;
    currentSymbolTable = blockSymbolTable;
    super.visitBlock(node);
    currentSymbolTable = currentSymbolTable.parent!;
  }

  @override
  Never visitReturnStatement(ReturnStatement node) {
    final expression = node.expression;
    if (expression == null) {
      throw const ReturnException();
    }

    final value = expression.accept(this);
    throw ReturnException(value);
  }

  @override
  void visitIfStatement(IfStatement node) {
    if (node.condition.accept(this) as bool) {
      node.then.accept(this);
      return;
    }
    node.otherwise?.accept(this);
  }

  @override
  void visitForStatement(ForStatement node) {
    final ForStatement(:initialization, :condition, :increment, :body) = node;

    initialization.accept(this);

    while (condition.accept(this) as bool) {
      try {
        body.accept(this);
      } on BreakException {
        break;
      } on ContinueException {
        continue;
      }

      increment.accept(this);
    }
  }

  @override
  void visitWhileStatement(WhileStatement node) {
    while (node.condition.accept(this) as bool) {
      try {
        node.body.accept(this);
      } on BreakException {
        break;
      } on ContinueException {
        continue;
      }
    }
  }

  @override
  Never visitBreakStatement(BreakStatement node) {
    throw node.isBreak ? BreakException() : ContinueException();
  }

  @override
  Object? visitVariableGet(VariableGet node) {
    final entry = currentSymbolTable.lookup(node.name)!;
    return entry.reference;
  }

  @override
  Object? visitVariableSet(VariableSet node) {
    final value = node.value.accept(this);
    currentSymbolTable.lookup(node.name)!.reference = value;
    return value;
  }

  @override
  Object? visitConditionalExpression(ConditionalExpression node) {
    if (node.condition.accept(this) as bool) {
      return node.then.accept(this);
    }
    return node.otherwise.accept(this);
  }

  @override
  bool visitLogicalOrExpression(LogicalOrExpression node) {
    if (node.left.accept(this) as bool) {
      return true;
    }
    return node.right.accept(this) as bool;
  }

  @override
  bool visitLogicalAndExpression(LogicalAndExpression node) {
    if (!(node.left.accept(this) as bool)) {
      return false;
    }
    return node.right.accept(this) as bool;
  }

  @override
  Object? visitBinaryExpression(BinaryExpression node) {
    final BinaryExpression(:left, :operator, :right) = node;

    if (operator == "!=") {
      return UnaryExpression(
        "!",
        EqualityExpression(left, "==", right),
      ).accept(this);
    }

    final name = "${left.staticType}.$operator";
    final entry = currentSymbolTable.lookup(name);
    if (entry == null) {
      throw Exception("binary operator '$operator' not defined");
    }

    final function = entry.builtInFunction;
    final lv = left.accept(this);
    final rv = right.accept(this);
    return Function.apply(function, [lv, rv]);
  }

  @override
  Object? visitUnaryExpression(UnaryExpression node) {
    final UnaryExpression(:operator, :operand) = node;
    final value = operand.accept(this);

    if (operator == "!") {
      if (value as bool) {
        return false;
      }
      return true;
    }

    final name = "${operand.staticType}.unary$operator";
    final entry = currentSymbolTable.lookup(name);
    if (entry == null) {
      throw Exception("unary operator '$operator' not defined");
    }

    final function = entry.builtInFunction;
    return Function.apply(function, [value]);
  }

  @override
  int visitIntLiteral(IntLiteral node) => node.value;

  @override
  String visitStringLiteral(StringLiteral node) => node.value;

  @override
  bool visitBoolLiteral(BoolLiteral node) => node.value;

  @override
  List visitListLiteral(ListLiteral node) {
    return node.expressions.map((e) => e.accept(this)).toList();
  }

  @override
  Object? visitFunctionInvocation(FunctionInvocation node) {
    final FunctionInvocation(:name, :arguments) = node;

    final entry = globalSymbolTable.lookup(name)!;
    final reference = entry.reference;
    if (reference is Function) {
      return Function.apply(
        reference,
        arguments.positional.map((e) => e.accept(this)).toList(),
      );
    }

    final functionSymbolTable = entry.functionSymbolTable!;
    final newSymbolTable = functionSymbolTable.copy(currentSymbolTable);

    final functionNode = entry.functionNode;
    for (final (i, param) in functionNode.parameters.indexed) {
      newSymbolTable[param.name] = SymbolTableEntry(
        param.type,
        arguments.positional[i].accept(this),
      );
    }
    currentSymbolTable = newSymbolTable;

    Object? value;
    try {
      // TODO: function call
      functionNode.body.accept(this);
    } on ReturnException catch (e) {
      value = e.value;
    }

    currentSymbolTable = currentSymbolTable.parent!;
    newSymbolTable.parent = null;

    return value;
  }

  @override
  int visitDefaultConstructorInvocation(DefaultConstructorInvocation node) {
    final classEntry = currentSymbolTable.lookup(node.className)!;
    final classRef = classEntry.reference! as ClassDeclaration;

    final instance = Instance(classRef);

    final fields = classRef.fields;
    for (final field in fields) {
      final name = field.name;
      final value = field.initializer?.accept(this);
      instance.fields[name] = value;
    }

    return _heap.allocate(instance);
  }

  @override
  Object? visitMemberVariableGet(MemberVariableGet node) {
    final receiver = node.receiver;
    if (receiver.staticType is! ClassType) {
      throw Exception("receiver is not an instance of a class");
    }

    final instanceId = node.receiver.accept(this) as int;
    final instance = _heap.get(instanceId)!;

    return instance.fields[node.name];
  }
}

class BreakException implements Exception {}

class ContinueException implements Exception {}

class ReturnException implements Exception {
  final Object? value;

  const ReturnException([this.value]);
}
